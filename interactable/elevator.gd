extends CSGCombiner

export var current_floor = 0
export var target_pos = 0
export var time = 1.0

export var go_up = true
export var moving = false

export (NodePath) var floor_position

signal buttons_toggle

# Called when the node enters the scene tree for the first time.
func _ready():
	
	floor_position = get_node(floor_position)
	
	#start_pos_y = translation.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _move(target_floor):
	target_pos = floor_position.get_child(target_floor).translation.y
	current_floor = target_floor
	
	if !moving:
		moving = !moving
		$sound_animation.play("start")
		emit_signal("buttons_toggle")


func tween_all_completed():
	$sound_animation.play("finish")
	print("도착")
	pass # Replace with function body.


func sound_animation_finished(anim_name):
	if anim_name == "start":
		$Tween.interpolate_property(self, "translation:y", translation.y, target_pos, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
		$sound_animation.play("progress")
	elif anim_name == "finish":
		moving = false
		emit_signal("buttons_toggle")
	pass # Replace with function body.
