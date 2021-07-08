extends Spatial


onready var switch_interaction_area = $swtich/Area
onready var lights = $lights


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in lights.get_children():
		switch_interaction_area.connect("turn_off", i, "turn_off")
		switch_interaction_area.connect("turn_on", i, "turn_on")
		
	if switch_interaction_area.turn_on:
		switch_interaction_area.emit_signal("turn_on")
		switch_interaction_area.night_light.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
