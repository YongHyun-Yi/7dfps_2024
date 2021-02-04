extends KinematicBody

enum states {idle, suspect, chase}
var current_state = states.idle

var target : Object = null

var in_chase_area = false
var chase_target : Object

var in_detect_area = false
var detect_target : Object

var dir
var dis

var chase_path : PoolVector3Array
var chase_path_index = 0

var patrol_path = []
var patrol_path_index = 0

var gravity = 5
export var speed = 3.0
var velocity = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	$Label.text = "current state is : " + str(current_state) + "\nleft chase time is : " + str($chase_limit_timer.time_left)
	var nav = get_parent().nav
	
	match current_state:
		states.idle:
			
			if in_detect_area:
				
				dir = (detect_target.global_transform.origin - global_transform.origin).normalized()
				dis = detect_target.global_transform.origin.distance_to(global_transform.origin)
				
				if $check_wall.cast_to == Vector3.ZERO:
					$check_wall.cast_to = dir * dis
				
				else:
					$check_wall.cast_to = dir * dis
					
					if !$check_wall.is_colliding():
						current_state = states.chase
						chase_target = detect_target
				
			else:
				if $check_wall.cast_to != Vector3.ZERO:
					$check_wall.cast_to = Vector3.ZERO
			
			pass
		
		states.suspect:
			pass
		
		states.chase:
			
			#dir = (chase_target.global_transform.origin - global_transform.origin).normalized()
			#dis = chase_target.global_transform.origin.distance_to(global_transform.origin)
			
			if chase_path.empty():
				chase_path_setting(chase_target.global_transform.origin)
			
			if chase_path_index < chase_path.size():
				
				dir = (chase_path[chase_path_index] - global_transform.origin)
				
				if dir.length() < 1:
					chase_path_index += 1
				else:
					velocity = dir.normalized() * speed
			
			pass
	
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y = -gravity
		
	move_and_slide(velocity, Vector3.UP)
	
	pass


func nav_path_update():
	
	match current_state:
		
		states.idle:
			velocity = Vector3.ZERO
		
		states.suspect:
			pass
		
		states.chase:
			chase_path_setting(chase_target.global_transform.origin)


func chase_path_setting(target_pos):
	
	var nav = get_parent().nav
	
	chase_path = nav.get_simple_path(global_transform.origin, target_pos, true)
	chase_path_index = 0


func _on_detect_body_entered(body):
	print("something detected!")
	if detect_target == null:
		detect_target = body
	
	in_detect_area = true
	
	pass # Replace with function body.

func _on_detect_body_exited(body):
	if detect_target != null:
		detect_target = null
	
	in_detect_area = false
	pass # Replace with function body.

func _on_chase_area_body_entered(body):
	#if !$chase_limit_timer.is_stopped():
	if current_state == states.chase:
		$chase_limit_timer.stop()
		print("chase limit is canceled")
		
		in_chase_area = true
	pass # Replace with function body.


func _on_chase_area_body_exited(body):
	if current_state == states.chase:
		$chase_limit_timer.start()
		print("chase limit is start")
		
		in_chase_area = false
	pass # Replace with function body.


func chase_limit_timer_timeout():
	current_state = states.idle
	chase_target = null
	chase_path.resize(0)
	chase_path_index = 0
	print("reset")
	pass # Replace with function body.
