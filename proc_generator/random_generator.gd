tool
extends Spatial

var collect_object = load("res://collect_objects/bujeok1.tscn")
var capture_object = load("res://capture_objects/capture_object.tscn")
"""
var start_point = load("res://proc_generator/start_point.tscn")

var room1 = load("res://proc_generator/room1.tscn")
var room2 = load("res://proc_generator/room2.tscn")
var corridor1 = load("res://proc_generator/corridor1.tscn")
var corridor2 = load("res://proc_generator/corridor2.tscn")
var junction1 = load("res://proc_generator/junction1.tscn")
"""
var block_wall = load("res://proc_generator/block_wall.tscn")

export (PackedScene) var start_room
export (Array, PackedScene) var rooms = [] #setget rooms_parts_update
export (Array, PackedScene) var corridors = [] #setget corridors_parts_update
export (Array, PackedScene) var junctions = [] #setget junctions_parts_update
"""
var room_scenes = [room1, room2]
var corridor_scenes = [corridor1, corridor2]
var junction_scenes = [junction1]
"""
#var parts = []#[room_scenes, corridor_scenes, junction_scenes]
var parts = []#[room_scenes, corridor_scenes, junction_scenes]

var collect_object_positions = []
var capture_object_positions = []
var object_positions = []

export var literation = 5
export var collision_loop_max = 3
export var map_creation = false setget map_creation
export var map_reduction = false setget map_reduction

signal part_generate_finish
signal object_generate_finish
#var a
# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalRef.world_generator = self
	#create_rooms(5)
	
	#yield(self, "part_generate_finish")
	
	#while $rooms.get_child_count() < 20:
	#	for i in $rooms.get_children():
	#		i.queue_free()
	#	create_rooms(5)
	#	yield(self, "part_generate_finish")
	
	#create_objects()
	#$screen_block.queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("call_ingame_menu1"):
	#	SaveLoadSystem.pack_save(0, $rooms)
	
	#if Input.is_action_just_pressed("call_ingame_menu2"):
	#	SaveLoadSystem.pack_load(0, self)
	
	#if Input.is_action_just_pressed("call_ingame_menu3"):
	#	$rooms.queue_free()
	
	#if Input.is_action_just_pressed("ui_up"):
	#	$Camera.make_current()
	#	GlobalRef.player.player_deactive()
	#if Input.is_action_just_pressed("ui_down"):
	#	GlobalRef.player_camera.make_current()
	#	GlobalRef.player.player_active()
	
	pass


#func rooms_parts_update(value):
#	parts[0] = value


#func corridors_parts_update(value):
#	parts[1] = value


#func junctions_parts_update(value):
#	parts[2] = value


func map_creation(value):
	if $rooms.get_child_count() == 0:
		create_rooms(literation)
	#map_creation = false


func map_reduction(value):
	if $rooms.get_child_count() > 0:
		delete_rooms()
	#map_reduction = false


func create_rooms(time):
	#print("start")
	
	parts = [rooms, corridors, junctions]
	
	randomize()
	
	var starting_module = start_room.instance()#room1.instance()#start_point.instance()
	$rooms.add_child(starting_module)
	starting_module.global_transform.origin = Vector3.ZERO
	starting_module.set_owner(get_tree().edited_scene_root)
	#print("start")
	#print("exits : " + str(starting_module.exits))
	
	#yield(starting_module, "ready")
	print(parts)
	
	var pending_exits = starting_module.exits
	#print("pending exits : " + str(pending_exits))
	
	
	while time > 0:
		var new_exits = []
		
		for pending_exit in pending_exits:
			
			var tag = pending_exit.connectable_tag[randi() % pending_exit.connectable_tag.size()]
			var selected_module = parts[tag]
			selected_module = selected_module[randi() % selected_module.size()]
			var new_module = selected_module.instance()
			$rooms.add_child(new_module)
			new_module.set_owner(get_tree().edited_scene_root)
			#print(new_module.name)
			
			var exit_to_match = new_module.exits[randi() % new_module.exits.size()]
			new_module.connect_room(pending_exit, exit_to_match)
			
			yield(get_tree().create_timer(0.02), "timeout")
			
			var collision = new_module.collision#new_module.get_node("Area").get_overlapping_areas().size()
			#print(collision)
			
			if collision:
				print("collision occursed")
				print("loop start")
				var t = 0
				
				while collision and t < collision_loop_max:
					
					new_module.queue_free()
					
					selected_module = parts[tag]
					selected_module = selected_module[randi() % selected_module.size()]
					new_module = selected_module.instance()
					$rooms.add_child(new_module)
					new_module.set_owner(get_tree().edited_scene_root)
					print("2")
					
					exit_to_match = new_module.exits[randi() % new_module.exits.size()]
					new_module.connect_room(pending_exit, exit_to_match)
					
					yield(get_tree().create_timer(0.02), "timeout")
					
					collision = new_module.collision
					#print(collision)
					
					t += 1
				
				if collision:
					new_module.queue_free()
			
			yield(get_tree().create_timer(0.01), "timeout")
			
			if new_module:
				for new_exit in new_module.exits:
					if new_exit != exit_to_match:
						new_exits.append(new_exit)
		
		pending_exits = new_exits
		time -= 1
		#print("one time")
		
		pass
	#for i in $rooms.get_children():
	#	i.owner = $rooms
		
	block_wall_create(pending_exits)
	
	print("part finish")
	#emit_signal("part_generate_finish")
	#print($rooms.get_child_count())
	pass

func block_wall_create(pending_exits):
	
	for i in pending_exits:
		var wall = block_wall.instance()
		$rooms.add_child(wall)
		wall.connect_room(i, wall.get_node("proc_gen_exit"))
		wall.set_owner(get_tree().edited_scene_root)
		pass
	
	pass

func create_objects():
	for i in $rooms.get_children():
		if i.object_pos.size() > 0:
			for l in i.object_pos:
				object_positions.append(l)
	
	object_positions.shuffle()
	
	for i in range(3):
		var pos = object_positions.pop_front()
		var col_obj = collect_object.instance()
		col_obj.global_transform = pos.global_transform
		$rooms.add_child(col_obj)
		col_obj.set_owner(get_tree().edited_scene_root)
	
	for i in range(3):
		var pos = object_positions.pop_front()
		var cap_obj = capture_object.instance()
		cap_obj.global_transform = pos.global_transform
		$rooms.add_child(cap_obj)
		cap_obj.set_owner(get_tree().edited_scene_root)
	
	#emit_signal("object_generate_finish")
	#$screen_block.queue_free()
	#print("object finish")

func delete_rooms():
	for i in $rooms.get_children():
		i.queue_free()
	pass
