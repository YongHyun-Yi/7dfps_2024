extends TextureButton


var slot_item = null
var selected = false setget set_selected


# Called when the node enters the scene tree for the first time.
func _ready():
	slot_setting(slot_item)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func mouse_entered():
	if !selected and slot_item:
		modulate.a = 1
	pass # Replace with function body.


func mouse_exited():
	if !selected and slot_item:
		modulate.a = .39
	pass # Replace with function body.


func slot_pressed():
	if !selected and slot_item:
		if GlobalRef.quick_slot_manager:
			GlobalRef.quick_slot_manager.selected_slot_setting(slot_item)
			
			for i in 3:
				var current_slot = GlobalRef.quick_slot_manager.get_node("quick_slot" + str(i + 1))
				current_slot.selected = false
			
			self.selected = true
	pass # Replace with function body.


func slot_setting(code_name):
	if code_name == null:
		$icon.texture = null
		$stack.text = ""
		slot_item = null
		if selected:
			self.selected = false
	
	else:
		if GlobalRef.quick_slot_manager:
			var prev_slot_check = GlobalRef.quick_slot_manager.get_current_slot_by_code_name(code_name)
			
			if prev_slot_check != null:
				prev_slot_check.slot_setting(null)
			
			var item_metadata = GlobalRef.inventory.get_metadata_by_code_name(code_name)
			
			$icon.texture = item_metadata[2]
			
			if item_metadata[3] > 2:
				$stack.text = str(item_metadata[3])
			else:
				$stack.text = ""
			
			slot_item = item_metadata[0]


func slot_update():
	if slot_item != null:
		if GlobalRef.quick_slot_manager:
			var item_metadata = GlobalRef.inventory.get_metadata_by_code_name(slot_item)
			
			if item_metadata != null: # 아이템이 인벤토리에 존재할경우
				if item_metadata[3] > 2:
					$stack.text = str(item_metadata[3])
				else:
					$stack.text = ""
				
				if slot_item == GlobalRef.quick_slot_manager.selected_slot_item:
					if !selected:
						self.selected = true
				else:
					if selected:
						self.selected = false
				
			else:
				slot_setting(null)


func visibility_changed():
	if visible:
		slot_update()
	pass # Replace with function body.


func set_selected(value):
	
	selected = value
	
	if value:
		modulate.a = 1
	else:
		modulate.a = .39
	
	disabled = value
	#print(name + str(selected))
