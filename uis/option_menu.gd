extends Control

var initialized = false

# Called when the node enters the scene tree for the first time.
func _ready():
	initialize()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func initialize():
	$Panel/HBoxContainer/VBoxContainer2/resolution.selected = GlobalOption.current_resolution_index
	$Panel/HBoxContainer/VBoxContainer2/volume.value = GlobalOption.volume
	$Panel/HBoxContainer/VBoxContainer2/mouse_sensitive.value = GlobalOption.mouse_sensitivity
	$Panel/HBoxContainer/VBoxContainer2/brightness.value = GlobalOption.barightness
	$Panel/HBoxContainer/VBoxContainer2/language.selected = GlobalOption.current_language_index
	initialized = true

func close_button_up():
	get_parent().current_tab = 0
	pass # Replace with function body.


func resolution_selected(index):
	
	var resolutions = [[Vector2(1920, 1080), false], [Vector2(1280, 720), false], [Vector2(960, 540), false], [Vector2(1920, 1080), true], [Vector2(1280, 720), true], [Vector2(960, 540), true]]
	
	if index == 0:
		OS.window_fullscreen = true
	else:
		if OS.window_fullscreen:
			OS.window_fullscreen = false
		OS.window_size = resolutions[index - 1][0]
		OS.window_borderless = resolutions[index-1][1]
		OS.window_position = (OS.get_screen_size() / 2) - (resolutions[index - 1][0] / 2)
	GlobalOption.current_resolution_index = index



func volume_value_changed(value):
	if initialized:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear2db(value))
	pass # Replace with function body.


func mouse_sensitive_value_changed(value):
	if initialized:
		GlobalOption.mouse_sensitivity = value
	pass # Replace with function body.


func brightness_value_changed(value):
	if initialized:
		var world_env1 = load("res://world_env1.tres")
		world_env1.tonemap_exposure = value
	pass # Replace with function body.


func language_selected(index):
	
	var languages = ["en", "ko"]
	
	TranslationServer.set_locale(languages[index])
	GlobalOption.current_language_index = index
	
