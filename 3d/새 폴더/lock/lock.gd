extends Interactable

var usable = true
signal lock_open

onready var sfx = get_node("../sfx")
onready var tween = get_node("../Tween")

# Called when the node enters the scene tree for the first time.
func _ready():
	var mat = get_node("../큐브043").mesh.surface_get_material(0)
	get_node("../큐브043").mesh.surface_set_material(0, mat.duplicate(false))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func interact():
	#만약 열쇠가 있다면
	if GlobalRef.inventory.current_selected_item == "item_classroom_key":
		GlobalRef.inventory.consume_item(GlobalRef.inventory.current_selected_item)
		GlobalRef.player.player_deactive()
		usable = false
		sfx.play()
		GlobalRef.player.letter_box.box_show()
	pass


func _on_sfx_finished():
	GlobalRef.player.player_active()
	emit_signal("lock_open")
	GlobalRef.player.letter_box.box_hide()
	disappear()
	pass # Replace with function body.


func disappear():
	var mat = get_node("../큐브043").mesh.surface_get_material(0)
	mat.flags_transparent = true
	tween.interpolate_property(mat, "albedo_color:a", 1, 0, .5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
