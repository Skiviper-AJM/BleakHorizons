extends CharacterBody3D


@onready var animation_tree = get_node("AnimationTree")
@onready var playback = animation_tree.get("parameters/playback")

@onready var player_mesh = get_node("Knight") #sets mesh to knights node so the whole character doesnt rotate, prevents weird camera jank


@export var gravity: float = 9.8
@export var jump_force: int = 9
@export var walk_speed: int = 3
@onready var run_speed: int = (walk_speed * 3) #run speed is automatically set to tripple the walk speed


#anim node names
var idle_node_name:String = "Idle"
var walk_node_name:String = "Walk"
var run_node_name:String = "Run"
var jump_node_name:String = "Jump"
var attack1_node_name:String = "Attack1"
var death_node_name:String = "Death_A"

#state machine
var is_attacking: bool
var is_walking: bool
var is_running: bool
var is_dying: bool

#physics vals
var direction: Vector3
var horizontal_velocity: Vector3
var aim_turn: float
var movement: Vector3
var vertical_velocity: Vector3
var movement_speed: int
var angular_acceleration: int
var acceleration: int
var just_hit:bool = false

const MAX_STEP_HEIGHT = 0.5
var _snapped_to_stairs_last_frame := false
var _last_frame_was_on_floor = -INF


@onready var camrot_h = get_node("camroot/h")
@onready var campos_v = get_node("camroot")

func _ready() -> void:
	
	direction = Vector3.BACK.rotated(Vector3.UP, camrot_h.global_transform.basis.get_euler().y)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		aim_turn = -event.relative.x * 0.15
	
	# controls aiming ranged weapons - add a tag to check if its a ranged weapon!
	if event.is_action_pressed("LockOn"): #aim
		direction = camrot_h.global_transform.basis.z
	

