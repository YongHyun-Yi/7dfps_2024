extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func pack_save(slot, node):
	var save_property = File.new()
	save_property.open("res://save_property_" + str(slot) +".save", File.WRITE)
	"""
	for i in node.get_children():
		save_property.store_line(to_json(i.get_property_list()))
	"""
	var global_transforms = []
	for i in node.get_children():
		global_transforms.append([i.rotation_degrees.x, i.rotation_degrees.y, i.rotation_degrees.z])
		#global_transforms.append(i.global_transform)
		#print(i.name + "'s global trnasform is : " + str(i.global_transform))
		#global_transforms.append([i.translation, i.rotation_degrees])
	save_property.store_line(to_json(global_transforms))
	
	var save_scene = PackedScene.new()
	if save_scene.pack(node) == OK:
		ResourceSaver.save("res://save_scene_" + str(slot) +".tscn", save_scene)
		print("save complete")

func pack_load(slot, root):
	var load_scene = load("res://save_scene_" + str(slot) +".tscn").instance()
	root.add_child(load_scene)
	
	var load_property = File.new()
	load_property.open("res://save_property_" + str(slot) +".save", File.READ)
	"""
	var node_property = parse_json(load_property.get_line())
	
	for i in load_scene.get_children():
		for dics in node_property:
			i.set(dics["name"], dics["usage"])
	"""
	var node_property = parse_json(load_property.get_line())
	for i in load_scene.get_children():
		var transform = node_property[i.get_index()]
		print(transform)
		
		print(i.name + "'s degrees is : " + str(i.rotation_degrees))
		i.rotation_degrees = Vector3(float(transform[0]), float(transform[1]), float(transform[2]))
		print(i.name + "'s degrees is : " + str(i.rotation_degrees))
		
		#i.global_transform.basis = Basis(Vector3(float(transform[0]), float(transform[1]), float(transform[2])), Vector3(float(transform[3]), float(transform[4]), float(transform[5])), Vector3(float(transform[6]), float(transform[7]), float(transform[8])))
		
		#i.translation.x = float(transform[0])
		#i.translation.y = float(transform[1])
		#i.translation.z = float(transform[2])
		
		#i.rotation_degrees.x = float(transform[3])
		#i.rotation_degrees.y = float(transform[4])
		#i.rotation_degrees.z = float(transform[5])
		
		#i.scale.x = float(transform[6])
		#i.scale.y = float(transform[7])
		#i.scale.z = float(transform[8])
		
		#i.global_transform.origin = Vector3(float(transform[9]), float(transform[10]), float(transform[11]))
		#i.global_transform.origin.x = float(transform[9])
		#i.global_transform.origin.y = float(transform[10])
		#i.global_transform.origin.z = float(transform[11])
		
	#while load_property.get_position() < load_property.get_len():
	#	print(str(load_property.get_position()))
	#	var node_property = parse_json(load_property.get_line())
	#	for dics in node_property:
	#		print(load_property.get_position())
	#		print(load_scene.get_child(0).name)
	#		load_scene.get_child(0)._set(dics["name"], dics["usage"])
	
	load_property.close()
	print("load complete")
