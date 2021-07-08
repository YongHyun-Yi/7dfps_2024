extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalRef.player != null:
		look_at(GlobalRef.player.get_node("cam").global_transform.origin, Vector3.UP)
		var dis = global_transform.origin.distance_to(GlobalRef.player.get_node("cam").global_transform.origin)
		dis = clamp(dis, 1.2, 4.0)
		scale = range_lerp(dis, 1.2, 4.0, 1.0, 1.5) * Vector3(1, 1, 1)
