extends Area2D

signal hit_success(noteData)
signal hit_miss

@export var assignedKey: String
var notesIn: Array = []
var originalColor: Color


func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	originalColor = $Sprite.self_modulate

func _on_body_entered(body):
	self.notesIn.append(body)
	pass
	
func _on_body_exited(body):
	self.notesIn.erase(body)
	body.get_parent().miss()
	hit_miss.emit()
	pass
	
func set_key(keyValue):
	self.assignedKey = keyValue

func set_original_color(color: Color):
	self.originalColor = color
	$Sprite.self_modulate = color
	$Sprite.self_modulate.a = 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(self.assignedKey):
		key_pressed()
	elif event.is_action_released(self.assignedKey):
		key_released()
	pass
	

func key_pressed():
	$Sprite.self_modulate = originalColor + Color(0.3, 0.3, 0.3, 0)	
	$Sprite.scale = Vector2(0.55, 0.55)

	if (notesIn.size() > 0 ):
		var note = self.notesIn.pop_front().get_parent()
		note.hit()
		var noteData = {
			"noteType": "default",  # Simplificado por enquanto
			"position": note.position,
			"hitBoxId": assignedKey,
			"accuracy": calculate_accuracy(note),
			"timestamp": Time.get_time_dict_from_system()
		}

		hit_success.emit(noteData)  # Emitir sinal com dados
	else:
		hit_miss.emit()  # Emitir sinal de erro
	pass

func calculate_accuracy(note):
	# Calcular precisão baseada na posição da nota
	var distance = abs(note.position.y - position.y)
	if distance < 10:
		return "perfect"
	elif distance < 20:
		return "good"
	elif distance < 30:
		return "ok"
	else:
		return "miss"

func key_released():
	# Voltar para a cor original
	$Sprite.self_modulate = originalColor
	$Sprite.scale = Vector2(0.5, 0.5)
	pass

func _process(_delta):
	pass
