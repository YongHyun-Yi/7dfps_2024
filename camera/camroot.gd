extends Spatial

export var mouse_sensitivity = 0.1

export var capture_mode = false
export var zoom_min = 30
export var zoom_max = 70
export var zoom_current = 70
export var zoom_factor = 3.0
export var near_focus_factor = 0.15
export var far_focus_factor = 0.3

export (NodePath) var last_picture
export (NodePath) var capture_cam_viewport
export (NodePath) var capture_cam_camera
export (NodePath) var date_stamp_viewport

signal capture_cam_active

func _ready():
	
	last_picture = get_node(last_picture)
	capture_cam_viewport = get_node(capture_cam_viewport)
	capture_cam_camera = get_node(capture_cam_camera)
	date_stamp_viewport = get_node(date_stamp_viewport)
	
	GlobalRef.cam_root = self
	GlobalRef.player_camera = $Camera
	GlobalRef.capture_camera = $capture_cam/Viewport/capture_cam_camera
	
	capture_cam_viewport.world = get_viewport().world
	capture_cam_camera.current = $capture_cam.visible
	pass

func _process(delta):
	capture_cam_camera.global_transform = $Camera.global_transform
	
	if capture_mode:
		var date = OS.get_datetime()
		
		var images = capture_cam_viewport.get_node("../images")
		var date_times = images.get_node("date_times")
		
		var date_hour
		if date["hour"] > 12:
			date_hour = "PM " + str(date["hour"] - 12)
		else:
			date_hour = "AM " + str(date["hour"])
		
		var date_minute = str(date["minute"])
		if date["minute"] < 10:
			date_minute = date_minute.insert(0, "0")
		
		var date_month
		match date["month"]:
			1:
				date_month = "JAN"
			2:
				date_month = "FEB"
			3:
				date_month = "MAR"
			4:
				date_month = "APR"
			5:
				date_month = "MAY"
			6:
				date_month = "JUN"
			7:
				date_month = "JUL"
			8:
				date_month = "AUG"
			9:
				date_month = "SEP"
			10:
				date_month = "OCT"
			11:
				date_month = "NOV"
			12:
				date_month = "DEC"
		
		var date_day = str(date["day"])
		if date["day"] < 10:
			date_day = date_day.insert(0, "0")
		
		var date_year = str(date["year"] - 30)
		
		date_times.text = date_hour + ":" + date_minute + "\n" + date_month + ". " + date_day + " " + date_year
	
	pass

func _unhandled_input(event):
	
	if event is InputEventMouseMotion:
		GlobalRef.player.rotate_y(deg2rad(-event.relative.x * GlobalOption.mouse_sensitivity))
		rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		rotation.x = clamp(rotation.x, deg2rad(-89), deg2rad(90))
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			
			if capture_mode:
				
				if Input.is_action_pressed("zoom_in") and zoom_current > zoom_min:
					zoom_current = clamp(zoom_current - zoom_factor, zoom_min, zoom_max)
					capture_cam_camera.fov = zoom_current
					capture_cam_camera.environment.dof_blur_far_distance += far_focus_factor
					capture_cam_camera.environment.dof_blur_near_distance += near_focus_factor
					$sound_animation.play("wind")
					
				elif Input.is_action_pressed("zoom_out") and zoom_current < zoom_max:
					zoom_current = clamp(zoom_current + zoom_factor, zoom_min, zoom_max)
					capture_cam_camera.fov = zoom_current
					capture_cam_camera.environment.dof_blur_far_distance -= far_focus_factor
					capture_cam_camera.environment.dof_blur_near_distance -= near_focus_factor
					$sound_animation.play("wind")
				
				if Input.is_action_just_pressed("left_click"):
					var pic1 = capture_cam_viewport.get_texture().get_data()
					pic1.flip_y()
					pic1.convert(Image.FORMAT_RGBA8)
					
					var pic2 = date_stamp_viewport.get_texture().get_data()
					pic2.flip_y()
					pic2.convert(Image.FORMAT_RGBA8)
					
					pic1.blend_rect(pic2, pic1.get_used_rect(), Vector2.ZERO)
					pic1.save_png("user://screen_shot.png")
					
					pic1.resize(last_picture.rect_min_size.x, last_picture.rect_min_size.y, 2)
					#pic.shrink_x2()
					#pic.shrink_x2()
					var tex = ImageTexture.new()
					tex.create_from_image(pic1)
					last_picture.texture = tex
					$sound_animation.play("sutter")
					emit_signal("capture_cam_active")
					print("사진 찍었어용")
				
			else:
				if Input.is_action_just_pressed("left_click"):
					if $Camera.current:
						get_parent().switch_cam.make_current()
					else:
						$Camera.make_current()
			
			if Input.is_action_just_pressed("right_click"):
				capture_mode_toggle()
			
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_accept"):
			$Camera_back.make_current()
		elif Input.is_action_just_released("ui_accept"):
			$Camera.make_current()


func capture_mode_toggle():
	capture_mode = !capture_mode
	
	if capture_mode:
		"""
		GlobalRef.hud.get_node("viewfinder").show()
		GlobalRef.hud.get_node("last_picture").show()
		GlobalRef.hud.get_node("cursor").hide()
		GlobalRef.hud.get_node("item_slot").hide()
		$Camera.fov = zoom_current
		"""
		print("사진촬영")
		get_parent().run_mode = false
		
		var date = OS.get_date()
		var date_year = str(date["year"] - 30).substr(2,3)
		
		var date_month = str(date["month"])
		if date["month"] < 10:
			date_month = date_month.insert(0, "0")
		
		var date_day = str(date["day"])
		if date["day"] < 10:
			date_day = date_day.insert(0, "0")
		
		var date_text = date_year + " " + date_month + " " + date_day
		date_stamp_viewport.get_node("Control/Label").text = date_text
		#date_stamp_viewport.get_node("Control/Label2").text = date_text
		
	else:
		"""
		GlobalRef.hud.get_node("viewfinder").hide()
		GlobalRef.hud.get_node("last_picture").hide()
		GlobalRef.hud.get_node("cursor").show()
		GlobalRef.hud.get_node("item_slot").show()
		$Camera.fov = zoom_max
		"""
		print("일반화면")
	
	$capture_cam.visible = capture_mode
	capture_cam_camera.current = $capture_cam.visible

func capture_mode_close():
	if capture_mode:
		capture_mode_toggle()
