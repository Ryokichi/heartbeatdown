extends Node2D

@export var tween_time: float


func setValues(text, color, play_miss = false):
	var label_settings = $Label.label_settings.duplicate()
	$Label.text = text
	if (play_miss):
		label_settings.font_color = Color8(200, 50, 50, 255)
		$Label.label_settings = label_settings
		play_miss()
		return
	play_hit()
	pass
	
func play_hit():
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2(1.5, 1.5), tween_time)
	tween.parallel().tween_property(self, "modulate:a", 0.7, tween_time)
	tween.parallel().tween_property(self, "global_position:y", global_position.y - 130, tween_time)
	tween.tween_callback(queue_free)
	pass

func play_miss():
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector2(1.5, 1.5), tween_time)
	tween.parallel().tween_property(self, "modulate:a", 0.7, tween_time)
	tween.parallel().tween_property(self, "global_position:y", global_position.y + 130, tween_time)
	tween.tween_callback(queue_free)
	pass

func _ready() -> void:
	pass
