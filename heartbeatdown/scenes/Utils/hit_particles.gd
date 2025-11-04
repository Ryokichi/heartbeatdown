extends GPUParticles2D


func initiate(pos, color):
	self.emitting = true
	self.position = Vector2(pos)
	var material = process_material as ParticleProcessMaterial
	material.color = Color(color)
