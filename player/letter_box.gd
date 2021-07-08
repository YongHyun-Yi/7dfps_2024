extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func box_show():
	tween.interpolate_property(self, "modulate:a", 0, 1, .5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func box_hide():
	tween.interpolate_property(self, "modulate:a", 1, 0, .5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
