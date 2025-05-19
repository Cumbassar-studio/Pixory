extends RigidBody2D

@export var pickup_scene: PackedScene  # сцена PickupItem с ломом

func _integrate_forces(state):
	# Если скорость стала очень маленькой (лом упал)
	if linear_velocity.length() < 10:
		spawn_pickup()
		queue_free()

func spawn_pickup():
	var pickup = pickup_scene.instantiate()

	var space_state = get_world_2d().direct_space_state

	var from_pos = global_position
	var to_pos = global_position + Vector2(0, 100)  # Луч вниз для поиска поверхности

	var ray_params = PhysicsRayQueryParameters2D.new()
	ray_params.from = from_pos
	ray_params.to = to_pos
	ray_params.exclude = [self]

	var result = space_state.intersect_ray(ray_params)

	var offset = Vector2(0, -40)  # Поднимаем на 40 пикселей выше точки столкновения
	
	if result:
		var shape = pickup.get_node("CollisionShape2D").shape
		var half_height = 0
		if shape is RectangleShape2D:
			half_height = shape.size.y / 2
		offset = Vector2(0, -(half_height + 40))  # 40 пикселей запаса сверху
		pickup.position = result.position + offset
	else:
		pickup.position = global_position + offset

	get_tree().current_scene.add_child(pickup)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(5)  # Наносим урон 10 единиц
