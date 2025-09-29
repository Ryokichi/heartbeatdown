class_name GameUtils

static func load_json_to_dict(file_path: String) -> Dictionary:
	print(file_path)
	var exist = FileAccess.file_exists(file_path)

	if not exist:
		print("Arquivo não existe!")
		return {}

	print("Arquivo encontrado.")
	var file = FileAccess.open(file_path, FileAccess.READ)
	print(file)
	var raw_text = file.get_as_text()
	var content = JSON.parse_string(raw_text)

	file.close()
	return content
	

static func sumTimes(chart_data):
	var tempo_total = {}
	var notes_channel = chart_data["notes"]
	for channel in notes_channel:
		var note_data = notes_channel[channel]
		for data in note_data:
			tempo_total[channel] = tempo_total.get(channel, 0) + data["time"]
	return tempo_total
	
static func countNotes(chart_data):
	var total_notes = 0
	for note in chart_data:
		if note["velocity"] > 0:
			total_notes += 1
		pass
	return total_notes
