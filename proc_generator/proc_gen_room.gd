tool
extends MeshInstance
class_name proc_gen_room

enum tags {Room, Corridor, Junction}
export (tags) var tag = tags.Room

var exits = []
var object_pos = []

var collision = false

signal match_finish


# Called when the node enters the scene tree for the first time.
func _ready():
	PhysicsServer.set_active(true)
	#print(exits)
	#rotation_degrees.y = 0
	#get_parent().connect("create_room", self, "create_room")
	
	#randomize()
	#for i in $exit_poss.get_children():
	#	exits.append(i)
	#for i in $exit_poss.get_children():
	#	print(str(rad2deg(i.global_transform.basis.get_euler().y)))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func connect_room(old_exit, new_exit):
	
	var old_exit_angle = rad2deg(old_exit.global_transform.basis.get_euler().y)
	var new_exit_angle = rad2deg(new_exit.global_transform.basis.get_euler().y)
	var result_angle = wrapf((rotation_degrees.y + (old_exit_angle - new_exit_angle) - 180), 0.0, 360.0)
	
	rotation_degrees.y = result_angle
	
	global_transform.origin = global_transform.origin + (old_exit.global_transform.origin - new_exit.global_transform.origin)
	#owner = get_parent()


func _on_Area_area_entered(area):
	collision = true
	print("collision")
	pass # Replace with function body.


func _on_Area_area_exited(area):
	if $Area.get_overlapping_areas().size() > 0:
		collision = true
	else:
		collision = false
	pass # Replace with function body.
