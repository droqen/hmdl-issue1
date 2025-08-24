extends Node2D

var ani : float = 0.0
const FRAMES : Array[int] = [0,1,1,0,2,2]

func _physics_process(_delta: float) -> void:
	ani = fposmod(ani + 0.05, 6)
	$Sprite2D.frame = FRAMES[int(ani)]
	if Input.is_action_pressed("ui_left"): position.x -= 1
	if Input.is_action_pressed("ui_right"): position.x += 1
	if Input.is_action_pressed("ui_down"): position.y += 1
	if Input.is_action_pressed("ui_up"): position.y -= 1
