extends GPUParticles2D


func initiate(pos, color):
	self.emitting = true
	self.position = Vector2(pos)

	material = process_material.duplicate() as ParticleProcessMaterial
	material.color = Color(color)
	self.process_material = material
