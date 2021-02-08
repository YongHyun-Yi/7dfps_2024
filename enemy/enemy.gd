extends KinematicBody

enum states {idle, suspect, chase}
var current_state = states.idle

var target : Object = null

var in_chase_area = false
var chase_target : Object
var last_sight_pos = Vector3()

var in_sight_area = false
var in_sight_target : Object

var dir
var dis

var chase_path : PoolVector3Array
var chase_path_index = 0

var waypoint : Vector3
var waypoint_path : PoolVector3Array
var waypoint_path_index = 0

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
	$Label.text = "current state is : " + str(current_state) + "\nleft chase time is : " + str($chase_limit_timer.time_left) + "\ntarget is : " + str(target) + "\ndirection is : " + str(dir)
	
	var nav = get_parent().nav
	
	match current_state:
		states.idle:
	
			if target == null:
				if in_sight_object_raycast_check():
					current_state = states.chase
					nav_path_update()
					if patrol_path.size() > 0: # 패트롤 경로가 존재할경우 스위칭
						patrol_interrupted = true
					$head/Sprite3D.modulate = Color("ff0000")
					$bgm.stop()
					$bgm.stream = load("res://sfx/bgm1.wav")
					$bgm.play()
					return
			
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
					dis = (patrol_restore_path[patrol_restore_path_index].distance_to(global_transform.origin))
					dis = (patrol_restore_path[patrol_restore_path_index] - global_transform.origin).normalized()
					
					if dis < 1:
						patrol_restore_path_index += 1
					else:
						velocity = dir * speed
				
			else: # 방해받지 않은경우, 평소대로 진행한다
				if patrol_path.size() > 0: # 패트롤 경로가 존재할경우 진행
					if patrol_path_index >= patrol_path.size():
						patrol_path_index = 0
						
					dis = (patrol_path[patrol_path_index].distance_to(global_transform.origin))
					dir = (patrol_path[patrol_path_index] - global_transform.origin).normalized()
					
					if dis < 1:
						patrol_path_index += 1
					else:
						velocity = dir * speed
			
			pass
		
		states.suspect:
			
			if in_sight_object_raycast_check():
				current_state = states.chase
				$chase_limit_timer.stop()
				$head/Sprite3D.modulate = Color("ff0000")
				$bgm.stop()
				$bgm.stream = load("res://sfx/bgm1.wav")
				$bgm.play()
				return
					
			if waypoint != Vector3(): # 소리를 들었을경우, idle에서 넘어온거면 waypoint가 있지만 chase에서 넘어온것이면 한번 초기화를 하기떄문에 체크해줘야함
				if waypoint_path.empty():
					waypoint_path_setting(waypoint)
			
				if waypoint_path_index < waypoint_path.size():
					
					dis = (waypoint_path[waypoint_path_index].distance_to(global_transform.origin))
					dir = (waypoint_path[waypoint_path_index] - global_transform.origin).normalized()
					
					if dis < 1:
						waypoint_path_index += 1
					else:
						velocity = dir * speed
				
				else: # waypoint path를 끝마쳤을경우, 청각적 인지 목표위치까지 왔는데도 target을 발견하지 못했을 확률이 높음, 이 시점에서부터 타이머를 시작, target을 발견하거나 새 청각적 인지 목표가 나타나면 타이머를 중지
					waypoint = Vector3()
					waypoint_path.resize(0)
					waypoint_path_index = 0
					velocity = Vector3.ZERO
					$chase_limit_timer.start()
				pass
		
		states.chase:
			
			#dir = (chase_target.global_transform.origin - global_transform.origin).normalized()
			#dis = chase_target.global_transform.origin.distance_to(global_transform.origin)
			in_sight_object_raycast_check()
			#nav_path_update()
			if waypoint_path.empty():
				waypoint_path_setting(waypoint)
			
			if waypoint_path_index < waypoint_path.size():
				
				dis = (waypoint_path[waypoint_path_index].distance_to(global_transform.origin))
				dir = (waypoint_path[waypoint_path_index] - global_transform.origin).normalized()
				
				if dis < 1:
					waypoint_path_index += 1
				else:
					velocity = dir * speed
			
			else: # waypoint path를 끝마쳤을경우, target이 있으면 .25초마다 갱신됨으로 이 부분은 target을 놓친상태인 경우일 확률이 높다, 터널링으로 보이는 현상? path가 업데이트되어도 이전 paht를 그대로 따라감
				current_state = states.suspect
				target = null
				waypoint = Vector3()
				waypoint_path.resize(0)
				waypoint_path_index = 0
				velocity = Vector3.ZERO
				$head/Sprite3D.modulate = Color("ffef00")
				$chase_limit_timer.start()
				$bgm.stop()
				$bgm.stream = load("res://sfx/mbient_danger.wav")
				$bgm.play()
			
			pass
	
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y = -gravity
	
	if target:
		var a = (target.global_transform.origin - global_transform.origin).normalized()
		a = Vector2(a.z, a.x)
		a = rad2deg(a.angle())
		$head.rotation_degrees.y = lerp($head.rotation_degrees.y, a, .1)
	elif waypoint != Vector3():
		var a = (waypoint - global_transform.origin).normalized()
		a = Vector2(a.z, a.x)
		a = rad2deg(a.angle())
		$head.rotation_degrees.y = lerp($head.rotation_degrees.y, a, .1)
	else:
		var a = dir
		a = Vector2(a.z, a.x)
		a = rad2deg(a.angle())
		$head.rotation_degrees.y = lerp($head.rotation_degrees.y, a, .1)
	
	move_and_slide(velocity, Vector3.UP)
	
	
	var line3d = $line3d
	var point_set
	
	line3d.global_transform.origin = Vector3.ZERO
	line3d.clear()
	line3d.begin(1, null) #1 = is an enum for draw line, null is for text
	
	if current_state == states.idle:
		if patrol_interrupted:
			point_set = patrol_restore_path
		else:
			point_set = patrol_path
		line3d.set_color(Color("00ff16"))
	else:
		point_set = waypoint_path
		line3d.set_color(Color("ff0000"))
	
	for i in range(point_set.size()):
		if i + 1 < point_set.size():
			var A = point_set[i]
			var B = point_set[i + 1]
			line3d.add_vertex(A)
			line3d.add_vertex(B)
	line3d.end()
	
	pass

