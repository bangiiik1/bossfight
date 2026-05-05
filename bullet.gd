extends Area2D
@export var speed = 0
@export var direction = 0
@export var bomb = false
@export var timetoexplode = 1
func _process(delta: float) -> void:
	var velocity = Vector2.from_angle(direction)
	velocity *= speed
	global_position += velocity*delta
func explode():
	for i in range(3):
		var bullet = preload("res://bullet.tscn").instantiate()
		bullet.speed = 500
		bullet.direction = randf_range(0,TAU)
		bullet.position = position
		get_tree().root.add_child(bullet)
	queue_free()
func _ready():
	if bomb:
		scale = Vector2(1.5,1.5)
		await get_tree().create_timer(timetoexplode).timeout
		explode()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.hp -= 1
		queue_free()
