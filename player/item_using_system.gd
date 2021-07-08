extends Node





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if Input.is_action_just_pressed("consume_item"):
		match GlobalRef.inventory.current_selected_item:
			"item_coin":
				GlobalRef.textbox.text_setting("아이템을 사용했습니다.", 2.0)
				get_parent().consume_item(GlobalRef.inventory.current_selected_item)
