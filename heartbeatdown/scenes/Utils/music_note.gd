extends Sprite2D

@export var speed: float = 720/2.5  # 288 pixels por segundo
@export var lifetime: float = 6.0 # segundos de vida

var time_alive: float = 0.0

func hit():
	#Faz animacao de acerto
	print("Acertou!")
	queue_free()
	pass

func miss():
	#print ("MISS")
	#queue_free()
	pass

func _process(delta: float) -> void:
	# movimenta no eixo Y
	position.y += speed * delta
	
	# soma tempo de vida
	time_alive += delta
	if time_alive >= lifetime:
		queue_free()  # destrói o nó
