extends Node2D


@onready var speaker_label: Label = $CanvasLayer/Control/TextureRect/VBoxContainer/SpeakerLabel
@onready var speech_label: Label = $CanvasLayer/Control/TextureRect/VBoxContainer/SpeechLabel


@export_category("Chapter Settings")
@export var main_chapter_node: Node2D


var current_speech_characters: Array[String] = []


# use substr to get specific values from chapter script
func _ready() -> void:
	_speak("sans undertale", "the industrial revolution has been a")
	

func _speak(speaker: String, speech: String) -> void:
	speaker_label.text = speaker
	speaker_label.visible = true
	
	speech_label.visible_characters = 0
	for char in speech:
		current_speech_characters.append(char)
		
	_animate_text(speech)
	

func _animate_text(speech: String) -> void:
	speech_label.visible_characters += 1
	
	
	
