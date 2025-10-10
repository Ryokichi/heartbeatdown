extends Area2D

signal hit_success(note_data)
signal hit_miss

var notes_in: Array = []
@export var assigned_key: String
var original_color: Color


func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
	# Salvar a cor original (será definida pelo music_scene.gd)
	original_color = $Sprite.self_modulate

	
func _on_body_entered(body):
	self.notes_in.append(body)
	pass
	
func _on_body_exited(body):
	self.notes_in.erase(body)
	body.get_parent().miss()
	pass
	
func set_key(key_value):
	self.assigned_key = key_value

func set_original_color(color: Color):
	self.original_color = color
	$Sprite.self_modulate = color
	$Sprite.self_modulate.a = 0.7

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(self.assigned_key):
		key_pressed()
	elif event.is_action_released(self.assigned_key):
		key_released()
	pass
	

func key_pressed():
	$Sprite.self_modulate.a = 0.95
	$Sprite.self_modulate = Color.WHITE  # Fica branco/brilhante
	$Sprite.scale = Vector2(0.55, 0.55)
	var bodies = get_overlapping_bodies();
	
	if (notes_in.size() > 0 ):
		var note = self.notes_in[0]
		note.get_parent().hit()
		
		# Preparar dados da nota para enviar
		var note_data = {
			"note_type": note.note_type if note.has_method("get_note_type") else "default",
			"position": note.position,
			"hit_box_id": assigned_key,
			"accuracy": calculate_accuracy(note),  # Função para calcular precisão
			"timestamp": Time.get_time_dict_from_system()
		}
		
		self.notes_in.erase(note)
		hit_success.emit(note_data)  # Emitir sinal com dados
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
	$Sprite.self_modulate = original_color
	$Sprite.scale = Vector2(0.5, 0.5)	
	pass

func _process(_delta):
	pass
