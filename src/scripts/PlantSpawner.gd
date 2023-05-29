extends Node2D

@export var plant_scene: PackedScene
@export var breed_time: float = 10.0
@export var max_pop: int = 25
@export var min_spawn_dist: int = 16
@export var max_spawn_dist: int = 32
@export var plant_type: Global.PlantType

@onready var breed_timer = $BreedTimer

var plant_name: String

func _ready():
	plant_name = Global.plant_name_dict[plant_type]
	breed_timer.start(breed_time * randf_range(0.8, 1.5))

func _on_breed_timer_timeout():
	var plants = get_tree().get_nodes_in_group(plant_name)
	if plants.is_empty():
		print("no " + plant_name + "s found")
		return
	elif plants.size() >= max_pop:
		pass
	else:
		var mother_plant: Plant = plants.pick_random()
		var new_position = Global.rand_vector_near(mother_plant.position, min_spawn_dist, max_spawn_dist)
		if mother_plant.reachable(new_position):
			var new_plant: Plant = plant_scene.instantiate()
			new_plant.hide()
			new_plant.position = new_position
			new_plant.setup(plant_type, new_position)
			add_child(new_plant)
			new_plant.show()
	
	breed_timer.start(breed_time * randf_range(0.8, 1.5))

