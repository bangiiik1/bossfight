extends Control

func _ready() -> void:
	if game.win > 0:
		$start.text = "ещё раз"
	if game.win == 1:
		$text.text = "ты проиграл!"
	if game.win == 2:
		$text.text = "ты победил!"
	if game.ismobile:
		$device.selected = 1
func _on_start_pressed() -> void:
	if $device.selected == 1:
		game.ismobile = true
	else:
		game.ismobile = false
	get_tree().change_scene_to_file("res://main.tscn")


func _on_deviceb_pressed() -> void:
	if $device.selected == 0:
		$device.selected = 1
	else:
		$device.selected = 0



func _on_startb_pressed() -> void:
	$start.emit_signal("pressed")
