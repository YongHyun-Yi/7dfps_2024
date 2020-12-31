extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func visibility_changed():
	display_reset()
	pass # Replace with function body.

func display_reset():
	$state_hp/Label.text = "hp : %d" % GlobalPlayerState.hp
	$object/capture_object_current.text = "collect object : %d / %d" % [GlobalPlayerState.collect_object_current, GlobalPlayerState.collect_object_max]
	$object/collect_object_current.text = "capture object : %d / %d" % [GlobalPlayerState.capture_object_current, GlobalPlayerState.capture_object_max]
	pass
