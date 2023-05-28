extends Node

func rand_vector_near(baseVector: Vector2, maxDistance: float) -> Vector2:
	var randomAngle = randf_range(0, 2 * PI)
	var randomDistance = randf_range(0, maxDistance)
	var xOffset = randomDistance * cos(randomAngle)
	var yOffset = randomDistance * sin(randomAngle)
	var randomVector = Vector2(xOffset, yOffset)
	
	return baseVector + randomVector
