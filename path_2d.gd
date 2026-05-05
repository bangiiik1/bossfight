extends Path2D
@export var speed = 200
func _process(delta: float) -> void:
	if $PathFollow2D/boss.ram:
		$PathFollow2D.set_process(false)
		return
	if !$PathFollow2D.is_processing():
		$PathFollow2D.set_process(true)
	$PathFollow2D.progress += speed*delta
