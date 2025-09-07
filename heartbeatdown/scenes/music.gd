extends Node2D


func _ready():
	var file_path = "res://assets/music_charts/music_01.json"
	var json_data = load_json_file(file_path)

	if json_data is Dictionary:
		print("Carreguédi dicionario") # Aqui você pode usar os dados como quiser
	elif json_data is Array:
		print("Carregou errado como array")
	else:
		print('Carregou errado!')
	pass

func load_json_file(file_path: String) -> Dictionary: 
	print(file_path)
	var file = FileAccess.open(file_path, FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())

	file.close()
	return content
#
	#if file.open(path, File.READ) != OK:
		#print("Não foi possível abrir o arquivo.")
		#return null
	#
	## Lê todo o conteúdo do arquivo
	#var file_content = file.get_as_text()
	#
	#file.close()  # Fechar o arquivo após a leitura
	#
	## Usando JSON para analisar o conteúdo
	#var json = JSON.parse(file_content)
	#
	#if json.error != OK:
		#print("Erro ao analisar JSON: %s" % json.error_string)
		#return null
	#
	#return json.result  # Retorna o dicionário com os dados JSON
