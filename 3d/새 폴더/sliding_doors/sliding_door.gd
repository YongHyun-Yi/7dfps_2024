extends Interactable


export var open = false
export var usable = true
export (NodePath) var target

export var locked = false

onready var tween = get_node("../../Tween")
onready var sfx = get_node("../sfx")

export var flip_factor = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node(target)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func interact():
	if locked:
		return
	
	if usable:
		if open:
			tween.interpolate_property(target, "transform:origin:x", 0.80 * flip_factor, 0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN)
			tween.start()
			sfx.play()
		else:
			tween.interpolate_property(target, "transform:origin:x", 0, 0.80 * flip_factor, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN)
			tween.start()
			sfx.play()
		usable = false
		open = !open
	pass

func _on_Tween_tween_all_completed():
	usable = true
	pass # Replace with function body.

func lock_open():
	locked = false
