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
var player_notes = 0
var boss_notes = 0
var points = 0

var game_speed = 1

var note_colors = [
	Color8(140, 170, 220, 255),
	Color8(130, 190, 140, 255),
	Color8(190, 170, 80, 255),
	Color8(230, 150, 80, 255),
	Color8(235, 95, 105, 255),
	Color8(20, 100, 210, 255)
]

var migue = 0
func spawn_note(index):
	var _nota = nota.instantiate()
	var qtd_notas = 6
	var pos = index % qtd_notas
	pos = self.migue % 4 + 1
	self.migue += 1
	_nota.position = Vector2(-174+(pos*70), -648)
	_nota.self_modulate = self.note_colors[pos]
	$Trilha.add_child(_nota)

func getNextNote():
	if(len(self.notes_sequence) <= 0):
		return {}
	return self.notes_sequence.pop_front()

func change_speed(val: float) -> void: 
	self.game_speed = clamp(self.game_speed + val, 0, 2)
	self.audio_player.pitch_scale = self.game_speed
	Engine.time_scale = self.game_speed
	pass

func _ready():
	chart_data = GameUtils.load_json_to_dict("res://assets/music_charts/music_02.json")
	audio = preload("res://assets/audio/music_02.ogg")
	self.audio_player.stream = audio
	self.audio_player.volume_db = -15
	add_child(self.audio_player)
	
	self.notes_sequence = chart_data["notes"]["0"]
	self.player_notes = GameUtils.countNotes(chart_data["notes"]["0"])
	#self.boss_notes = GameUtils.countNotes(chart_data,1)
	self.curr_note = getNextNote()
	
	$Trilha/NoteHitBox1.set_key("hit_box_1")
	$Trilha/NoteHitBox2.set_key("hit_box_2")
	$Trilha/NoteHitBox3.set_key("hit_box_3")
	$Trilha/NoteHitBox4.set_key("hit_box_4")
	$Trilha/NoteHitBox5.set_key("hit_box_5")
	$Trilha/NoteHitBox6.set_key("hit_box_6")
	
	$Trilha/NoteHitBox1/Sprite.self_modulate = note_colors[0]
	$Trilha/NoteHitBox2/Sprite.self_modulate = note_colors[1]
	$Trilha/NoteHitBox3/Sprite.self_modulate = note_colors[2]
	$Trilha/NoteHitBox4/Sprite.self_modulate = note_colors[3]
	$Trilha/NoteHitBox5/Sprite.self_modulate = note_colors[4]
	$Trilha/NoteHitBox6/Sprite.self_modulate = note_colors[5]
	
	#time to wait deve ser o tempo a primeira nota demora par tocar
	# mais a (altura da tela / velocidade da nota)
	self.time_to_wait = curr_note['elapsed']+3.2+(1.2)
	print("Ready")
	pass

func _process(delta: float) -> void:
	$Info.text = "Vel: %.1f | Tempo: %.2f\n" % [self.game_speed, self.time_elapsed]

	if (self.music_is_over):
		return

	if Input.is_action_just_pressed("speed_down"):
		change_speed(-0.1)
	elif Input.is_action_just_pressed("speed_up"):
		change_speed(0.1)
	pass
	
	if (self.notes_sequence.is_empty()):
		self.music_is_over = true

	self.time_elapsed += delta
	if (time_elapsed >= self.time_to_wait):
		self.audio_player.play()
		self.time_to_wait = INF

	while self.time_elapsed >= self.curr_note['elapsed']:
	#if time_elapsed >= self.curr_note['elapsed']:
		if (self.curr_note["velocity"] > 0 ):
			spawn_note(int(self.curr_note["note"]))
		self.curr_note = getNextNote()
	pass
