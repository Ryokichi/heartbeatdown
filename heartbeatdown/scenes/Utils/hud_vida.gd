extends TextureProgressBar


func set_sprite():
	pass
	
func set_inveted_mode(invert: bool):
	var scaleX = 1
	if invert:
		scaleX = -1
	self.scale.x = scaleX
	$TextLabel.scale.x = scaleX
	pass

func set_label(label: String):
	$TextLabel.text = label
	pass
