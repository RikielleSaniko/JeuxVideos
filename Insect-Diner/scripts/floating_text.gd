extends Label
class_name FloatingText

const RISE_DISTANCE : float = 60.0
const DURATION : float = 1.0

func _ready() -> void:
	var tween : Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y - RISE_DISTANCE, DURATION)
	tween.tween_property(self, "modulate:a", 0.0, DURATION)
	tween.chain().tween_callback(queue_free)