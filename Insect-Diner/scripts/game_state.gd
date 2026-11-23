extends Node

const LEVELS = [
	{
		"duration": 120,
		"goal": 60,
		"spawn_time": 12,
		"patience": 25,
		"customers": ["ant"]
	},

	{
		"duration": 150,
		"goal": 120,
		"spawn_time": 9,
		"patience": 20,
		"customers": ["ant"]
	},

	{
		"duration": 180,
		"goal": 200,
		"spawn_time": 7,
		"patience": 15,
		"customers": ["ant"]
	}
		
]

var current_level : int = 0
var last_won : bool = 0
var last_money : int = 0

func get_level() -> Dictionary :
	return LEVELS[current_level]

func is_last_level() -> bool:
	return current_level == LEVELS.size() - 1