#checks stair max angle
func is_surface_too_steep(normal: Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle


#snaps down the stairs the frame after they are left
func _snap_down_to_stairs_check() -> void:
	var did_snap := false
	var floor_below = %StairsBelowRayCast3D.is_colliding() and not is_surface_too_steep(%StairsBelowRayCast3D.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() - _last_frame_was_on_floor == 1
	
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_last_frame) and floor_below:
		var body_test_result = PhysicsTestMotionResult3D.new()
		if _run_body_test_motion(self.global_transform, Vector3(0,-MAX_STEP_HEIGHT,0), body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
		_snapped_to_stairs_last_frame = did_snap

func _snap_up_stairs_check(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_last_frame: return false
	var expected_move_motion = self.velocity * Vector3(1,0,1) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_move_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	
	var down_check_result = PhysicsTestMotionResult3D.new()
	if (_run_body_test_motion(step_pos_with_clearance, Vector3(0,-MAX_STEP_HEIGHT*2, 0), down_check_result)
	and (down_check_result.get_collider().is_class("StaticBody3D") or down_check_result.get_collider().is_class("GridMap"))):
		var step_height = ((step_pos_with_clearance.origin + down_check_result.get_travel()) - self.global_position).y
		
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check_result.get_collision_point() - self.global_position).y > MAX_STEP_HEIGHT: return false
		%StairsAheadRayCast3D.global_position = down_check_result.get_collision_point() + Vector3(0, MAX_STEP_HEIGHT, 0) + expected_move_motion.normalized() * 0.1
		%StairsAheadRayCast3D.force_raycast_update()
		if %StairsAheadRayCast3D.is_colliding() and not is_surface_too_steep(%StairsAheadRayCast3D.get_collision_normal()):
			self.global_position = step_pos_with_clearance.origin + down_check_result.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_last_frame = true
			return true
	return false
		
func _run_body_test_motion(from : Transform3D, motion : Vector3, result = null) -> bool:
	if not result: result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)

func _physics_process(delta: float) -> void:
	#calls a built in function to get a simple true/false on wether the player is touching the ground
	var on_floor = is_on_floor()
	
	if !is_dying:
		
		#check for stair snapping
		if on_floor:
			_last_frame_was_on_floor = Engine.get_physics_frames()
		
		#checks states
		attack1()
		
		
		#gravity to stick you to the floor
		if !on_floor:
			vertical_velocity += Vector3.DOWN*gravity*2*delta
		else: 
			vertical_velocity = Vector3.DOWN*gravity/10 #the /10 is needed for nice scaling using the gravity var
		
		#jumping logic
		if Input.is_action_just_pressed("Jump") and (!is_attacking) and on_floor:
			vertical_velocity = Vector3.UP*jump_force #jump strength is set by jump_force
		
		#test values
		angular_acceleration = 10
		movement_speed = 0
		acceleration = 15
		
		#checks when the attack animation is playing to determine behaviour
		if (attack1_node_name in playback.get_current_node()):
			is_attacking = true
		else:
			is_attacking = false
		
		var h_rot = camrot_h.global_transform.basis.get_euler().y
		
		#handles WASD angle input direction
		if (Input.is_action_pressed("MoveForward") || Input.is_action_pressed("MoveBack") || Input.is_action_pressed("MoveLeft") || Input.is_action_pressed("MoveRight")):
			#subtracts opposing directions by each other when pressed simultaniously to prevent moving 
			
			direction = Vector3(Input.get_action_strength("MoveLeft") - Input.get_action_strength("MoveRight"), 
						0,
						Input.get_action_strength("MoveForward") - Input.get_action_strength("MoveBack"))
			direction = direction.rotated(Vector3.UP, h_rot).normalized()
			
			
			
			#handled running logic
			if Input.is_action_pressed("Run") and (on_floor) and (is_walking) and (!is_attacking):
					movement_speed = run_speed
					is_running = true
			elif (!on_floor) and (is_running):
				movement_speed = run_speed
			else:
				movement_speed = walk_speed
				is_walking = true
				is_running = false
		else:
			
			is_walking = false
			is_running = false
			
		if Input.is_action_pressed("LockOn"): #aim
			player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, camrot_h.rotation.y, delta*angular_acceleration)
		else: 
			player_mesh.rotation.y = lerp_angle(player_mesh.rotation.y, atan2(direction.x, direction.z) - rotation.y, delta*angular_acceleration)
		
		#sets player movement (slows down while by 3x attacking)
		if is_attacking:
				horizontal_velocity = horizontal_velocity.lerp(direction.normalized()*(movement_speed/3), acceleration*delta)
		else:
				horizontal_velocity = horizontal_velocity.lerp(direction.normalized()*movement_speed, acceleration*delta)

		velocity.z = horizontal_velocity.z + vertical_velocity.z
		velocity.x = horizontal_velocity.x + vertical_velocity.x
		velocity.y = vertical_velocity.y
		
		if not _snap_up_stairs_check(delta):
			move_and_slide()
			_snap_down_to_stairs_check()


	
	
	
	#binds the animation trees conditions to the ones in this script
	animation_tree["parameters/conditions/IsOnFloor"] = on_floor
	animation_tree["parameters/conditions/IsInAir"] = !on_floor and not _snapped_to_stairs_last_frame
	animation_tree["parameters/conditions/IsWalking"] = is_walking
	animation_tree["parameters/conditions/IsNotWalking"] = !is_walking
	animation_tree["parameters/conditions/IsRunning"] = is_running
	animation_tree["parameters/conditions/IsNotRunning"] = !is_running
	animation_tree["parameters/conditions/is_dying"] = is_dying

func attack1():
	if (idle_node_name in playback.get_current_node()) or (walk_node_name in playback.get_current_node()) or (run_node_name in playback.get_current_node()):
		
		if Input.is_action_just_pressed("Skill"):
			if !is_attacking:
				playback.travel(attack1_node_name)


func _on_damage_detector_body_entered(body):
	
	if body.is_in_group("monster") and is_attacking:
		body.hit(3)

func hit(damage):
		
	if !just_hit:
		get_node("just_hit").start()
		PlayerData.player_health -= damage
		just_hit = true
		if PlayerData.player_health <= 0:
			is_dying = true
			playback.travel(death_node_name)
			get_node("../Game Over Overlay").game_over()
		#knockback
		var tween = create_tween()
		tween.tween_property(self, "global_position", global_position - (direction/1.5), 0.2)
		



func _on_just_hit_timeout():
	just_hit = false
