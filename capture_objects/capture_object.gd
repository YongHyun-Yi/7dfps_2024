extends Spatial

export var in_the_camera = false
export var player_colliding = false
export var captured = false
export var capture_layer = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	#GlobalRef.cam_root.connect("capture_cam_active", self, "capture_check")
	#$MeshInstance.mesh.resource_local_to_scene
	#$MeshInstance.mesh.surface_get_material(0).resource_local_to_scene
	$MeshInstance.mesh.surface_set_material(0, $MeshInstance.mesh.surface_get_material(0).duplicate(true))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if in_the_camera:
		var ray_dis = (Vector3.FORWARD * 2)
		$RayCast.cast_to = ray_dis
		$RayCast.look_at(GlobalRef.player.global_transform.origin, Vector3.UP)
	
		if $RayCast.is_colliding():
			var collider = $RayCast.get_collider()
			
			if collider.name == "player":
				if !player_colliding:
					player_colliding = true
					var mat = $MeshInstance.mesh.surface_get_material(0)
					mat.next_pass.set_albedo(Color.green)
					print("촬영가능")
			
			elif player_colliding:
				player_colliding = false
				var mat = $MeshInstance.mesh.surface_get_material(0)
				mat.next_pass.set_albedo(Color.red)
				print("촬영불가")
		
		else:
			if player_colliding:
				player_colliding = false
				var mat = $MeshInstance.mesh.surface_get_material(0)
				mat.next_pass.set_albedo(Color.red)
				print("촬영불가")
	
	pass


func camera_entered(camera):
	if camera.get_cull_mask_bit(capture_layer) == $MeshInstance.get_layer_mask_bit(capture_layer):
		in_the_camera = true
		print("in")
	pass # Replace with function body.


func camera_exited(camera):
	if camera.get_cull_mask_bit(capture_layer) == $MeshInstance.get_layer_mask_bit(capture_layer):
		in_the_camera = false
		print("out")
	pass # Replace with function body.

func capture_check():
	if in_the_camera and player_colliding:
		if !captured:
			captured = !captured
			GlobalPlayerState.capture_object_current += 1
			var a = load("res://dissolve_shader_mat.tres")
			a.set_shader_param("ScalarUniform", 0.5)
			a.set_shader_param("TextureUniform", $MeshInstance.mesh.surface_get_material(0).albedo_texture)
			$MeshInstance.material_override = a
			$Tween.interpolate_property(a, "shader_param/ScalarUniform", -1.0, 1.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()
			print("캡쳐됬어용")
			#queue_free()


func tween_all_completed():
	queue_free()
	pass # Replace with function body.
