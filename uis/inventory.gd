extends Popup


onready var m_tween = $move_tween
onready var a_tween = $alpha_tween
var current_selected_item = ""

onready var add_quick_slot_button = $add_quick_slot_button

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalRef.inventory = self
	add_quick_slot_button.get_popup().connect("id_pressed", self, "add_quick_slot_item")
	#var viewport_tex = $details/mesh_view/Viewport.get_texture()
	#$details/mesh_view.texture = viewport_tex
	detail_reset()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#get_tree().set_input_as_handled()
	pass


func _gui_input(event):
	#get_tree().set_input_as_handled()
	
	if Input.is_action_just_pressed("inventory") or Input.is_action_just_pressed("ui_cancel"):
		close_button_up()
	
	#accept_event()
	pass


func item_selected(index):
	var datas = $ItemList.get_item_metadata(index)
	$details/name.text = tr(datas[0] + "_name")
	$details/describe.text = tr(datas[0] + "_discribe")
	
	if datas[3] > 1:
		$details/stack.text = str(datas[3]) + " 개"
	else:
		$details/stack.text = ""
	
	$details/mesh_view/Viewport/item_mesh_in_inventory.set_mesh(datas[4], datas[5])
	$inventory_click_sfx.play()
	# 아이템 타입에 따라서 '사용, 장비' 버튼 활성화
	
	current_selected_item = datas[0]
	GlobalRef.quick_slot_manager.selected_slot_item = current_selected_item
	
	pass # Replace with function body.

func add_item(datas): # 코드네임, 타입, (이름), (설명), 아이콘, 갯수, 모델, 표시 스케일
	if $ItemList.get_item_count() == 0:
		$ItemList.add_item("", datas[2])
		$ItemList.set_item_metadata($ItemList.get_item_count() - 1, datas)
	else:
		for i in $ItemList.get_item_count():
			var inv_data = $ItemList.get_item_metadata(i)
			if datas[0] == inv_data[0]:
				inv_data[3] += 1
				$ItemList.set_item_metadata(i, inv_data)
				break
			else:
				if i == $ItemList.get_item_count()-1:
					$ItemList.add_item("", datas[2])
					$ItemList.set_item_metadata($ItemList.get_item_count() - 1, datas)
	get_node("get_item_sfx").play()

func consume_item(code_name):
	for i in $ItemList.get_item_count():
		var inv_data = $ItemList.get_item_metadata(i)
		if code_name == inv_data[0]:
			if inv_data[3] > 1:
				inv_data[3] -= 1
				$ItemList.set_item_metadata(i, inv_data)
			else:
				$ItemList.remove_item(i)
				current_selected_item = ""
			break
	if GlobalRef.quick_slot_manager:
		var quick_slot = GlobalRef.quick_slot_manager.get_current_slot_by_code_name(code_name)
		if quick_slot:
			quick_slot.slot_setting(null)

func visibility_changed():
	if visible:
		
		m_tween.remove_all()
		a_tween.remove_all()
		
		$details/mesh_view/Viewport/item_mesh_in_inventory.rotation_reset()
		m_tween.interpolate_property(self, "rect_position:x", 180, 0, .5, Tween.TRANS_EXPO, Tween.EASE_OUT)
		m_tween.start()
		a_tween.interpolate_property(self, "modulate:a", 0.39, 1, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
		a_tween.start()
		
		#if $ItemList.is_anything_selected():
		#	var selected_item_list = $ItemList.get_selected_items()
		#	item_selected(selected_item_list[0])
		if current_selected_item:
			$ItemList.select(get_index_by_code_name(current_selected_item))
			item_selected(get_index_by_code_name(current_selected_item))
		else:
			$ItemList.unselect_all()
		
	pass # Replace with function body.

func detail_reset():
	$details/name.text = ""
	$details/describe.text = ""
	$details/stack.text = ""
	$details/mesh_view/Viewport/item_mesh_in_inventory.set_mesh(null, Vector3(1, 1, 1))


func close_button_up():
	
	if !m_tween.is_active():
		
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
		m_tween.remove_all()
		a_tween.remove_all()
		
		m_tween.interpolate_property(self, "rect_position:x", 0, 180, 1.0, Tween.TRANS_EXPO, Tween.EASE_OUT)
		m_tween.start()
		a_tween.interpolate_property(self, "modulate:a", 1, 0, .3, Tween.TRANS_EXPO, Tween.EASE_OUT)
		a_tween.start()
		
		yield(a_tween, "tween_completed")
		
		hide()
		detail_reset()
		#$ItemList.unselect_all()
	pass # Replace with function body.


func get_metadata_by_code_name(code_name):
	if code_name != null:
		for i in $ItemList.get_item_count():
			var inv_data = $ItemList.get_item_metadata(i)
			if code_name == inv_data[0]:
				return inv_data
			else:
				if i == $ItemList.get_item_count() - 1:
					return null


func add_quick_slot_item(id):
	GlobalRef.quick_slot_manager.get_node("quick_slot" + str(id)).slot_setting(current_selected_item)


func get_index_by_code_name(code_name):
	for i in $ItemList.get_item_count():
		var inv_data = $ItemList.get_item_metadata(i)
		if code_name == inv_data[0]:
			return i
		else:
			if i == $ItemList.get_item_count()-1:
				return null


func _on_add_quick_slot_button_about_to_show():
	var pop = add_quick_slot_button.get_popup()
	grab_focus()
	for i in 3:
		if GlobalRef.quick_slot_manager:
			var current_slot_item = GlobalRef.quick_slot_manager.get_node("quick_slot" + str(i + 1)).slot_item
			if current_slot_item:
				pop.set_item_text(i, tr(current_slot_item + "_name"))
				pop.set_item_icon(i, get_metadata_by_code_name(current_slot_item)[2])
			else:
				pop.set_item_text(i, " -없음- ")
				pop.set_item_icon(i, load("res://2d/radial_selected_item_slot.png"))
	pass # Replace with function body.
