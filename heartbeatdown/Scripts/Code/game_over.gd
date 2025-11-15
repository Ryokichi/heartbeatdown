extends Node2D

var menuScene = preload("res://Scenes/scenes/Abertura.tscn")
var gameScene = preload("res://Scenes/MusicScene.tscn")

func _ready():
	self.start()
	pass

func start():
	var tween = create_tween()
	tween.tween_property($GameOverText, "modulate:a", 1.0, 1.0)
	pass

func return_to_menu():
	get_tree().change_scene_to_packed(menuScene)
	pass
	
func retry():
	get_tree().change_scene_to_packed(gameScene)
	pass
