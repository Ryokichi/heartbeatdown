extends Node2D

var chart_data = [];
var next_note_time = 0
var next_tempo_time = 0



@onready var nota = preload("res://scenes/Utils/notaMusical.tscn")

func spawn_note(index):
	var _nota = nota.instantiate()
	_nota.position = Vector2(100+(index*100), 100) # posição inicial (x=200, y=0)
	add_child(_nota)

func sumTimes(chart_data):
	var tempo_total = {}
	var notes_channel = chart_data["notes"]
	for channel in notes_channel:
		var note_data = notes_channel[channel]
		for data in note_data:
			tempo_total[channel] = tempo_total.get(channel, 0) + data["time"]
	return tempo_total

func _ready():
	chart_data = Utils.load_json_to_dict("res://assets/music_charts/music_01.json")
	print("Tempos -->", Utils.sumTimes(chart_data))
	
	print("Tipo ", typeof(chart_data["notes"]["0"]))
	
	pass

func _process(delta: float) -> void:
	for data in chart_data["notes"]["0"]:
		if (next_note_time <= 0):
			#print(data)
			next_note_time = data["time"]/60
		#print("Passado :", spended_time, " | Tempo acumulado:", total_time)
		#
		#next_trigger_time = chart_data[chart_line].tempo
		#for i in range(1, 7):
			#var key = "btn%d" % i
			#var value = chart_data[chart_line][key]
			#if (value == "TRUE"):
				#spawn_note(i)
				#pass
#
		#chart_line += 1
		#end_of_chart = (chart_line >= chart_size)
		#spended_time = 0
		#print('Linha: ', chart_line, ' - Fim: ', end_of_chart)
		#print("Next in: ", next_trigger_time)
		#pass
	next_note_time -= delta
	pass
