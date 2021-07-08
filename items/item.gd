extends Interactable

var usable = true
export var code_name = ""
export var item_type = 0
export var item_stack = 1
#export var item_name = "normal building"
#export (String, MULTILINE) var item_describe = "this is item describe"
export (Texture) var inventory_icon
export (Vector3) var display_scale = Vector3(1, 1, 1)

# 코드네임, 타입, (이름), (설명), 아이콘, 갯수, 모델, 표시 스케일
onready var datas = [code_name, item_type, inventory_icon, item_stack, $mesh.mesh.duplicate(false), display_scale]
onready var tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	action = actions.hand
	var mat = $mesh.mesh.surface_get_material(0)
	$mesh.mesh.surface_set_material(0, mat.duplicate(false))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func interact():
	GlobalRef.textbox.text_setting( tr("item_get_messege").format( [ tr(code_name + "_name") ] ), 2.0)
	GlobalRef.inventory.add_item(datas)
	call("set_collision_layer_bit" , 0, false)
	$flicker_effect.queue_free()
	disappear()
	

func disappear():
	var mat = $mesh.mesh.surface_get_material(0)
	mat.flags_transparent = true
	tween.interpolate_property(mat, "albedo_color:a", 1, 0, .5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()
