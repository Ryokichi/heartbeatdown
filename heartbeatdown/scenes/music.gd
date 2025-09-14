extends Node2D
@onready var nota = preload("res://scenes/Utils/notaMusical.tscn")

var player = AudioStreamPlayer.new()
var chart_data = [];
var next_note_time = 0
var next_tempo_time = 0
var ticks = 0
var tpb = 0 #ticks_per_beat
var time_elapsed = 0
var audio = null
var notes_sequence = null


func spawn_note(index):
	var _nota = nota.instantiate()
	_nota.position = Vector2(100+(index*100), 100) # posição inicial (x=200, y=0)
	add_child(_nota)
	

func _ready():
	chart_data = Utils.load_json_to_dict("res://assets/music_charts/music_01.json")
	audio = preload("res://assets/audio/tori_no_uta.ogg")
	player.stream = audio
	add_child(player)
	
	player.play()
	

	self.notes_sequence = chart_data["notes"]["0"]
	pass

func getNextNote():
	return self.notes_sequence.pop_front()
	pass
	
	
func _process(delta: float) -> void:
	time_elapsed += delta
	
	if time_elapsed >= next_note_time:
		var note = getNextNote()
		next_note_time = note["total_time"]/100
		print(note)
		if (note["time"] > 0):
			spawn_note(int(note["note"]) % 6)
	
	pass
