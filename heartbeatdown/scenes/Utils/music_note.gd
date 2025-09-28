extends Sprite2D

@export var speed: float = 720/2.5  # 288 pixels por segundo
@export var lifetime: float = 6.0 # segundos de vida
@export var scale_speed: float = 20
@export var fade_speed: float = 1.0

var spriteA = preload("res://assets/image/coracao_fechado.png")
var spriteB = preload("res://assets/image/coracao_aberto.png")
var exploding = false


func _ready() -> void:
	self.texture = spriteA
	pass

func hit():
	#Faz animacao de acerto
	self.speed = 0
	self.texture = spriteB
	self.lifetime = 0.3
	print("Acertou!")
	pass

func miss():
	#print ("MISS")
	#queue_free()
	pass

func _process(delta: float) -> void:
	if self.lifetime <= 0:
		queue_free()  # destrói o nó
	self.lifetime -= delta # diminui tempo de vida
	self.position.y += speed * delta
	
	if self.exploding:
		self.scale += Vector2.ONE * scale_speed * delta
		self.modulate.a -= self.fade_speed * delta
		self.modulate.a = clamp(modulate.a, 0.0, 1.0)
		pass
	
	
