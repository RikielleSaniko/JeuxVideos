extends StaticBody2D
class_name Table


func get_free_chair() -> Chair:
	for child in get_children():
		if child is Chair and child.is_free():
			return child
	return null

func interact(player) -> void:
	if !player.following_customer:
		return
	
	var chair: Chair = get_free_chair()
	if !chair:
		return

	player.following_customer.assign_chair(chair)
	player.following_customer = null

#la table réagit seulement si player guide un client et qu'il reste une chaise vide
func can_interact(player) -> bool:
	return player.following_customer != null and get_free_chair() != null
