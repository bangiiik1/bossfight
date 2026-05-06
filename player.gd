extends CharacterBody2D
@export var speed = 200
@export var hp = 3
@onready var joy = get_node("/root/main/ui/CanvasLayer/joy")
var canshoot = true
var bulletscn = preload("res://mybullet.tscn")
func _ready() -> void:
	match game.difficulty:
		0: hp = 4
		1: hp = 4
		4: hp = 2
func shoot(angle):
	if canshoot:
		$cooldown.start()
		canshoot = false
		var bullet = bulletscn.instantiate()
		get_tree().root.add_child(bullet)
		bullet.position = position
		bullet.direction = angle
		bullet.speed = 300
func _physics_process(delta: float) -> void:
	if hp <= 0:
		get_tree().change_scene_to_file("res://menu.tscn")
		game.win = 1
		return
	var direction = Vector2.ZERO
	direction.x += Input.get_action_strength("d")-Input.get_action_strength("a")
	direction.y += Input.get_action_strength("s")-Input.get_action_strength("w")
	if game.ismobile:
		direction = joy.direction
	direction = direction.normalized()
	velocity = direction*speed
	move_and_slide()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		shoot((get_global_mouse_position()-global_position).angle())
	var screen_size = get_viewport().get_visible_rect().size
	global_position.x = clamp(global_position.x, 0, screen_size.x)
	global_position.y = clamp(global_position.y, 0, screen_size.y)


func _on_cooldown_timeout() -> void:
	canshoot = true
