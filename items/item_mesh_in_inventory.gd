extends Spatial

var mouse_on = false
var clicked = false
var col_shp


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if mouse_on and !clicked:
		if Input.is_action_just_pressed("left_click"):
			clicked = true
	elif clicked:
		if Input.is_action_just_released("left_click"):
			clicked = false
	
	if !clicked:
		$Spatial.rotation_degrees.y -= .1

func _unhandled_input(event):
	if clicked:
		if event is InputEventMouseMotion:
			$Spatial.rotation_degrees.y += event.relative.x
			$Spatial.rotation_degrees.x += event.relative.y


func set_mesh(mesh, display_scale):
	$Spatial.rotation_degrees.y = 0
	$Spatial/mesh.mesh = mesh
	$Spatial/mesh.scale = display_scale
	if mesh != null:
		col_shp = $Spatial/mesh.mesh.create_trimesh_shape()
		$Spatial/mesh/Area/CollisionShape.shape = col_shp
	else:
		$Spatial/mesh/Area/CollisionShape.shape = null

func rotation_reset():
	$Spatial.rotation_degrees.y = 0


func Area_mouse_entered():
	#print("1")
	mouse_on = true
	pass # Replace with function body.


func Area_input_event(camera, event, click_position, click_normal, shape_idx):
	#if event.is_action_pressed("left_click", true):
	#	if !clicked:
	#		clicked = true
	#	print("1")
	#elif event.is_action_released("left_click"):
	#	if !clicked:
	#		clicked = false
	#	print("2")
	pass # Replace with function body.


func Area_mouse_exited():
	mouse_on = false
	pass # Replace with function body.
