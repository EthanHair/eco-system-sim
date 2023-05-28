extends Area2D
class_name Plant

@onready var nav_agent = $NavigationAgent2D
@onready var sprite = $AnimatedSprite2D

func _ready():
	call_deferred("_setup")
	sprite.play()

func _setup():
	await get_tree().physics_frame

func reachable(target: Vector2) -> bool:
	nav_agent.target_position = target
	return nav_agent.is_target_reachable()
