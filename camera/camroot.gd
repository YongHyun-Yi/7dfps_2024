extends Spatial

export var mouse_sensitivity = 0.1

export var capture_mode = false
export var zoom_min = 30
export var zoom_max = 70
export var zoom_current = 70
export var zoom_factor = 3.0
export var near_focus_factor = 0.15
export var far_focus_factor = 0.3

signal capture_cam_active

func _ready():
	
	GlobalRef.cam_root = self
	GlobalRef.player_camera = $Camera
	GlobalRef.capture_camera = $capture_cam/Viewport/capture_cam_camera
	
	$capture_cam/Viewport.world = get_viewport().world
	$capture_cam/Viewport/capture_cam_camera.current = $capture_cam.visible
	pass

func _process(delta):
	$capture_cam/Viewport/capture_cam_camera.global_transform = $Camera.global_transform
	pass

func _unhandled_input(event):
	
	if event is InputEventMouseMotion:
		GlobalRef.player.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		rotation.x = clamp(rotation.x, deg2rad(-89), deg2rad(90))
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			
			if capture_mode:
				
				if Input.is_action_pressed("zoom_in") and zoom_current > zoom_min:
					zoom_current = clamp(zoom_current - zoom_factor, zoom_min, zoom_max)
					$capture_cam/Viewport/capture_cam_camera.fov = zoom_current
					$capture_cam/Viewport/capture_cam_camera.environment.dof_blur_far_distance += far_focus_factor
					$capture_cam/Viewport/capture_cam_camera.environment.dof_blur_near_distance += near_focus_factor
					$sound_animation.play("wind")
					
				elif Input.is_action_pressed("zoom_out") and zoom_current < zoom_max:
					zoom_current = clamp(zoom_current + zoom_factor, zoom_min, zoom_max)
					$capture_cam/Viewport/capture_cam_camera.fov = zoom_current
					$capture_cam/Viewport/capture_cam_camera.environment.dof_blur_far_distance -= far_focus_factor
					$capture_cam/Viewport/capture_cam_camera.environment.dof_blur_near_distance -= near_focus_factor
					$sound_animation.play("wind")
				
				if Input.is_action_just_pressed("left_click"):
					var pic = $capture_cam/Viewport.get_viewport().get_texture().get_data()
					pic.flip_y()
					pic.resize($capture_cam/Control/last_picture.rect_min_size.x, $capture_cam/Control/last_picture.rect_min_size.y, 2)
					#pic.shrink_x2()
					#pic.shrink_x2()
					var tex = ImageTexture.new()
					tex.create_from_image(pic)
					$capture_cam/Control/last_picture.texture = tex
					$sound_animation.play("sutter")
					emit_signal("capture_cam_active")
					print("사진 찍었어용")
			
			if Input.is_action_just_pressed("right_click"):
				capture_mode_toggle()
				


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
	$capture_cam/Viewport/capture_cam_camera.current = $capture_cam.visible

func capture_mode_close():
	if capture_mode:
		capture_mode_toggle()
