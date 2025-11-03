extends GPUParticles2D


func initiate(pos, color):
	
	print (pos, color)
	self.emitting = true
	self.position = Vector2(100,100)
	#self.material.color = Color(color)
