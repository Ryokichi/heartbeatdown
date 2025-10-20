extends Sprite2D

@export var speed: float = 720/2.5  # 288 pixels por segundo
@export var lifetime: float = 6.0 # segundos de vida
@export var scale_speed: float = 0.4
@export var fade_speed: float = 1.5

var spriteA = preload("res://assets/image/UI/coracaoFechado.png")
var spriteB = preload("res://assets/image/UI/coracaoAberto.png")
var exploding = false

func _ready() -> void:
	self.texture = spriteA
	pass

func hit():
	#Faz animacao de acerto
	self.speed = 0
	self.texture = spriteB
	self.lifetime = 0.3
	self.exploding = true
	# print("Acertou!")
	pass

func miss():
	# print("MISS")

	# Criar tremor
	var original_position = position
	var tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(self, "position", original_position + Vector2(3, 0), 0.03)
	tween.tween_property(self, "position", original_position + Vector2(-3, 0), 0.03)
	tween.tween_callback(func(): position = original_position)
	pass

func _process(delta: float) -> void:
	if self.lifetime <= 0:
		queue_free()  # destrói o nó

	if self.exploding:
		self.scale += Vector2.ONE * scale_speed * delta
		self.modulate.a -= self.fade_speed * delta
		self.modulate.a = clamp(modulate.a, 0.0, 1.0)
		return

	self.lifetime -= delta # diminui tempo de vida
	self.position.y += speed * delta
	