func nav_path_update():
	
	match current_state:
		
		states.idle:
			pass
		
		states.suspect:
			
			pass
		
		states.chase:
			#chase_path_setting(chase_target.global_transform.origin)
			if target: # 퍼포먼스를 위해서 여기서 .25초마다 갱신, 타겟이 없으면 갱신을 멈춘다 즉 마지막으로 목격한 위치까지만
				waypoint = target.global_transform.origin
				waypoint_path_setting(waypoint)


func waypoint_path_setting(target_pos):
	var nav = get_parent().nav
	
	waypoint_path = nav.get_simple_path(global_transform.origin, target_pos, true)
	waypoint_path_index = 0

func _on_sight_area_body_entered(body):
	print("something detected!")
	if in_sight_target == null:
		in_sight_target = body
	
	in_sight_area = true
	
	pass # Replace with function body.

func _on_sight_area_body_exited(body):
	print("something lost....")
	if in_sight_target != null:
		in_sight_target = null
	
	in_sight_area = false
	
	if current_state == states.chase:
		if body == target:
			target = null
	pass # Replace with function body.

func in_sight_object_raycast_check():
	
	var sight_area = $head/sight_area
	var check_wall = $check_wall
	
	if sight_area.get_overlapping_bodies().size() > 0:
		for i in sight_area.get_overlapping_bodies():
			dir = (i.global_transform.origin - global_transform.origin).normalized()
			dis = i.global_transform.origin.distance_to(global_transform.origin)
			check_wall.cast_to = dir * dis
			check_wall.force_raycast_update()
			
			
			if check_wall.is_colliding():
				if target:
					target = null
			else:
				target = i
				return true
	else:
		if check_wall.cast_to != Vector3.ZERO:
			check_wall.cast_to = Vector3.ZERO
	return false


func _on_auditory_area_area_entered(area):
	print("sound area enterd")
	match current_state:
		states.idle:
			waypoint = area.global_transform.origin
			waypoint_path_setting(waypoint)
			current_state = states.suspect
			$head/Sprite3D.modulate = Color("ffef00")
			$bgm.stop()
			$bgm.stream = load("res://sfx/mbient_danger.wav")
			$bgm.play()
		
		states.suspect:
			waypoint = area.global_transform.origin
			waypoint_path_setting(waypoint)
			if !$chase_limit_timer.is_stopped():
				$chase_limit_timer.stop()
		
		states.chase:
			if !target:
				waypoint = area.global_transform.origin
				waypoint_path_setting(waypoint)
	
	area.queue_free()
	pass # Replace with function body.


func chase_limit_timer_timeout():
	current_state = states.idle
	chase_target = null
	chase_path.resize(0)
	chase_path_index = 0
	$head/Sprite3D.modulate = Color("ffffff")
	$bgm.stop()
	$bgm.stream = load("res://sfx/271945__rodincoil__stingers-001.wav")
	$bgm.play()
	print("reset")
	pass # Replace with function body.
