extends Node

@onready var buttons: ItemList = $BG/Buttons
@onready var option_panel: Panel = $BG/OptionPanel
@onready var tutorial_panel: Panel = $BG/TutorialPanel
@onready var cred_panel: Panel = $BG/CredPanel
@onready var but_voltar: Button = $BG/ButVoltar
@onready var logo_2: Sprite2D = $BG/Logo2
@onready var logo_1: Sprite2D = $BG/Logo1
@onready var confirm_panel: Panel = $BG/ConfirmPanel
@onready var sfx: AudioStreamPlayer = $SFX
@onready var but_sobre: Button = $BG/ButSobre
@onready var sobre_panel: Panel = $BG/SobrePanel

@onready var next_scene = preload("res://Scenes/scenes/scene.tscn")
#@onready var fade_rect: ColorRect = $FadeRect
#@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await FadeManager.fade_from_black()
	FadeManager.queue_free()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_but_jogar_pressed() -> void:
	sfx.play()
	
	#"res://Scenes/scenes/scene.tscn"
	get_tree().change_scene_to_packed(next_scene)


func _on_but_opcoes_pressed() -> void:
	buttons.visible = false
	logo_1.visible = false
	but_sobre.visible = false
	
	option_panel.visible = true
	but_voltar.visible = true
	logo_2.visible = true
	
	sfx.play()


func _on_but_instru_pressed() -> void:
	buttons.visible = false
	logo_1.visible = false
	but_sobre.visible = false
	
	tutorial_panel.visible = true
	but_voltar.visible = true
	logo_2.visible = true
	
	sfx.play()


func _on_but_cred_pressed() -> void:
	buttons.visible = false
	logo_1.visible = false
	but_sobre.visible = false
	
	cred_panel.visible = true
	but_voltar.visible = true
	logo_2.visible = true
	
	sfx.play()


func _on_but_sair_pressed() -> void:
	get_tree().quit()


func _on_but_voltar_pressed() -> void:
	option_panel.visible = false
	tutorial_panel.visible = false
	cred_panel.visible = false
	but_voltar.visible = false
	logo_2.visible = false
	confirm_panel.visible = false
	sobre_panel.visible = false
	
	but_sobre.visible = true
	buttons.visible = true
	logo_1.visible = true
	
	sfx.play()


func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		TranslationServer.set_locale("pt_BR")
		
	if index == 1:
		TranslationServer.set_locale("en_US")


func _on_but_confirm_pressed() -> void:
	confirm_panel.visible = true


func _on_but_sobre_pressed() -> void:
	buttons.visible = false
	logo_1.visible = false
	but_sobre.visible = false
	
	sobre_panel.visible = true
	but_voltar.visible = true
	logo_2.visible = true
	
	sfx.play()
