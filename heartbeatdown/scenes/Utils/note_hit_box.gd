extends Area2D

var notes_in: Array = []
@export var assigned_key: String


func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	
func _on_body_entered(body):
	self.notes_in.append(body)
	pass
	
func _on_body_exited(body):
	self.notes_in.erase(body)
	body.get_parent().miss()
	pass
	
func set_key(key_value):
	self.assigned_key = key_value

func _input(event: InputEvent) -> void:
	pass

func _process(_delta):
	if (Input.is_action_just_pressed(self.assigned_key)):
		var bodies = get_overlapping_bodies();
		print (bodies) 
		print("hit ", self.assigned_key)
		if (notes_in.size() > 0 ):
			var note = self.notes_in[0]
			note.get_parent().hit()
			self.notes_in.erase(note)
		else:
			#print('implementar erro')
			pass
