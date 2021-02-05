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

export (NodePath) var patrol_path_node
var patrol_path = []
var patrol_path_index = 0

var patrol_interrupted = false

var close_point = Vector3()
var close_index = 0
var patrol_restore_path : PoolVector3Array
var patrol_restore_path_index = 0

var gravity = 5
export var speed = 3.0
var velocity = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	if patrol_path_node != "":
		patrol_path_node = get_node(patrol_path_node)
		for i in patrol_path_node.curve.get_point_count(): # baked point는 단순히 point뿐만 아니라 인터벌 만큼 그 사이의 수많은 point들도 저장하기에 그냥 point count기반으로 직접 좌표를 저장함
			patrol_path.append(patrol_path_node.curve.get_point_position(i))
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
				
				if $check_wall_down_side.cast_to == Vector3.ZERO and $check_wall_up_side.cast_to == Vector3.ZERO:
					$check_wall_down_side.cast_to = dir * dis
					$check_wall_up_side.cast_to = dir * dis
				
				else:
					$check_wall_down_side.cast_to = dir * dis
					$check_wall_up_side.cast_to = dir * dis
					
					if !$check_wall_down_side.is_colliding() or !$check_wall_up_side.is_colliding():
						current_state = states.chase
						chase_target = detect_target
						if patrol_path.size() > 0: # 패트롤 경로가 존재할경우 스위칭
							patrol_interrupted = true
						$Sprite3D.modulate = Color("ff0000")
						return
				
			else:
				if $check_wall_down_side.cast_to != Vector3.ZERO and $check_wall_up_side.cast_to != Vector3.ZERO:
					$check_wall_down_side.cast_to = Vector3.ZERO
					$check_wall_up_side.cast_to = Vector3.ZERO
			
			if patrol_interrupted: # 패트롤이 도중에 방해받았을경우
				if close_point == Vector3(): # close point가 없으면 설정한다
					close_point = patrol_path_node.curve.get_closest_point(global_transform.origin) #path.curve 내장함수로 가장 가까운 point를 계산하고 point목록에서 가장 가까운녀석을 찾아서 index값을 대입
					close_index = 0
					var close_dis = 1000.0
					for i in patrol_path_node.curve.get_point_count():
						var a = patrol_path_node.curve.get_point_position(i)
						
						if abs(close_point.distance_to(a)) < close_dis:
							close_dis = close_point.distance_to(a)
							patrol_path_index = i
				
				if patrol_restore_path.empty(): #가장 가까운 패트롤 point까지 nav로 계산한 경로, 없으면 설정한다
					patrol_restore_path = nav.get_simple_path(global_transform.origin, close_point, true)
					patrol_restore_path_index = 0
				
				if patrol_restore_path_index >= patrol_restore_path.size(): #경로를 끝마쳤으면 interrupted 를 false로 하고 평소 패스톨 경로를 따라간다, 다시 시작해야할 가장 가까운 point의 index값은 위에서미리 대입해뒀다
					patrol_restore_path.resize(0)
					patrol_interrupted = false
					close_point = Vector3()
					print("is over")
					
				else: # 가장 가까운 패트롤 point까지 경로를 끝마치지 않은경우, 진행한다
					dir = (patrol_restore_path[patrol_restore_path_index] - global_transform.origin)
					
					if dir.length() < 1:
						patrol_restore_path_index += 1
					else:
						velocity = dir.normalized() * speed
				
			else: # 방해받지 않은경우, 평소대로 진행한다
				if patrol_path.size() > 0: # 패트롤 경로가 존재할경우 진행
					if patrol_path_index >= patrol_path.size():
						patrol_path_index = 0
						
					dir = (patrol_path[patrol_path_index] - global_transform.origin)
					
					if dir.length() < 1:
						patrol_path_index += 1
					else:
						velocity = dir.normalized() * speed
			
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
	$Sprite3D.modulate = Color("ffffff")
	print("reset")
	pass # Replace with function body.
