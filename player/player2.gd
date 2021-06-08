extends KinematicBody

var direction = Vector3()
var velocity = Vector3.ZERO

var gravity_vector = Vector3()
export var gravity = 5
export var air_gravity = 7.0
export var floor_gravity = 1.0
export var floor_speed = 1.0

onready var raycast_pos = $raycast_pos
export var raycast_pos_stand_height = 3.082
export var raycast_pos_crouch_height = 0.993

onready var player_cam = $Camera
export var player_cam_stand_height = 1.6#3.117
export var player_cam_crouch_height = 1.757

onready var sprint_sound_area = load("res://player_sound_area/player_sprint_sound_area.tscn")

#export var mouse_sensitivity = 0.1

var z_input = 0
var x_input = 0

var movement_speed = 0
export var walk_speed = 1.2
export var run_speed = 2.8

export var run_mode = false
export var crouch_mode = false

export var active = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	raycast_pos.transform.origin.y = raycast_pos_stand_height
	#player_cam.transform.origin.y = player_cam_stand_height

func _physics_process(delta):
	
	if active:
	
		direction = Vector3()
		
		if run_mode:
			movement_speed = run_speed
		else:
			movement_speed = walk_speed
		
		if x_input != 0 or z_input != 0: # 이동중일때
			if run_mode:
				
				if !$walking_sound_timer.is_stopped():
					$walking_sound_timer.stop()
					$walking_sound_player.stream = load("res://sfx/player_walking_01.wav")
				
				if $sprint_sound_timer.is_stopped():
					$sprint_sound_timer.start()
					$sprint_sound_player.play()
					create_sprint_area()
			
			else: #걷는중일때
				
				if !$sprint_sound_timer.is_stopped():
					$sprint_sound_timer.stop()
					$sprint_sound_player.stream = load("res://sfx/player_sprint_01.wav")
				
				if $walking_sound_timer.is_stopped():
					$walking_sound_timer.start()
					$walking_sound_player.play()
		
		else: # 이동을 멈췄을떄
			if !$sprint_sound_timer.is_stopped():
				$sprint_sound_timer.stop()
				$sprint_sound_player.stream = load("res://sfx/player_sprint_01.wav")
				
			if !$walking_sound_timer.is_stopped():
				$walking_sound_timer.stop()
				$walking_sound_player.stream = load("res://sfx/player_walking_01.wav")
		
		if is_on_floor():
			gravity_vector = -get_floor_normal() * floor_gravity
		else:
			gravity_vector += Vector3.DOWN * air_gravity * delta
			gravity_vector.y = clamp(gravity_vector.y, -7.0, 0.0)
		
		direction += transform.basis.z * z_input
		direction += transform.basis.x * x_input
		
		direction = direction.normalized()
		direction = direction * movement_speed
		direction.x += gravity_vector.x
		direction.z += gravity_vector.z
		direction.y = gravity_vector.y
		
		move_and_slide(direction, Vector3.UP)
		
	pass

func _unhandled_input(event):
	
	if event is InputEventKey:
	
		if Input.is_action_pressed("move_foward"):
			z_input = -1
		elif Input.is_action_pressed("move_backward"):
			z_input = 1
		else:
			z_input = 0
		
		if Input.is_action_pressed("move_left"):
			x_input = -1
		elif Input.is_action_pressed("move_right"):
			x_input = 1
		else:
			x_input = 0
		
		if Input.is_action_pressed("sprint"):
			run_mode = true
		else:
			run_mode = false
		
		if Input.is_action_just_pressed("crouch"):
			
			crouch_mode = !crouch_mode
			
			if crouch_mode:
				raycast_pos.transform.origin.y = raycast_pos_crouch_height
				player_cam.transform.origin.y = player_cam_crouch_height
			else:
				raycast_pos.transform.origin.y = raycast_pos_stand_height
				player_cam.transform.origin.y = player_cam_stand_height

func player_active():
	active = true
	$Camera2.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func only_player_active():
	active = true

func player_deactive():
	active = false
	run_mode = false
	x_input = 0
	z_input = 0

func _on_walking_sound_timer_timeout():
	if $walking_sound_player.stream == load("res://sfx/player_walking_01.wav"):
		$walking_sound_player.stream = load("res://sfx/player_walking_02.wav")
	else:
		$walking_sound_player.stream = load("res://sfx/player_walking_01.wav")
	$walking_sound_player.play()
	pass # Replace with function body.

func _on_sprint_sound_timer_timeout():
	if $sprint_sound_player.stream == load("res://sfx/player_sprint_01.wav"):
		$sprint_sound_player.stream = load("res://sfx/player_sprint_02.wav")
	else:
		$sprint_sound_player.stream = load("res://sfx/player_sprint_01.wav")
	$sprint_sound_player.play()
	create_sprint_area()
	pass # Replace with function body.

func create_sprint_area():
	var sound_area = sprint_sound_area.instance()
	get_parent().add_child(sound_area)
	sound_area.global_transform.origin = global_transform.origin

