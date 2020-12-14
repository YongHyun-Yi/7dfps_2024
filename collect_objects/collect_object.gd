extends Interactable


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	action = actions.hand
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func interact():
	if active:
		print("수집했어용")
		GlobalPlayerState.collect_object_current += 1
		call("set_collision_layer_bit" , 1, false)
		
		var a = load("res://dissolve_shader_mat.tres")
		a.set_shader_param("ScalarUniform", 0.5)
		a.set_shader_param("TextureUniform", $mesh.mesh.surface_get_material(0).albedo_texture)
		$mesh.material_override = a
		$Tween.interpolate_property(a, "shader_param/ScalarUniform", -1.0, 1.0, 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		

func tween_all_completed():
	queue_free()
	pass # Replace with function body.
