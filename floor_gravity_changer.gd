extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func body_entered(body):
	
	if body is player:
		body.floor_gravity = 3.0
	
	pass # Replace with function body.


func body_exited(body):
	
	if body is player:
		body.floor_gravity = 1.0
	
	pass # Replace with function body.
