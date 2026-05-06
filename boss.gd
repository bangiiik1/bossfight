extends CharacterBody2D
@export var ram = false
@export var hp = 30
var flydir = Vector2.ZERO
func _ready() -> void:
	match game.difficulty:
		0: $Timer.wait_time = 1.7
		1: $Timer.wait_time = 1.5
		2: $Timer.wait_time = 1.2
		4: $Timer.wait_time = 0.7
	match game.difficulty:
		0: hp = 23
		1: hp = 26
		2: hp = 28
		4: hp = 35
	match game.difficulty:
		1: $fly.wait_time = 0.23
		2: $fly.wait_time = 0.16
		4: $fly.wait_time = 0.07
func shoot(speed: float,direction:float, pos:Vector2):
	var bullet = preload("res://bullet.tscn").instantiate()
	bullet.direction = direction
	bullet.speed = speed
	bullet.position = pos
	get_tree().root.add_child(bullet)
func shootlaser(pos,rot):
	var laser = preload("res://laser.tscn").instantiate()
	laser.position = pos
	laser.rotation_degrees = rot
	get_tree().root.add_child(laser)
func circle(delay):
	await get_tree().create_timer(delay).timeout
	var projectiles = 10
	match game.difficulty:
		0: projectiles = 5
		1: projectiles = 6
		2: projectiles = 8
		4: projectiles = 12
	for i in range(projectiles):
		shoot(250,
		deg_to_rad(i*(360/projectiles)),
		global_position)
func dash():
	ram = true
	var startpos = global_position
	var tween = create_tween()
	var speed = 500
	match game.difficulty:
		0: speed = 250
		1: speed = 400
		2: speed = 450
		4: speed = 600
	var time = startpos.distance_to(get_tree().get_first_node_in_group("player").global_position)/speed
	circle(time/2)
	tween.tween_property(self,"global_position",get_tree().get_first_node_in_group("player").global_position,time)
	tween.tween_interval(0.5)
	tween.tween_property(self,"global_position",startpos,time)
	await tween.finished
	ram = false
func _on_timer_timeout() -> void:
	if hp <= 0:
		return
	var random = randi_range(1,8)
	if game.difficulty == 0: random -= 1
	if ram:
		return
	if random <= 1:
		shoot(400,
		(get_tree().get_first_node_in_group("player").global_position - global_position).angle(),
		global_position)
	if random == 2:
		for i in range(3):
			shoot(200,
			(get_tree().get_first_node_in_group("player").global_position - global_position).angle() + deg_to_rad((i-1)*15),
			global_position)
	if random == 3:
		for i in range(3):
			shoot(100,
			(get_tree().get_first_node_in_group("player").global_position - global_position).angle() + deg_to_rad((i-1)*30),
			global_position)
		await get_tree().create_timer(0.2).timeout
		shoot(100,
		(get_tree().get_first_node_in_group("player").global_position - global_position).angle() + deg_to_rad(-15),
		global_position)
		shoot(100,
		(get_tree().get_first_node_in_group("player").global_position - global_position).angle() + deg_to_rad(15),
		global_position)
	if random == 4:
		dash()
	if random == 5:
		var bullet = preload("res://bullet.tscn").instantiate()
		bullet.speed = 300
		bullet.bomb = true
		bullet.position = global_position
		bullet.direction = (get_tree().get_first_node_in_group("player").global_position - global_position).angle()
		get_tree().root.add_child(bullet)
	if random == 6:
		var randomangle = randf_range(0,360)
		shootlaser(get_tree().get_first_node_in_group("player").global_position,randomangle)
		shootlaser(get_tree().get_first_node_in_group("player").global_position,randomangle+90)
	if random == 7:
		var windowsize = get_viewport_rect().size
		var amout = 4
		if game.difficulty == 0: amout = 2
		if game.difficulty == 1: amout = 3
		for i in range(amout):
			shootlaser(Vector2(randf_range(0,windowsize.x),randf_range(0,windowsize.y)),randf_range(0,360))
	if random == 8:
		ram = true
		$fly.start()
		var speed = 300
		var oldprogress = get_parent().progress
		var opposite = fmod((get_parent().progress + get_parent().get_parent().curve.get_baked_length()/2), get_parent().get_parent().curve.get_baked_length())
		get_parent().progress = opposite
		var oppositepos = global_position
		get_parent().progress = oldprogress
		var tween = create_tween()
		flydir = oppositepos-global_position
		tween.tween_property(self,"global_position",oppositepos,oppositepos.distance_to(global_position)/speed)
		await tween.finished
		get_parent().progress = opposite
		ram = false
		position = Vector2.ZERO
		$fly.stop()
func _process(delta: float) -> void:
	if hp <= 0:
		game.win = 2
		get_tree().change_scene_to_file("res://menu.tscn")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.hp -= 1
		var tween = create_tween()
		tween.tween_property(body,"global_position",body.position + (body.position-global_position).normalized()*300,0.7)
func takedmg():
	hp -= 1
	$Sprite2D.modulate = Color(1,0,0,1)
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.modulate = Color(1,1,1,1)


func _on_fly_timeout() -> void:
	shoot(400,
	(get_tree().get_first_node_in_group("player").global_position - global_position).angle()+deg_to_rad(randf_range(0,360)),
	global_position)
