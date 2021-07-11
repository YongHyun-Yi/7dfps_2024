extends Spatial


export var literation = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("left_click"):
		make_boxs()
	pass

func make_boxs():
	for i in literation:
		var a = RigidBody.new()
		a.gravity_scale = 0
		a.mode = RigidBody.MODE_CHARACTER
		#a.axis_lock_angular_x = true
		#a.axis_lock_angular_y = true
		#a.axis_lock_angular_z = true
		#a.linear_damp = 0
		a.weight = 100
		a.linear_damp = 100
		add_child(a)
		var b = CollisionShape.new()
		b.shape = BoxShape.new()
		b.shape.extents.x = randi() % 3 + 1
		b.shape.extents.y = randi() % 3 + 1
		b.shape.extents.z = randi() % 3 + 1
		a.add_child(b)
