extends ProgressBar
func _process(delta: float) -> void:
	var boss = get_tree().root.get_node("main/Path2D/PathFollow2D/boss")
	value = boss.hp
