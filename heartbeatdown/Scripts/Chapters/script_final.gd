extends Node

@export var novel_script: Array[String] = []

func _ready():
	var lang = TranslationServer.get_locale()
	if lang == "pt_BR":
		novel_script = [
		"/bgimg bgjardim",
		"/music intro",
		"/chimg brava",
		"/talk Capitu",
		"Entendo... Então estás decidido? Vais me abandonar? Possui certeza de tua atitude?",
		"/chimg brava",
		"/talk D. Casmurro",
		"Sim, Capitu. Assim será melhor, para mim, e para ti. Podes ser livre, assim como já estava sendo!",
		"Não porei mais minhas inseguranças, como dizias, sobre ti. Não tenho débitos contigo.",
		"/chimg sorrindo",
		"/talk Capitu",
		"Que seja, então! Meu amor incondicional será voltado para outro homem de sorte.",
		"Tu estás agindo como um louco, jogando uma pérola aos porcos!",
		"/chimg sorrindo",
		"/talk D. Casmurro",
		"Que os porcos se deleitem com essa pérola falsa! Não tenho mais nada a resolver contigo.",
		"/chimg aflita",
		"Adeus, Capitu.",
		"/chimg animate leave aflita",
		"/talk Capitu",
		"... Adeus...",
		"/bgimg bgconsultorio",
		"/music ambConsultorio",
		"/think",
		"Quando você percebe, já está de volta à sala do psicólogo. Ele olha contente para você.",
		"/talk Doutor",
		"Ótimo, muito bom! Ouvi toda sua conversa com essa... “Capitu” ... É de fato o nome real dela? Enfim, de todo modo, vejo que conseguiu se resolver com ela!",
		"Gostaria muito de continuar seu tratamento, porém vamos ter que estendê-lo para uma próxima consulta.",
		"/think",
		"Ele se levanta, com um passo levemente acelerado, e abre cordialmente a porta, estendendo uma das mãos em direção à sala de espera. E então, você passa pela porta",
		"O que te resta dessa consulta são poucos flashs de memória, onde você estava estranhamente dançando com uma pessoa que, te lembrava sua ex-parceira do seu primeiro relacionamento, mas não era ela.",
		"Agora – mesmo que a pessoa com quem conversou na hipnose fosse diferente – quando você lembra de toda sua história ruim juntos, não sente mais um peso sobre suas costas.",
		"Os métodos desse doutor são questionáveis, mas definitivamente funcionam!",
		"FIM - AGRADECEMOS POR JOGAR NOSSO JOGO!!!"
	]
	elif lang == "en_US":
		novel_script = [
		"/think",
		"if shovel it worked"
		]
