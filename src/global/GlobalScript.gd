extends Node

enum PlantType {
	Algae,
	Berry
}

enum AnimalType {
	Fish,
	Bunny,
	Bear
}

var plant_name_dict = { 
	PlantType.Algae: "algae",
	PlantType.Berry: "berry"
}

var animal_name_dict = { 
	AnimalType.Fish: "fish",
	AnimalType.Bunny: "bunny",
	AnimalType.Bear: "bear"
}

var map_size_x: int = 512
var map_size_y: int = 512
var scale: Vector2 = Vector2(1.25, 1.25)

func rand_vector_near(base_vector: Vector2, min_dist: float, max_dist: float) -> Vector2:
	var rand_angle = randf_range(0, 2 * PI)
	var rand_dist = randf_range(min_dist, max_dist)
	var x_offset = rand_dist * cos(rand_angle)
	var y_offset = rand_dist * sin(rand_angle)
	var rand_vector = Vector2(x_offset, y_offset)
	var new_vector = base_vector + rand_vector
	var clamped_x = clamp(new_vector.x, 0, map_size_x)
	var clamped_y = clamp(new_vector.y, 0, map_size_y)
	return Vector2(clamped_x, clamped_y)
	
func get_closest(origin: Vector2, target_type, animal: bool, max_dist: int):
	var target_list = []
	if animal:
		target_list = get_tree().get_nodes_in_group(animal_name_dict[target_type])
	else:
		target_list = get_tree().get_nodes_in_group(plant_name_dict[target_type])
	
	var closest = null
	var closest_dist = max(map_size_x, map_size_y) * 2
	for target in target_list:
		var dist = origin.distance_to(target.position)
		if dist < closest_dist && dist <= max_dist:
			closest_dist = dist
			closest = target
	
	return closest
