extends Node2D
@onready var nota = preload("res://scenes/Utils/MusicNote.tscn")

var audio = null
var audioPlayer = AudioStreamPlayer.new()
var chartData = [];
var currNote = null
var musicIsOver = false
var notesSequence = null
var timeElapsed = 0
var timeToWait = 0
var playerNotes = 0
var bossNotes = 0
var points = 0
var totalNotes = 0
var playerLife = 100

var gameSpeed = 1

var noteColors = [
	Color8(140, 170, 220, 255),
	Color8(130, 190, 140, 255),
	Color8(190, 170, 80, 255),
	Color8(230, 150, 80, 255),
	Color8(235, 95, 105, 255),
	Color8(20, 100, 210, 255)
]

var inSequence = 0
func spawn_note(index):
	var _nota = nota.instantiate()
	var qtd_notas = 6
	var pos = index % qtd_notas
	pos = self.inSequence % 4 + 1
	self.inSequence += 1
	_nota.position = Vector2(-174+(pos*70), -648)
	_nota.self_modulate = self.noteColors[pos]
	$Trilha.add_child(_nota)

func getNextNote():
	if(len(self.notesSequence) <= 0):
		return {}
	return self.notesSequence.pop_front()

func change_speed(val: float) -> void: 
	self.gameSpeed = clamp(self.gameSpeed + val, 0, 2)
	self.audioPlayer.pitch_scale = self.gameSpeed
	Engine.time_scale = self.gameSpeed
	pass

func set_timeToWait(time):
	#time to wait deve ser o tempo que a primeira nota demora par tocar
	# mais a (altura da tela / velocidade da nota)
	self.timeToWait = time

func _ready():
	chartData = GameUtils.load_json_to_dict("res://assets/music_charts/music_02.json")
	audio = preload("res://assets/audio/musica_01.ogg")
	self.audioPlayer.stream = audio
	self.audioPlayer.volume_db = -15
	add_child(self.audioPlayer)
	
	self.notesSequence = chartData["notes"]["0"]
	self.playerNotes = GameUtils.countNotes(chartData["notes"]["0"])
	#self.bossNotes = GameUtils.countNotes(chartData,1)
	self.currNote = getNextNote()
	
	$PlayerLife.set_inveted_mode(true)
	$PlayerLife.set_label("D. Casmurro")
	$BossLife.set_label("Capitu")
	
	$Trilha/NoteHitBox1.set_key("hit_box_1")
	$Trilha/NoteHitBox2.set_key("hit_box_2")
	$Trilha/NoteHitBox3.set_key("hit_box_3")
	$Trilha/NoteHitBox4.set_key("hit_box_4")
	$Trilha/NoteHitBox5.set_key("hit_box_5")
	$Trilha/NoteHitBox6.set_key("hit_box_6")
	
	# Conectar sinais de hit
	$Trilha/NoteHitBox1.hit_success.connect(onHit)
	$Trilha/NoteHitBox2.hit_success.connect(onHit)
	$Trilha/NoteHitBox3.hit_success.connect(onHit)
	$Trilha/NoteHitBox4.hit_success.connect(onHit)
	$Trilha/NoteHitBox5.hit_success.connect(onHit)
	$Trilha/NoteHitBox6.hit_success.connect(onHit)
	
	# Conectar sinais de miss
	$Trilha/NoteHitBox1.hit_miss.connect(onMiss)
	$Trilha/NoteHitBox2.hit_miss.connect(onMiss)
	$Trilha/NoteHitBox3.hit_miss.connect(onMiss)
	$Trilha/NoteHitBox4.hit_miss.connect(onMiss)
	$Trilha/NoteHitBox5.hit_miss.connect(onMiss)
	$Trilha/NoteHitBox6.hit_miss.connect(onMiss)
	
	# Definir cores originais dos hit boxes
	$Trilha/NoteHitBox1.set_original_color(noteColors[0])
	$Trilha/NoteHitBox2.set_original_color(noteColors[1])
	$Trilha/NoteHitBox3.set_original_color(noteColors[2])
	$Trilha/NoteHitBox4.set_original_color(noteColors[3])
	$Trilha/NoteHitBox5.set_original_color(noteColors[4])
	$Trilha/NoteHitBox6.set_original_color(noteColors[5])
	
	set_timeToWait(self.currNote['elapsed']+3.2+(1.2))
	print("Ready")
	pass

func onHit(noteData):
	print(noteData)
	self.points += 1
	# Usar os dados recebidos
	#print("Hit! Accuracy: ", noteData.accuracy)
	# print("Hit Box: ", noteData.hitBoxId)
	# print("Note Position: ", noteData.position)
	
	# Dar pontos baseado na precisão
	match noteData.accuracy:
		"perfect":
			self.playerLife += 3
		"good":
			self.playerLife += 2
		"ok":
			self.playerLife += 1
		"miss":
			self.playerLife -= 1
	self.playerLife = clamp(self.playerLife, 0, 100)
	$PlayerLife.value = self.playerLife
	$Casmurro.play_hit(noteData.hitBoxId)
	
	# Adicionar efeitos visuais baseado na precisão
	show_hit_effect(noteData.accuracy)
	pass

func show_hit_effect(accuracy_type):
	# Implementar efeitos visuais baseado na precisão
	match accuracy_type:
		"perfect":
			# Efeito dourado
			pass
		"good":
			# Efeito verde
			pass
		"ok":
			# Efeito amarelo
			pass
	pass

func onMiss():
	self.playerLife -= 3
	self.playerLife = clamp(self.playerLife, 0, 100)
	$PlayerLife.value = self.playerLife
	$Casmurro.play_miss()
	# print("Le Miss:", self.playerLife);
	pass

func _process(delta: float) -> void:
	$Info.text = """Vel: %.1f | Tempo: %.2f
	Notas %d / %d""" % [
		self.gameSpeed, 
		self.timeElapsed, 
		self.points, 
		self.playerNotes
	]

	if (self.musicIsOver):
		return

	if Input.is_action_just_pressed("speed_down"):
		change_speed(-0.1)
	elif Input.is_action_just_pressed("speed_up"):
		change_speed(0.1)
	pass
	
	if (self.notesSequence.is_empty()):
		self.musicIsOver = true

	self.timeElapsed += delta
	if (timeElapsed >= self.timeToWait):
		self.audioPlayer.play()
		self.timeToWait = INF

	while self.timeElapsed >= self.currNote['elapsed']:
	#if timeElapsed >= self.currNote['elapsed']:
		if (self.currNote["velocity"] > 0 ):
			spawn_note(int(self.currNote["note"]))
		self.currNote = getNextNote()
	pass
