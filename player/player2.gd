extends KinematicBody

var direction = Vector3()
var velocity = Vector3.ZERO
var snap
var moment

var gravity_vector = Vector3()
export var gravity = 5
export var air_gravity = 7.0
export var floor_gravity = 1.0
export var floor_speed = 1.0

export var current_stamina = 100
export var max_stamina = 100

onready var raycast_pos = $raycast_pos
export var raycast_pos_stand_height = 3.082
export var raycast_pos_crouch_height = 0.993

onready var player_cam = $cam
export var player_cam_stand_height = 1.6#3.117
export var player_cam_crouch_height = 1.757

onready var sprint_sound_area = load("res://player_sound_area/player_sprint_sound_area.tscn")
onready var letter_box = $CanvasLayer/Control/letter_box

#export var mouse_sensitivity = 0.1

var z_input = 0
var x_input = 0

var movement_speed = 0
export var walk_speed = 1.2
export var run_speed = 2.8

export var run_mode = false
export var crouch_mode = false

export var active = false

onready var inventory = GlobalRef.inventory
#onready var quick_slot_manager = get_node("CanvasLayer/Control/quick_slot_manager")

func _ready():
	GlobalRef.player = self
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	raycast_pos.transform.origin.y = raycast_pos_stand_height
	Input.is_action_just_pressed("inventory")
	#player_cam.transform.origin.y = player_cam_stand_height

func _physics_process(delta):
	$CanvasLayer/Control/locale.text = TranslationServer.get_locale()
	if active:
	
		direction = Vector3.ZERO
		
		if crouch_mode:
			movement_speed = walk_speed / 2.4
		else:
			if run_mode:
				if current_stamina > 0:
					movement_speed = run_speed
				else:
					run_mode = false
			else:
				movement_speed = walk_speed
		
		if !run_mode and current_stamina < max_stamina:
			current_stamina = min(current_stamina + .05, max_stamina)
		elif run_mode and current_stamina > 0:
			current_stamina = max(current_stamina - .1, 0)
		#$CanvasLayer/Control/stamina_label.text = str(current_stamina)
		$CanvasLayer/Control/stamina_bar.value = current_stamina
		
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
			snap = -get_floor_normal()
			gravity_vector = Vector3.ZERO#-get_floor_normal() * floor_gravity
		else:
			snap = Vector3.DOWN
			gravity_vector += Vector3.DOWN * air_gravity * delta
			gravity_vector.y = clamp(gravity_vector.y, -7.0, 0.0)
		
		var h_rot = global_transform.basis.get_euler().y
		direction = Vector3(x_input, 0, z_input).rotated(Vector3.UP, h_rot).normalized()
		
		direction += transform.basis.z * z_input
		direction += transform.basis.x * x_input
		
		direction = direction.normalized()
		velocity = direction * movement_speed + gravity_vector
		#velocity.x += gravity_vector.x
		#velocity.z += gravity_vector.z
		#velocity.y = gravity_vector.y
		#moment = velocity + gravity_vector
		
		#move_and_slide(direction, Vector3.UP)
		move_and_slide_with_snap(velocity, snap, Vector3.UP)
		
	pass

func _unhandled_input(event):
	
	#if event is InputEventKey:
	
		#if Input.is_action_pressed("move_foward"):
		#	z_input = -1
		#elif Input.is_action_pressed("move_backward"):
		#	z_input = 1
		#else:
		#	z_input = 0
		z_input = Input.get_action_strength("move_backward") - Input.get_action_strength("move_foward")
		
		#if Input.is_action_pressed("move_left"):
		#	x_input = -1
		#elif Input.is_action_pressed("move_right"):
		#	x_input = 1
		#else:
		#	x_input = 0
		x_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		
		if Input.is_action_just_pressed("sprint"):
			if crouch_mode:
				crouch_mode = false
				raycast_pos.transform.origin.y = raycast_pos_stand_height
				player_cam.transform.origin.y = player_cam_stand_height
			if current_stamina > 0:
				run_mode = true
		if Input.is_action_just_released("sprint"):
			run_mode = false
		
		#if Input.is_action_just_pressed("move_foward"):
		#	print("..")
		#	if event is InputEventMouseButton:
		#		if event.button_index == BUTTON_RIGHT:
		#			if !run_mode and event.doubleclick:
		#				run_mode = true
		#			elif run_mode and !event.pressed:
		#				run_mode = true
				#run_mode = Input.is_action_pressed("sprint")
		#else:
		#	print("11")
		
		if Input.is_action_just_pressed("crouch"):
			if event is InputEventKey:
				crouch_mode = !crouch_mode
			else:
				if event.button_index == BUTTON_WHEEL_DOWN and !crouch_mode:
					crouch_mode = true
				elif event.button_index == BUTTON_WHEEL_UP and crouch_mode:
					crouch_mode = false
			
			if crouch_mode:
				raycast_pos.transform.origin.y = raycast_pos_crouch_height
				player_cam.transform.origin.y = player_cam_crouch_height
			else:
				raycast_pos.transform.origin.y = raycast_pos_stand_height
				player_cam.transform.origin.y = player_cam_stand_height
		
		if Input.is_action_just_pressed("inventory"):
			if !inventory.visible:
				if !GlobalRef.quick_slot_manager.visible:
					GlobalRef.inventory.popup()
					#inventory.show()
					#inventory.grab_focus()
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					$CanvasLayer/Control/inventory/inventory_open_sfx.play()
				
			#else:
			#	inventory.hide()
			#	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		
		if Input.is_action_just_pressed("radial_menu"):
			if !GlobalRef.quick_slot_manager.visible:
				if !GlobalRef.inventory.visible:
					GlobalRef.quick_slot_manager.popup()
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					#radial_menu.grab_focus()
		
		
		if Input.is_action_just_pressed("toggle_locale"):
			var loc = TranslationServer.get_locale()
			match loc:
				"ko":
					TranslationServer.set_locale("en")
				"en":
					TranslationServer.set_locale("ko")

func player_active():
	active = true
	$cam/Camera.make_current()
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

