extends Area2D
@export var speed = 0
@export var direction = 0
func _process(delta: float) -> void:
	var velocity = Vector2.from_angle(direction)
	velocity *= speed
	global_position += velocity*delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("boss"):
		body.takedmg()
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullet"):
		if area.bomb:
			area.explode()
		else:
			area.queue_free()
		queue_free()
