extends KinematicBody
class_name player

var direction = Vector3()
var velocity = Vector3.ZERO

var gravity_vector = Vector3()
export var gravity = 5
export var air_gravity = 7.0
export var floor_gravity = 1.0
export var floor_speed = 1.0

#export var mouse_sensitivity = 0.1

var z_input = 0
var x_input = 0

var movement_speed = 0
export var walk_speed = 1.0
export var run_speed = 2.8

export var jump = 6.5

export var run_mode = false
export var ladder_on = false

export var active = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalRef.player = self
	#GlobalRef.world_generator.connect("object_generate_finish", self, "player_active")

func _physics_process(delta):
	
	if active:
	
		direction = Vector3()
		
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
		
		if Input.is_action_pressed("move_foward") || Input.is_action_pressed("move_backward") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
			if is_on_floor():
				if run_mode:
					$foot_sound_animation.play("run")
				else:
					$foot_sound_animation.play("walk")
		
		if Input.is_action_pressed("sprint"):
			run_mode = true
			movement_speed = run_speed
		else:
			run_mode = false
			movement_speed = walk_speed

func player_active():
	active = true
	$camroot/Camera.make_current()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
