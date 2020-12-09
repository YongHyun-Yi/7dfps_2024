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

var movement_speed = 0
export var walk_speed = 1.0
export var run_speed = 2.8

export var jump = 6.5

export var run_mode = false
export var ladder_on = false

export var active = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GlobalRef.player = self

func _physics_process(delta):
	
	direction = Vector3()
	
	if is_on_floor():
		gravity_vector = -get_floor_normal() * floor_gravity
	else:
		gravity_vector += Vector3.DOWN * air_gravity * delta
		gravity_vector.y = clamp(gravity_vector.y, -7.0, 0.0)
	
	if Input.is_action_pressed("move_foward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
	
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	if Input.is_action_pressed("move_foward") or Input.is_action_pressed("move_backward") or Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
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
	
	direction = direction.normalized()
	direction = direction * movement_speed
	direction.x += gravity_vector.x
	direction.z += gravity_vector.z
	direction.y = gravity_vector.y
	
	move_and_slide(direction, Vector3.UP)
	#$camroot.GlobalRef.hud.get_node("velocity").text = str(movement_speed)
	#move_and_slide_with_snap(direction, get_floor_velocity(), Vector3.UP)
	
	pass

func ladder_entered(body):
	
	pass


func ladder_exited(body):
	
	pass
