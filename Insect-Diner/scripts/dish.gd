extends Sprite2D
class_name Dish

@export var dish_name : String = ""

func interact(player) -> void:
	if player.carried_dish != "":
		return
	player.take_dish(dish_name, texture)

# prendre un plat seulement si player a les mains vides
func can_interact(player) -> bool:
	return player.carried_dish == ""