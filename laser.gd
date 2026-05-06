extends Area2D
@export var warning = 1.2
@export var last = 1.5
var touchesplr = false
var active = false
func _ready() -> void:
	match game.difficulty:
		0: last = 0.3
		1: last = 0.6
		2: last = 1.1
	$Sprite2D.modulate = Color(1,1,1,0.3)
	await get_tree().create_timer(warning).timeout
	active = true
	$Sprite2D.modulate = Color(1,1,1,1)
	await get_tree().create_timer(last).timeout
	active = false
	var tween = create_tween()
	tween.tween_property($Sprite2D,"modulate",Color(1,1,1,0),0.5)
	await tween.finished
	queue_free()

func _process(delta: float) -> void:
	if touchesplr and active:
		get_tree().get_first_node_in_group("player").hp -= 1
		active = false
		var tween = create_tween()
		tween.tween_property($Sprite2D,"modulate",Color(1,1,1,0),0.5)
		await tween.finished
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		touchesplr = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		touchesplr = false
