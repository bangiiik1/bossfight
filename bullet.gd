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
	var shards = 3
	match game.difficulty:
		0: shards = 2
		4: shards = 4
	for i in range(shards):
		var bullet = preload("res://bullet.tscn").instantiate()
		if game.difficulty == 0:
			bullet.speed = 300
		else:
			bullet.speed = 500
		if game.difficulty == 4: bullet.speed = 550
		if game.difficulty == 1: bullet.speed = 350
		if game.difficulty == 2: bullet.speed = 450
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
