extends ColorRect
@onready var stick = $stick
@export var walkjoy = false
var direction = Vector2.ZERO
var dist = 200
func _ready() -> void:
	if !OS.has_feature("mobile"):
		queue_free()
func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag and global_position.distance_to(event.position) > dist:
		return
	if event is InputEventScreenDrag:
		stick.position = event.position-position - stick.size/2
		direction = (stick.position-Vector2(size.x/2-stick.size.x/2,size.y/2-stick.size.y/2)).normalized()
	if event is InputEventScreenTouch and !event.is_pressed():
		if !walkjoy:
			get_node("/root/main/player").shoot(direction.angle())
		stick.position = Vector2(size.x/2-stick.size.x/2,size.y/2-stick.size.y/2)
		direction = Vector2.ZERO
