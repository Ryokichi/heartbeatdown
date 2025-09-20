extends Node2D
@onready var nota = preload("res://scenes/Utils/MusicNote.tscn")

var audio = null
var audio_player = AudioStreamPlayer.new()
var chart_data = [];
var curr_note = null
var music_is_over = false
var notes_sequence = null
var time_elapsed = 0
var time_to_wait = 0


func spawn_note(index):
	var _nota = nota.instantiate()
	var qtd_notas = 6
	var pos = index % qtd_notas
	#if (index % 8 < 6):
	_nota.position = Vector2(-180+(pos*70), -648) # posição inicial (x=200, y=0)
	$Trilha.add_child(_nota)

func getNextNote():
	if(len(self.notes_sequence) <= 0):
		return {}
	return self.notes_sequence.pop_front()

func _ready():
	chart_data = Utils.load_json_to_dict("res://assets/music_charts/music_02.json")
	audio = preload("res://assets/audio/music_02.ogg")
	self.audio_player.stream = audio
	add_child(self.audio_player)
	
	self.notes_sequence = chart_data["notes"]["0"]
	self.curr_note = getNextNote()
	
	#time to wait deve ser o tempo a primeira nota demora par tocar
	# mais a (altura da tela / velocidade da nota)
	self.time_to_wait = curr_note['elapsed']+3.2
	print("Ready")
	pass

func _process(delta: float) -> void:
	if (self.music_is_over):
		return
	
	if (self.notes_sequence.is_empty()):
		self.music_is_over = true

	time_elapsed += delta
	if (time_elapsed >= self.time_to_wait):
		self.audio_player.play()
		self.time_to_wait = INF

	if time_elapsed >= self.curr_note['elapsed']:
		if (self.curr_note["velocity"] > 0 ):
			#print(self.curr_note)
			spawn_note(int(curr_note["note"]))
		self.curr_note = getNextNote()
	pass
