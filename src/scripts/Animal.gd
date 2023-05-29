extends CharacterBody2D
class_name Animal


@onready var nav_agent = $NavigationAgent2D
@onready var destination_timer = $DestinationTimer
@onready var hunger_timer = $HungerTimer

@export var sprite: AnimatedSprite2D
@export var speed := 500.0
@export var hungry_speed_mult := 2.0
@export var type: Global.AnimalType
@export var omnivore := true
@export var prey_types: Array[Global.AnimalType]
@export var food_types: Array[Global.PlantType]
@export var hunger_time: float = 10.0
@export var base_health: int = 10
@export var vision_dist: int = 100
@export var destination_timer_min := 4.0
@export var destination_timer_max := 15.0

var health: int = 10
var hungry := false
var currently_searching := false
var current_target = null
var current_target_type = null
var angle := 0.0

func _ready():
	scale = Global.scale
	call_deferred("_setup")
	health = base_health
	sprite.play()
	hunger_timer.start(hunger_time)
	_on_destination_timer_timeout()

func _setup():
	await get_tree().physics_frame
	
func setup(animal_type: Global.AnimalType, new_position: Vector2 = Vector2.ZERO):
	type = animal_type
	position = new_position

func reachable(target: Vector2) -> bool:
	nav_agent.target_position = target
	return nav_agent.is_target_reachable()


func _physics_process(delta):
	if nav_agent.is_navigation_finished():
		return
	
	if nav_agent.is_target_reachable():
		if hungry:
			velocity = (nav_agent.get_next_path_position() - position).normalized() * speed * hungry_speed_mult * delta
		else:
			velocity = (nav_agent.get_next_path_position() - position).normalized() * speed * delta
			
		move_and_slide()

func find_new_target():
	if omnivore:
		for prey_type in prey_types:
			var prey = Global.get_closest(position, prey_type, true, vision_dist)
			if prey:
				current_target = prey
				current_target_type = prey_type
				print("picked " + Global.animal_name_dict[current_target_type] + " at " + str(current_target.position))
				return
	for food_type in food_types:
		var food = Global.get_closest(position, food_type, false, vision_dist)
		if food:
			current_target = food
			current_target_type = food_type
			print("picked " + Global.plant_name_dict[current_target_type] + " at " + str(current_target.position))
			return

func set_destination(location: Vector2):
	nav_agent.target_position = location

func _on_hunger_timer_timeout():
	health -= 1
	print("ouch")
	if health <= (float(base_health) / 2):
		hungry = true
		print("hungry")
	hunger_timer.start(hunger_time)
	if health == 0:
		print("dead")
		queue_free()

func _on_destination_timer_timeout():
	if hungry:
		find_new_target()
		if current_target:
			set_destination(current_target.position)
			destination_timer.start(0.1)
		else:
			pick_rnd_dest()
	else:
		pick_rnd_dest()
		

func pick_rnd_dest():
	for i in range(50):
		set_destination(Global.rand_vector_near(position, 64, 72))
		if nav_agent.is_target_reachable():
			break
	if not nav_agent.is_target_reachable():
		set_destination(position)
		print("invalid destination")
	else:
		print("moving towards " + str(nav_agent.target_position))
	destination_timer.start(randf_range(destination_timer_min, destination_timer_max))
