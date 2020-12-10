extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalRef.inventory = self
	var viewport_tex = $details/mesh_view/Viewport.get_texture()
	$details/mesh_view.texture = viewport_tex
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func item_selected(index):
	var datas = $ItemList.get_item_metadata(index)
	$details/name.text = datas[0]
	$details/describe.text = datas[1]
	$details/mesh_view/Viewport/item_mesh_in_inventory.set_mesh(datas[3])
	pass # Replace with function body.

func add_item(datas): # 이름, 설명, 아이콘, 모델
	$ItemList.add_item("", datas[2])
	$ItemList.set_item_metadata($ItemList.get_item_count() - 1, datas)
