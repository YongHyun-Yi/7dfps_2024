extends ProgressBar


onready var init_pos_x = 470


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if init_pos_x:
		rect_position.x = init_pos_x + ((max_value - value) * (rect_size.x / max_value) / 2)
	
	pass
