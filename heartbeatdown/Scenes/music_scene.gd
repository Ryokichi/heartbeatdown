extends Node2D

@onready var nota = preload("res://Scenes/Utils/MusicNote.tscn")
@onready var hitParticles = preload("res://Scenes/Utils/hitParticles.tscn")
@onready var hitText = preload("res://Scenes/Utils/HitText.tscn")
@export var follow_scene: PackedScene = null

var audio = null
var chartData = []
var missSFX = {}
var currNote = null
var gameSpeed = 1
var musicIsOver = false
var notesSequence = null
var timeElapsed = 0
var timeToWait = 0
var playerNotes = 0
var bossNotes = 0
var points = 0
var totalNotes = 0
var playerLife = 100

var paused = false
var pause_menu: Control

var noteColors = [
	Color('41CED4'),
	Color('DA4B39'),
	Color('A32FDF'),
	Color('24CF75'),
	Color('DC51AC'),
	Color('D9CF5A')
]

var inSequence = 0
func spawn_note(index):
	var _nota = nota.instantiate()
	var qtd_notas = 6
	var pos = index % qtd_notas
	#pos = self.inSequence % 6 
	#self.inSequence += 1
	_nota.position = Vector2(-174+(pos*70), -648)
	_nota.self_modulate = self.noteColors[pos]
	$Trilha.add_child(_nota)

func getNextNote():
	if(len(self.notesSequence) <= 0):
		return {}
	return self.notesSequence.pop_front()

func change_speed(val: float) -> void: 
	self.gameSpeed = clamp(self.gameSpeed + val, 0, 2)
	$audioPlayer.pitch_scale = self.gameSpeed
	Engine.time_scale = self.gameSpeed
	pass

func set_timeToWait(time):
	#time to wait deve ser o tempo que a primeira nota demora par tocar
	# mais a (altura da tela / velocidade da nota)
	self.timeToWait = time

func _input(event):
	if event.is_action_pressed("ui_cancel"):  # ESC
		print("Pause chamado")
		toggle_pause()

func toggle_pause():
	paused = !paused    
	if paused:
		pause_game()
	else:
		resume_game()
		
func pause_game():
	get_tree().paused = true  # Pausa todo o jogo
	if pause_menu:
		pause_menu.visible = true
	# Pausar áudio
	$audioPlayer.stream_paused = true

func resume_game():
	get_tree().paused = false  # Despausa
	if pause_menu:
		pause_menu.visible = false
	# Despausar áudio
	$audioPlayer.stream_paused = false

func onHit(noteData):
	self.points += 1
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
	show_hit_effect(noteData.accuracy, noteData.position, noteData.color)
	pass

func show_hit_effect(accuracy_type, pos, color):
	# Implementar efeitos visuais baseado na precisão
	var _particles = hitParticles.instantiate()
	_particles.initiate(pos, color)
	self.add_child(_particles)
	self.show_hit_text(accuracy_type, false)
	pass

func onMiss(hitBoxId):
	$Casmurro.play_miss()
	$Capitu.play_hit(hitBoxId)
	self.playerLife -= 3
	self.playerLife = clamp(self.playerLife, 0, 100)
	$PlayerLife.value = self.playerLife
	self.show_hit_text("miss", true)
	self.playSFX(hitBoxId)
	pass

func playSFX(hitBoxId):
	var sfx = AudioStreamPlayer.new()
	sfx.volume_db = -20
	sfx.stream = self.missSFX[hitBoxId]
	add_child(sfx)
	sfx.play()
	sfx.finished.connect(sfx.queue_free)
	pass

func show_hit_text(accuracy_type, miss):
	var _hitText = hitText.instantiate()
	var text = ''
	var hitColor = Color(1,1)
	match accuracy_type:
		"perfect":
			text = "Perfeito!"
			pass
		"good":
			text = "Bom"
			pass
		"ok":
			text = "Regular"
			pass
		"miss":
			text = "Ruim"
	pass
	_hitText.global_position = Vector2(1080, get_viewport_rect().size.y / 2)
	_hitText.setValues(text, hitColor, miss)
	self.add_child(_hitText)

func nextScene():
	get_tree().change_scene_to_file(GameUtils.getNextScene())
	pass

func _process(delta: float) -> void:
	#if (self.timeElapsed > 2):
		#self.musicIsOver = true
	#$Info.text = """Vel: %.1f | Tempo: %.2f
	#Notas %d / %d""" % [
		#self.gameSpeed, 
		#self.timeElapsed, 
		#self.points, 
		#self.playerNotes
	#]

	if Input.is_action_just_pressed("speed_down"):
		change_speed(-0.1)
	elif Input.is_action_just_pressed("speed_up"):
		change_speed(0.1)
	pass
	
	if (self.notesSequence.is_empty()):
		self.musicIsOver = true

	if (self.musicIsOver):
		await get_tree().create_timer(10).timeout
		self.nextScene()
		return

	self.timeElapsed += delta
	if (timeElapsed >= self.timeToWait):
		$audioPlayer.play()
		self.timeToWait = INF

	while self.timeElapsed >= self.currNote['elapsed']:
		if (self.currNote["velocity"] > 0 ):
			spawn_note(int(self.currNote["note"]))
		self.currNote = getNextNote()
		if not self.currNote.has('elapsed'):
			break
	pass

func _ready():
	self.chartData = GameUtils.getChartData()
	self.notesSequence = chartData["notes"]["0"]
	self.playerNotes = GameUtils.countNotes(chartData["notes"]["0"])
	self.currNote = getNextNote()
	self.missSFX = {
		'hit_box_1': load("res://assets/sfx/Miss1.mp3"),
		'hit_box_2': load("res://assets/sfx/Miss2.mp3"),
		'hit_box_3': load("res://assets/sfx/Miss3.mp3"),
		'hit_box_4': load("res://assets/sfx/Miss4.mp3"),
		'hit_box_5': load("res://assets/sfx/Miss5.mp3"),
		'hit_box_6': load("res://assets/sfx/Miss6.mp3")
	}
	
	$audioPlayer.stream = load(GameUtils.getAudioName())
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
	
	set_timeToWait(self.currNote['elapsed']+3.2)
	pass
