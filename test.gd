extends Node2D

# Шаблоны комнат сгруппированы по типам
@export var single_exit_rooms: Array[PackedScene] = [
	preload("res://rooms/0001.tscn"),  # Только выход слева
	preload("res://rooms/0010.tscn"),  # Только выход справа
	preload("res://rooms/0100.tscn"),  # Только выход внизу
	preload("res://rooms/1000.tscn")   # Только выход вверху
]

@export var multi_exit_rooms: Array[PackedScene] = [
	preload("res://rooms/0101.tscn"),  # Выходы слева и справа
	preload("res://rooms/1111.tscn")   # Выходы во все стороны
]

var room_size = Vector2(53, 29)  # Размер комнаты в тайлах
var spawned_rooms = []
var rng = RandomNumberGenerator.new()
var room_limit = 10

func _ready():
	rng.randomize()
	generate_level()

func generate_level():
	# 1. Создаем стартовую комнату (однодверную)
	var start_room = load("res://rooms/start.tscn").instantiate()
	add_child(start_room)
	start_room.position = Vector2.ZERO
	
	var start_exits = get_room_exits(start_room)
	spawned_rooms.append({
		"room": start_room,
		"pos": Vector2.ZERO,
		"exits": start_exits,
		"is_core": true  # Стартовая комната - не крайняя
	})
	
	# 2. Генерируем дополнительные комнаты
	var generation_attempts = 0
	while generation_attempts < 1000 and spawned_rooms.size() < room_limit:  # Лимит попыток и комнат
		if try_spawn_new_room():
			generation_attempts = 0  # Сброс при успешном размещении
		else:
			generation_attempts += 1
	
	# 3. Заменяем оставшиеся выходы на крайние комнаты
	create_edge_rooms()
	if spawned_rooms.size() < room_limit:
		print("This one works!!!!!!!!!!")
		spawned_rooms = []
		for child in get_children(): child.free()
		generate_level()

func try_spawn_new_room() -> bool:
	# Находим все комнаты с доступными выходами
	var available_rooms = spawned_rooms.filter(func(r): return r.exits.size() > 0)
	if available_rooms.size() == 0: return false
	
	# Выбираем случайную комнату и выход
	var base_room = available_rooms[rng.randi_range(0, available_rooms.size()-1)]
	var exit_dir = base_room.exits[rng.randi_range(0, base_room.exits.size()-1)]
	var new_pos = base_room.pos + get_dir_offset(exit_dir) * room_size
	
	# Проверяем, не занята ли позиция
	if spawned_rooms.any(func(r): return r.pos == new_pos): return false
	
	# Определяем нужный вход для новой комнаты
	var required_entrance = get_opposite_dir(exit_dir)
	
	# 70% chance для многодверной комнаты, 30% для однодверной
	var use_multi_exit = rng.randf() < 0.7 and multi_exit_rooms.size() > 0
	
	var candidates = multi_exit_rooms if use_multi_exit else single_exit_rooms
	candidates = candidates.filter(func(rt): 
		var temp_room = rt.instantiate()
		var exits = get_room_exits(temp_room)
		temp_room.queue_free()
		return exits.has(required_entrance)
	)
	
	if candidates.size() == 0: return false
	
	# Создаем новую комнату
	var new_room = candidates[rng.randi_range(0, candidates.size()-1)].instantiate()
	add_child(new_room)
	new_room.position = new_pos * 16  # Умножаем на размер тайла
	
	# Обновляем данные
	var new_exits = get_room_exits(new_room).filter(func(d): return d != required_entrance)
	spawned_rooms.append({
		"room": new_room,
		"pos": new_pos,
		"exits": new_exits,
		"is_core": use_multi_exit
	})
	
	# Удаляем использованный выход
	base_room.exits.erase(exit_dir)
	return true

func create_edge_rooms():
	for room_data in spawned_rooms:
		# Для каждого оставшегося выхода в "основных" комнатах создаем крайнюю
		while room_data.exits.size() > 0 and room_data.is_core:
			var exit_dir = room_data.exits.pop_back()
			var edge_pos = room_data.pos + get_dir_offset(exit_dir) * room_size
			
			if spawned_rooms.any(func(r): return r.pos == edge_pos): continue
			
			var required_entrance = exit_dir # get_opposite_dir(exit_dir)
			var edge_room = get_matching_single_exit_room(required_entrance)
			
			if edge_room:
				var instance = edge_room.instantiate()
				add_child(instance)
				instance.position = edge_pos * 16
				spawned_rooms.append({
					"room": instance,
					"pos": edge_pos,
					"exits": [],
					"is_core": false
				})

func get_matching_single_exit_room(entrance_dir: String) -> PackedScene:
	# Возвращает однодверную комнату с выходом в нужном направлении
	for room in single_exit_rooms:
		var temp = room.instantiate()
		var exits = get_room_exits(temp)
		temp.queue_free()
		if exits.size() == 1 and exits[0] == get_opposite_dir(entrance_dir):
			return room
	return null

# Вспомогательные функции
func get_room_exits(room: Node2D) -> Array:
	var exits = []
	if room.has_node("UpExit"): exits.append("up")
	if room.has_node("RightExit"): exits.append("right")
	if room.has_node("DownExit"): exits.append("down")
	if room.has_node("LeftExit"): exits.append("left")
	return exits

func get_dir_offset(dir: String) -> Vector2:
	match dir:
		"up": return Vector2(0, -1)
		"right": return Vector2(1, 0)
		"down": return Vector2(0, 1)
		"left": return Vector2(-1, 0)
		_: return Vector2.ZERO

func get_opposite_dir(dir: String) -> String:
	match dir:
		"up": return "down"
		"right": return "left"
		"down": return "up"
		"left": return "right"
		_: return ""
