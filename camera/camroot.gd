extends Spatial

export var mouse_sensitivity = 0.1

export var capture_mode = false
export var zoom_min = 30
export var zoom_max = 70
export var zoom_current = 70
export var zoom_factor = 3.0

func _ready():
	$capture_cam/Viewport.world = get_viewport().world
	pass

func _process(delta):
	$capture_cam/Viewport/Camera.global_transform = $Camera.global_transform
	pass

func _input(event):
	
	if event is InputEventMouseMotion:
		GlobalRef.player.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		rotation.x = clamp(rotation.x, deg2rad(-89), deg2rad(90))
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			
			if capture_mode:
				
				if Input.is_action_pressed("zoom_in") and zoom_current > zoom_min:
						zoom_current = clamp(zoom_current - zoom_factor, zoom_min, zoom_max)
						$Camera.fov = zoom_current
						$sound_animation.play("wind")
				elif Input.is_action_pressed("zoom_out") and zoom_current < zoom_max:
					zoom_current = clamp(zoom_current + zoom_factor, zoom_min, zoom_max)
					$Camera.fov = zoom_current
					$sound_animation.play("wind")
				
				if Input.is_action_just_pressed("left_click"):
					var pic = $capture_cam/Viewport.get_viewport().get_texture().get_data()
					pic.flip_y()
					pic.shrink_x2()
					pic.shrink_x2()
					var tex = ImageTexture.new()
					tex.create_from_image(pic)
					GlobalRef.hud.get_node("last_picture").texture = tex
					$sound_animation.play("sutter")
					print("사진 찍었어용")
			
			if Input.is_action_just_pressed("right_click"):
				capture_mode_toggle()
	
	if event is InputEventKey:
		if event.is_pressed():
			
			if Input.is_action_just_pressed("interact"):
				$capture_cam.visible = !$capture_cam.visible


func capture_mode_toggle():
	capture_mode = !capture_mode
	
	if capture_mode:
		GlobalRef.hud.get_node("viewfinder").show()
		GlobalRef.hud.get_node("last_picture").show()
		GlobalRef.hud.get_node("cursor").hide()
		GlobalRef.hud.get_node("item_slot").hide()
		$Camera.fov = zoom_current
		#print("사진촬영")
	else:
		GlobalRef.hud.get_node("viewfinder").hide()
		GlobalRef.hud.get_node("last_picture").hide()
		GlobalRef.hud.get_node("cursor").show()
		GlobalRef.hud.get_node("item_slot").show()
		$Camera.fov = zoom_max
		#print("일반화면")
