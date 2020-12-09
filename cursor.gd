extends TextureRect

enum actions {hand, talk, pick_up, see, lock}

var normal = preload("res://sprite/crose_hair.png")
var icon0 = preload("res://sprite/action_icon1.png")
var icon1 = preload("res://sprite/action_icon2.png")
var icon2 = preload("res://sprite/action_icon3.png")
var icon3 = preload("res://sprite/action_icon4.png")
var icon4 = preload("res://sprite/action_icon5.png")
var icon5 = preload("res://sprite/action_icon6.png")
var icon6 = preload("res://sprite/action_icon7.png")

var icons = [icon0, icon1, icon2, icon3, icon4, icon5, icon6]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_icon(index, active):
	texture = icons[index]
	
	if active:
		self_modulate = Color(1, 1, 1, 1)
	else:
		self_modulate = Color(1, 1, 1, 0.64)

func cursor_reset():
	texture = normal
	self_modulate = Color(1, 1, 1, 0.64)
