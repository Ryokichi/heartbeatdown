extends Node

@onready var bg = $bg
@onready var logo = $logo
@onready var lgodot = $lgodot
@onready var animator_bg = $AnimatorBg
@onready var animator_logo = $AnimatorLogo
@onready var animator_lgodot = $AnimatorLgodot
@onready var root: Node = $"."

const MENU = preload("res://Scenes/scenes/Menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bg.visible = false
	logo.visible = false
	lgodot.visible = false
	
	_transition_bg()


func _transition_bg():
	bg.visible = true
	await FadeManager.fade_from_black()
	_transition_lgodot()


func _transition_lgodot():
	lgodot.visible = true
	animator_lgodot.play("fade_in")
	await get_tree().create_timer(1.5).timeout
	
	animator_lgodot.play("fade_out")
	await get_tree().create_timer(1.5).timeout
	lgodot.visible = false
	_transition_logo()


func _transition_logo():
	logo.visible = true
	animator_logo.play("fade_in")
	await get_tree().create_timer(1.5).timeout
	
	animator_logo.play("fade_out")
	await get_tree().create_timer(1.5).timeout
	
	_change_scene(MENU)


func _change_scene(scene):#, actual_scene):
	await FadeManager.fade_to_black()
	get_tree().change_scene_to_packed(scene)
	


func _input(event):
	# Check for a keyboard key press
	if event is InputEventKey:
		if event.is_pressed():
			_change_scene(MENU)

	# Check for a mouse button press
	elif event is InputEventMouseButton:
		if event.is_pressed():
			_change_scene(MENU)
