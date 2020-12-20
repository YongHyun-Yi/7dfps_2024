extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/VSlider.max_value = $Panel/Control/VBoxContainer.rect_size.y - $Panel/Control.rect_size.y
	$Panel/VSlider.value = $Panel/VSlider.max_value + $Panel/VSlider.step
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func close_button_up():
	get_parent().current_tab = 0
	pass # Replace with function body.


func VSlider_value_changed(value):
	$Panel/Control/VBoxContainer.rect_position.y = -($Panel/VSlider.max_value - value)
	pass # Replace with function body.
