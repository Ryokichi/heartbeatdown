extends CanvasLayer

@onready var fade_manager: CanvasLayer = $"."
@onready var fade: ColorRect = $FadeRect
@onready var animator: AnimationPlayer = $FadeRect/FadeAnimator

# Fica guardando se tá no meio de uma transição, só pra evitar bug visual
var fading: bool = false

func fade_to_black() -> void:
	if fading: return
	fade_manager.visible = true
	fading = true
	animator.play("fade_to_black")
	await animator.animation_finished
	fading = false

func fade_from_black() -> void:
	if fading: return
	fade_manager.visible = true
	fading = true
	animator.play("fade_from_black")
	await animator.animation_finished
	fading = false
