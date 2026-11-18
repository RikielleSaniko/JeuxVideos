extends CharacterBody2D

@export var max_speed: float = 300.0
@export var acceleration: float = 10.0
@onready var interaction_area : Area2D = $InteractionArea
var following_customer : Customer = null

var last_direction = Vector2.DOWN


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("action"):
		interact_with_closest()

#chercher l'objet le plus proche qui réagit a une interaction
func interact_with_closest() -> void:
	var candidates : Array = interaction_area.get_overlapping_bodies()
	for area in interaction_area.get_overlapping_areas():
		candidates.append(area.get_parent())

	var closest = null
	var closest_distance : float = INF

	for candidate in candidates:
		if !candidate.has_method("interact"):
			continue
		if candidate == following_customer:
			continue
		var distance := global_position.distance_to(candidate.global_position)
		if distance < closest_distance:
			closest = candidate
			closest_distance = distance

	if closest:
		closest.interact(self)


func _physics_process(delta):
	var direction = Input.get_vector("left", "right", "up", "down").normalized()

	if direction.length() > 0:
		velocity = velocity.lerp(direction * max_speed, acceleration * delta)
	else:
		velocity = velocity.lerp(Vector2.ZERO, acceleration * delta)

	# Pour pointer vers la souris
	# look_at(get_global_mouse_position())
	update_animation(direction)

	move_and_slide()

func update_animation(direction):
	if direction == Vector2.ZERO: 
		match last_direction:
			Vector2.RIGHT: $AnimatedSprite2D.play("idle_right")
			Vector2.LEFT: $AnimatedSprite2D.play("idle_left")
			Vector2.DOWN: $AnimatedSprite2D.play("idle_down")
			Vector2.UP: $AnimatedSprite2D.play("idle_up")
		return

	if abs(direction.x) > abs(direction.y):
		direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
	else:
		direction = Vector2.DOWN if direction.y > 0 else Vector2.UP

	last_direction = direction

	match direction:
		Vector2.RIGHT: $AnimatedSprite2D.play("walk_right")
		Vector2.LEFT: $AnimatedSprite2D.play("walk_left")
		Vector2.DOWN: $AnimatedSprite2D.play("walk_down")
		Vector2.UP: $AnimatedSprite2D.play("walk_up")
