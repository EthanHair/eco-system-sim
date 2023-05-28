extends Node2D

@export var plant_scene: PackedScene
@export var breed_time: float = 10.0
@export var plant_group_name: String

@onready var breed_timer = $BreedTimer

func _ready():
	breed_timer.start(breed_time * randf_range(0.8, 1.5))

func _on_breed_timer_timeout():
	var plants = get_tree().get_nodes_in_group(plant_group_name)
	if plants.is_empty():
		print("no " + plant_group_name + "s found")
		return
	
	var mother_plant: Plant = plants.pick_random()
	var new_position = Global.rand_vector_near(mother_plant.position, 32)
	if mother_plant.reachable(new_position):
		var new_plant: Plant = plant_scene.instantiate()
		new_plant.hide()
		new_plant.position = new_position
		add_child(new_plant)
		new_plant.show()
		print("added a(n) " + plant_group_name + " at " + str(new_position))
	else:
		print("cannot place a(n) " + plant_group_name + " there")
	
	breed_timer.start(breed_time * randf_range(0.8, 1.5))
