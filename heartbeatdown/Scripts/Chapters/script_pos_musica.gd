extends Node

@export var novel_script: Array[String] = []

func _ready():
	GameUtils.setMusicIndex(1)
	var lang = TranslationServer.get_locale()
	if lang == "pt_BR":
		novel_script = [
		"/bgimg bgjardim",
		"/music decisao",
		"/chimg surpresa",
		"/talk Capitu",
		"Danças com muito afinco, meu amor... Vejo que está sério quanto a me abandonar!",
		"Meu amor não lhe significa nada?!",
		"/chimg surpresa",
		"/talk D. Casmurro",
		"Já te disse que, se isso é amor, portanto que me odeie! Estarei melhor assim!",
		"Farei que entendas que suas mentiras não mais corrompem meu coração!",
		"/chimg aflita",
		"/talk Capitu",
		"M-Mas eu sempre te amei! Escobar sempre foi nosso a-amigo, sabes disso!!",
		"/chimg aflita",
		"/talk D. Casmurro",
		"Poupe-me de suas falácias!! Teus olhos mentem contra tua boca.",
		"Meu amor não mais te pertence! Espero que finalmente tenhas entendido isso!",
		"/talk Capitu",
		"P-Pois então lhe mostrarei que você não passa de um tolo inseguro!",
		"/chimg furiosa",
		"/talk D. Casmurro",
		"Colocarei toda minha alma nesta última dança... E livrar-me-ei de suas amarras!",
		]
	elif lang == "en_US":
		novel_script = [
		"/think",
		"if shovel it worked"
		]
