extends Area2D
class_name Plant

@onready var nav_agent = $NavigationAgent2D

@export var sprite: AnimatedSprite2D
@export var type: Global.PlantType
@export var animated: bool = true

func _ready():
	scale = Global.scale
	call_deferred("_setup")
	if animated:
		sprite.play()

func _setup():
	await get_tree().physics_frame
	
func setup(plant_type: Global.PlantType, new_position: Vector2 = Vector2.ZERO):
	type = plant_type
	position = new_position

func reachable(target: Vector2) -> bool:
	nav_agent.target_position = target
	return nav_agent.is_target_reachable()
