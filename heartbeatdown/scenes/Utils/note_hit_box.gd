extends Area2D

@export var assignedKey: String
var notesIn: Array = []
var originalColor: Color
var originalScale = Vector2(0.6, 0.6)

signal hit_success(noteData)
signal hit_miss

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	self.originalColor = $Coracao.self_modulate
	$Coracao/Outline.self_modulate.a = 0

func _on_body_entered(body):
	if (body.get_parent().get_exploding()):
		return
	self.notesIn.append(body)
	pass
	
func _on_body_exited(body):
	self.notesIn.erase(body)
	if (body.get_parent().get_exploding()):
		return
	body.get_parent().miss()
	hit_miss.emit()
	pass
	
func set_key(keyValue):
	self.assignedKey = keyValue

func set_original_color(color: Color):
	self.originalColor = color
	$Coracao.self_modulate = color
	$Coracao.self_modulate.a = 1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(self.assignedKey):
		key_pressed()
	elif event.is_action_released(self.assignedKey):
		key_released()
	pass
	

func key_pressed():
	$Coracao.self_modulate = self.originalColor + Color(0.3, 0.3, 0.3, 0)
	$Coracao.scale = self.originalScale * 1.05
	$Coracao/Outline.self_modulate.a = 1

	if (notesIn.size() > 0 ):
		var note = self.notesIn.pop_front().get_parent()
		note.hit()
		var noteData = {
			"noteType": "default",  # Simplificado por enquanto
			"position": self.global_position,
			"hitBoxId": assignedKey,
			"color": self.originalColor,
			"accuracy": calculate_accuracy(note),
			"timestamp": Time.get_time_dict_from_system(),
		}

		hit_success.emit(noteData)  # Emitir sinal com dados
	else:
		hit_miss.emit()  # Emitir sinal de erro
	pass

func key_released():
	# Voltar para a cor original
	$Coracao.self_modulate = self.originalColor
	$Coracao.scale = self.originalScale
	$Coracao/Outline.self_modulate.a = 0
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

func _process(_delta):
	pass
