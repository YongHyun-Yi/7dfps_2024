extends Interactable


export var turn_on = false
export var usable = true

signal turn_on
signal turn_off

onready var sfx = get_node("../sfx")
onready var night_light = get_node("../night_light")

# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(0.1, false), "timeout")
	
	emit_signal("turn_on")
	night_light.hide()
	
	if !turn_on:
		emit_signal("turn_off")
		night_light.show()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func interact():
	if usable:
		if turn_on:
			emit_signal("turn_off")
		else:
			emit_signal("turn_on")
		turn_on = !turn_on
		night_light.visible = !turn_on
		sfx.play()
	pass
