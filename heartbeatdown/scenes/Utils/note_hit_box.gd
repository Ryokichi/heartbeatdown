extends Area2D

var notes_in: Array = []
@export var key: String

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
func _on_body_entered(body):
	self.notes_in.append(body)
	pass
	
func _on_body_exited(body):
	self.notes_in.erase(body)
	print ("MISS")
	pass

func _process(delta):
	if (Input.is_action_just_pressed(key)):
		if (notes_in.size() > 0 ):
			var note = self.notes_in[0]
			print("Hit em ", key)
			self.notes_in.erase(note)
	else:
		print("Errou!!!")
	pass
