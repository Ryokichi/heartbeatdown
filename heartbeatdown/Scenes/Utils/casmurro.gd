extends Sprite2D

@export var idl: int

var idleTexture: Texture2D
var upTexture: Texture2D
var downTexture: Texture2D
var leftTexture: Texture2D
var rightTexture: Texture2D
var missTexture: Texture2D


func _ready() -> void:
	$AnimationPlayer.play('idle')
	idleTexture = preload("res://assets/image/Casmurro/idle.png")
	upTexture = preload("res://assets/image/Casmurro/up.png")
	downTexture = preload("res://assets/image/Casmurro/down.png")
	leftTexture = preload("res://assets/image/Casmurro/left.png")
	rightTexture = preload("res://assets/image/Casmurro/right.png")
	missTexture = preload("res://assets/image/Casmurro/miss.png")
	
	self.texture = idleTexture
	pass
	
func play_hit(id):
	if (id == "hit_box_2"):
		self.texture = leftTexture
	elif (id == "hit_box_3"):
		self.texture = upTexture
	elif (id == "hit_box_4"):
		self.texture = downTexture
	elif (id == "hit_box_5"):
		self.texture = rightTexture

	await get_tree().create_timer(2).timeout
	self.texture = idleTexture

func play_miss():
	self.texture = missTexture
	await get_tree().create_timer(2).timeout
	self.texture = idleTexture
