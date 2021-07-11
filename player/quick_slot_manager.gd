extends Popup

# 필요한것 : 코드네임 - 이름에 접근, 스프라이트 - 칸 안에 표시용, 갯

onready var selected_slot = $selected_slot

onready var slot1 = $slot1
onready var slot2 = $slot2
onready var slot3 = $slot3

var selected_slot_item = null

var slot1_item = null
var slot2_item = null
var slot3_item = null

var mouse_on_slot = null

export var show_anim_end = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	GlobalRef.quick_slot_manager = self
	
	selected_slot_setting(selected_slot_item)
	
	#for i in 3:
	#	var current_slot = get("slot" + str(i + 1))
		
	#	slot_setting(i + 1, null)
	#	current_slot.get_node("Area2D").connect("mouse_entered", self, "slot_mouse_enter", [i + 1])
	#	current_slot.get_node("Area2D").connect("mouse_exited", self, "slot_mouse_exit")
		#current_slot.get_node("Area2D/CollisionPolygon2D").disabled = true
		
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if visible:
		if Input.is_action_just_pressed("left_click"):
			if mouse_on_slot and get(mouse_on_slot.name + "_item"):
				selected_slot_setting(get(mouse_on_slot.name + "_item"))
				#slot_update()


func _gui_input(event):
	if Input.is_action_just_released("radial_menu"):
		hide()
		accept_event()
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		for i in 3:
			var current_slot = get("slot" + str(i + 1))
			
			current_slot.get_node("Area2D/CollisionPolygon2D").disabled = true


func _on_quick_slot_manager_visibility_changed():
	if visible:
		selected_slot_update()
		#slot_update()
		$AnimationPlayer.play("show")
	pass # Replace with function body.


func selected_slot_setting(code_name): # 코드네임, 타입, 아이콘, 갯수, 모델, 표시 스케일
	if code_name == null:
		selected_slot.get_node("Sprite").texture = null
		selected_slot.get_node("name").text = ""
		selected_slot.get_node("stack").text = ""
		selected_slot_item = null
		if GlobalRef.inventory:
			GlobalRef.inventory.current_selected_item = null
	else:
		var item_metadata = GlobalRef.inventory.get_metadata_by_code_name(code_name)
		selected_slot.get_node("Sprite").texture = item_metadata[2]
		selected_slot.get_node("name").text = tr(code_name + "_name")
		if item_metadata[3] > 2:
			selected_slot.get_node("stack").text = str(item_metadata[3]) + " 개"
		else:
			selected_slot.get_node("stack").text = ""
		selected_slot_item = code_name
		GlobalRef.inventory.current_selected_item = code_name


func selected_slot_update():
	
	if selected_slot_item != null:
		var item_metadata = GlobalRef.inventory.get_metadata_by_code_name(selected_slot_item)
		
		if item_metadata != null:
			selected_slot_setting(selected_slot_item)
		else:
			selected_slot_setting(null)
			selected_slot_item = null
"""

func slot_setting(slot_index, code_name):
	
	var current_slot = get("slot" + str(slot_index))
	
	if code_name == null:
		current_slot.get_node("Sprite").texture = null
		current_slot.get_node("stack").text = ""
		set("slot" + str(slot_index) + "_item", null)
	
	else:
		var prev_slot_check = get_current_slot_by_code_name(code_name)
		
		if prev_slot_check != null:
			slot_setting(prev_slot_check, null)
		
		var item_metadata = GlobalRef.inventory.get_metadata_by_code_name(code_name)
		
		current_slot.get_node("Sprite").texture = item_metadata[2]
		if item_metadata[3] > 2:
			current_slot.get_node("stack").text = str(item_metadata[3])
		else:
			current_slot.get_node("stack").text = ""
		
		set("slot" + str(slot_index) + "_item", item_metadata[0])


func slot_update():
	for i in 3:
		var current_slot = get("slot" + str(i + 1))
		var current_slot_item = get("slot" + str(i + 1) + "_item")
		
		if current_slot_item != null:
			var item_metadata = GlobalRef.inventory.get_metadata_by_code_name(current_slot_item)
			
			if item_metadata != null:
				slot_setting(i + 1, current_slot_item)
				
				if selected_slot_item != current_slot_item:
					current_slot.modulate.a = .39
				else:
					current_slot.modulate.a = 1
				
			else:
				slot_setting(i + 1, null)
				set("slot" + str(i + 1) + "_item", null)
		else:
			current_slot.modulate.a = .39
	pass

"""
func get_current_slot_by_code_name(code_name):
	for i in 3:
		if code_name == get_node("quick_slot" + str(i + 1)).slot_item:
			return get_node("quick_slot" + str(i + 1))
			break
	
	return null

"""
func slot_mouse_enter(slot_index):
	print("1")
	mouse_on_slot = get("slot" + str(slot_index))
	var current_slot_item = get(mouse_on_slot.name + "_item")
	
	if current_slot_item != null:
		mouse_on_slot.modulate.a = 1


func slot_mouse_exit():
	print("2")
	var current_slot_item = get(mouse_on_slot.name + "_item")
	
	if current_slot_item != selected_slot_item:
		mouse_on_slot.modulate.a = .39
		
	mouse_on_slot = null
"""
