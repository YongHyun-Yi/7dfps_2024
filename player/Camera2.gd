extends Spatial


export var mouse_sensitivity = 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _unhandled_input(event):
	if GlobalRef.player != null and GlobalRef.player.active:
		if event is InputEventMouseMotion:
			get_parent().rotate_y(deg2rad(-event.relative.x * GlobalOption.mouse_sensitivity))
			rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
			rotation.x = clamp(rotation.x, deg2rad(-89), deg2rad(90))
