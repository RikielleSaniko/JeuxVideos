extends Node2D
class_name PathGrid

const CELL_SIZE := 32
const FLOOR_RECT : Rect2 = Rect2(150,300,1180,530)
const DIRECTIONS : Array = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]

var column_count := 0
var row_count := 0
var cells : Array = []
var debug_path : Array = []

func _ready() -> void:
	await get_tree().physics_frame
	build_grid()
	debug_path = find_path(world_to_cell(Vector2(200, 500)), world_to_cell(Vector2(1250, 500)))
	queue_redraw()

#construit la carte. true pour case libre et false pour case bloquée
func build_grid() -> void:
	column_count = int(FLOOR_RECT.size.x / CELL_SIZE)
	row_count = int(FLOOR_RECT.size.y / CELL_SIZE)
	cells.clear()

	var space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var query : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()

	for row in row_count:
		var new_row : Array = []
		for column in column_count:
			query.position = cell_to_world(Vector2i(column, row))
			var results : Array = space_state.intersect_point(query)
			new_row.append(results.is_empty())
		cells.append(new_row)

#retourne le centre d'une case en pixel
func cell_to_world(cell : Vector2i) -> Vector2:
	return Vector2(FLOOR_RECT.position.x + cell.x * CELL_SIZE + CELL_SIZE / 2.0, FLOOR_RECT.position.y + cell.y * CELL_SIZE + CELL_SIZE / 2.0) 

#retourne la case qui contient une position en pixel
func world_to_cell(world_position: Vector2) -> Vector2i:
	var column : int = int((world_position.x - FLOOR_RECT.position.x) / CELL_SIZE)
	var row : int = int((world_position.y - FLOOR_RECT.position.y) / CELL_SIZE)
	return Vector2i(column, row)

func is_in_grid(cell : Vector2i) -> bool:
	return cell.x >= 0 and cell.x < column_count and cell.y >= 0 and cell.y < row_count

#savoir si la case est dans la grille et si elle est libre
func is_walkable(cell : Vector2i) -> bool:
	if !is_in_grid(cell):
		return false
	return cells[cell.y][cell.x]

#retourne les cases libres parmi les 4 voisines donc gauche, droite, bas, haut
func get_walkable_neighbors(cell : Vector2i) -> Array:
	var neighbors : Array = []
	for direction in DIRECTIONS:
		var neighbor : Vector2i = cell + direction
		if is_walkable(neighbor):
			neighbors.append(neighbor)
	return neighbors

func get_closest_walkable_cell(world_position : Vector2) -> Vector2i:
	var closest_cell : Vector2i = Vector2i(-1, -1)
	var smallest_distance : float = INF

	for row in row_count:
		for column in column_count:
			if !cells[row][column]:
				continue
			var cell : Vector2i = Vector2i(column, row)
			var distance : float = world_position.distance_to(cell_to_world(cell))
			if distance < smallest_distance:
				closest_cell = cell
				smallest_distance = distance
	return closest_cell

#fonctions A*
#estimation de distance entre deux cases
func heuristic(a : Vector2i, b : Vector2i) -> int:
	return abs(a.x - b.x) + abs(a.y - b.y)

func reconstruct_path(came_from : Dictionary, current : Vector2i) -> Array:
	var path : Array = [current]
	while came_from.has(current):
		current = came_from[current]
		path.push_front(current)
	return path

func find_path(start : Vector2i, goal: Vector2i) -> Array:
	if !is_walkable(start) or !is_walkable(goal):
		return []

	var open_set : Array = [start]
	var closed_set : Dictionary = {}
	var came_from : Dictionary = {}
	var g_score : Dictionary = { start: 0}
	var f_score : Dictionary = { start: heuristic(start, goal)}

	while !open_set.is_empty():
		#la case à explorer qui a le plus petit f
		var current : Vector2i = open_set[0]
		for cell in open_set:
			if f_score[cell] < f_score[current]:
				current = cell

		if current == goal:
			return reconstruct_path(came_from, current)
		
		open_set.erase(current)
		closed_set[current] = true

		for neighbor in get_walkable_neighbors(current):
			if closed_set.has(neighbor):
				continue
			
			var new_g : int = g_score[current] + 1

			if !g_score.has(neighbor) or new_g < g_score[neighbor]:
				came_from[neighbor] = current
				g_score[neighbor] = new_g
				f_score[neighbor] = new_g + heuristic(neighbor, goal)
				if not neighbor in open_set:
					open_set.append(neighbor)
	return []

	

func _draw() -> void:
	for row in row_count:
		for column in column_count:
			var corner : Vector2 = Vector2(FLOOR_RECT.position.x + column * CELL_SIZE, FLOOR_RECT.position.y + row * CELL_SIZE)
			var color : Color = Color(1, 0, 0, 0.3)
			if cells[row][column]:
				color = Color(0, 1, 0, 0.3)
			draw_rect(Rect2(corner, Vector2(CELL_SIZE - 2, CELL_SIZE - 2)), color)
	
	for cell in debug_path:
		draw_circle(cell_to_world(cell), 6, Color(0, 0, 1))
