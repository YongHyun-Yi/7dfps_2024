extends Spatial


onready var lamp_light = $OmniLight
onready var lamp_emission = $SpotLight


# Called when the node enters the scene tree for the first time.
func _ready():
	#turn_on()
	#turn_off()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func turn_on():
	lamp_light.show()
	lamp_emission.show()
	$buzz_sfx.play()
	#print("on")

func turn_off(): # 기본값
	lamp_light.hide()
	lamp_emission.hide()
	$buzz_sfx.stop()
	#print("off")
