extends Node

#TODO:
# - Create background image Dict -- CHECK
# - Change background image through text command -- CHECK
# - Change music through text command -- CHECK
# - Finish the /music command -- CHECK
# - Make the current node pass on read_music_dictionary_from_file, background image dict, and any other important information to the next node setup.
# - Make buttons show up for end decisions -- CHECK
# - Make the pause button (working like the menu)

@export_category("Setup")
## The Label node where the visual novel text will be displayed.
@export var text_label: RichTextLabel = null
## The Label node where the character's name will be displayed.
@export var name_label: RichTextLabel = null
## If true, reads the script from another script file in a node selected in the "node_script" variable.
@export var read_script_from_file: bool = false
## If read_script_from_file is true, the visual novel script will be read from that node's script. The script must be inside a variable of type Array[String] called "novel_script".
@export var node_script: Node = null
## Speed at which the text will be displayed at (letters per second). Subsequent nodes with this script will receive this value under the same variable name (text_scroll_speed).
@export var text_scroll_speed: float = 64.0
## Node of type TextureRect in which the background will be set.
@export var character_image: TextureRect = null
## If true, reads the "character_images" variable from another script file in a node selected in the "character_images_node" variable.
@export var read_character_images_from_file: bool = false
## Node which will keep the character images. 
@export var character_images: Dictionary = {}
## Animator with character scene enter, leave and switch animations.
@export var character_animator: AnimationPlayer = null
@export var character_sprites: AnimatedSprite2D = null
## Name used for the entering animation in character_animator.
@export var enter_animation_name: StringName = "enter"
## Name used for the leaving animation in character_animator.
@export var leave_animation_name: StringName = "leave"
## Name used for the switching animation in character_animator. Please connect a call method in your animation at the point which you want the character to change to the "_switch_animation_call()" function.
@export var switch_animation_name: StringName = "switch"
## If true, reads the music_dictionary variable from a different script in the node assigned at node_music_dictionary.
@export var read_music_dictionary_from_file: bool = false
## Node that will have the music read from and applied to music_dictionary.
@export var node_music_dictionary: Node = null
## Dictionary of music, to be able to name the audio files here and call them in the novel script through /music name.
@export var music_dictionary: Dictionary = {}
@export var actual_music: AudioStreamPlayer
## If true, reads the background_dictionary of the node assigned to node_background_dictionary.
@export var read_background_dictionary_from_file: bool = false
## Node from which background_dictionary will be read from to apply to this script's background_dictionary.
@export var node_background_dictionary: Node = null
## Dictionary of background images that will be read to change the background from.
@export var background_dictionary: Dictionary = {}
@export var background_image: TextureRect = null
@export var sfx_dictionary: Dictionary = {}
@export var actual_sfx: AudioStreamPlayer

#@export var background_node: Texture = null

@export_category("Novel")
## The script that will be read as visual novel text or as commands to control images and similar elements.
@export var novel_script: Array[String] = []
## Starts reading at this line. Mostly for loading in scenes.
@export var start_at_line: int = 0
## If true, show choice buttons at the end of the novel's script in this node.
@export var choice_at_end_of_script: bool = false
## If choice_at_end_of_script is false, automatically calls the _start() function of the selected node.
@export var next_node: Node
@export var container_but: VBoxContainer

@export_category("Script End Choices")
## These variables only matter if choice_at_end_of_script is true.
## Esse aqui abaixo é o dicionário dos botões de decisão
@export var decision_dictionary: Array[Array] = []
## Nodes which the buttons in the options variable will direct to. The _start() function will be called. The button in index N will call _start() from the node indexed N here.
@export var responses: Array[Node] = []
@export var follow_scene: PackedScene = null

@export_category("Debug")
## Starts the script as soon as this node is instanced, helps debugging process.
@export var start_at_runtime: bool = false
## Closes game when the quotes key is pressed, for quick debugging and testing.
@export var quit_with_quote: bool = false
## Skips the script supposed to be read, starting the next node instantly.
@export var skip_novel_script: bool = false

# Constant variable used to tell whether the next node will be a reader script.
const reader_script: bool = true
const CHOICE_BUTTON = preload("res://Scenes/prefabs/choice_button.tscn")


# Types of chat that can be used for the text box.
enum SPEECH_TYPE {TALK, THINK}
# Stores which type of chat is being used, whether thinking, or speaking, and any other possible chat.
var speech_type: SPEECH_TYPE = SPEECH_TYPE.TALK
# Stores the character currently speaking, changed through /speak [character name]
var speaking_character: StringName = ""
# Stores the current read line of the nove_script variable.
var current_line_index: int = 0
# Stores the current line being read by the reader.
var current_line: String = ""
# Stores whether the text is playing the display animation.
var text_animating: bool = false
# Particles around the displayed text, changes based on what speech type is used (think, speak) and must be globally accessible to 3 different functions in this script (_input(), _display_speech() and _animate_text()
var wrapper: Array[String] = []
# Stops the script from trying to keep going when it reaches the end of the read file.
var file_end_reached: bool = false
# Variable which will globally store what character image will be switched to in switch animation, so it can be switched to at any time through the animation by calling _switch_animation_call().
var next_character_image_switch_image: Texture2D = null
# Makes sure this is the node which should be reading the script at this time.
var active: bool = false


func _ready() -> void:
	character_sprites = $CanvasLayer/Control/Sprite/AnimatedSprite2D
	
	background_dictionary = {
		"bgconsultorio" = load("res://Img/VN/BG/BGpreto.png"),
		"bgteste" = load("res://Img/VN/BG/MENUbackground.png"),
		"bgjardim" = load("res://Img/VN/BG/CenárioCompleto.png")
	}
	
	background_image = $CanvasLayer/Control/BG
	
	character_images = {
		"aflita" = load("res://Img/VN/Sprites/VNCapitu1Aflita.png"),
		"brava" = load("res://Img/VN/Sprites/VNCapitu1Brava.png"),
		"furiosa" = load("res://Img/VN/Sprites/VNCapitu1Furiosa.png"),
		"sorrindo" = load("res://Img/VN/Sprites/VNCapitu1Sorrindo.png"),
		"surpresa" = load("res://Img/VN/Sprites/VNCapitu1Surpresa.png"),
	}
	
	character_image = $CanvasLayer/Control/Sprite
	
	music_dictionary = {
		"ambConsultorio" = load("res://Sound/AmbienteConsultorio.mp3"),
		"ambDança" = load("res://Sound/momentoDanca.mp3"),
		"ambClassic" = load("res://Sound/classico.mp3"),
		"decisao" = load("res://Sound/decisao.mp3"),
		"intro" = load("res://Sound/moon-dance-cinematic-background-music-for-video-stories-short-1-416092.mp3"),
	}
	
	actual_music = $CanvasLayer/MusicaBG
	
	sfx_dictionary = {
		"passos" = load("res://Sound/footsteps-male-362053.mp3"),
	}
	
	actual_sfx = $CanvasLayer/SFX
	
	if read_script_from_file:
		if not node_script == null:
			if "novel_script" in node_script:
				novel_script = node_script.novel_script
				
			else:
				push_error("ERRO: node_script não tem variável 'novel_script'.")
				
		else:
			push_error("ERRO: node_script é nulo mas read_script_from_file é verdadeiro.")
			
		
	print("novel_script carregado: ", novel_script, "\n")
	
	decision_dictionary
	container_but
	
	# Debug
	if start_at_runtime:
		_start()
		
	


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("next") and not file_end_reached and active:
		if text_animating:
			text_animating = false
			text_label.visible_characters = text_label.text.length() - 29
			
			text_label.text = wrapper[0] + '[fade start=' + str(text_label.visible_characters - 5) + ' length=5]' + current_line + '[/fade]' + wrapper[1]
			
			#print(text_label.visible_characters, "/", text_label.text.length()-29, " | ", text_label.text, "/", current_line)
			
		else:
			_read_line(true)
			
		
	
	if Input.is_action_just_pressed("DEBUG_quit") and quit_with_quote:
		print("Project quote debug quit.")
		get_tree().quit()
		
	


func _start() -> void:
	if name_label == null:
		push_error("ERRO: name_label é nulo. Selecione um nó tipo Label.")
		
	
	if text_label == null:
		push_error("ERRO: text_label é nulo. Selecione um nó tipo Label.")
		
	else:
		text_label.visible_characters = 0
		
	
	if character_image == null:
		push_error("ERRO: character_image é nulo. Selecione um nó tipo TextureRect.")
		
	
	if character_animator == null:
		push_error("ERRO: character_animator é nulo. Selecione um nó tipo AnimationPlayer.")
		
	
	if not skip_novel_script:
		active = true
		_read_line()
		
	else:
		_file_end_reached()
		
	


func _read_line(next_line: bool = false) -> void:
	if file_end_reached or not active:
		return
		
	
	if next_line:
		current_line_index += 1
		print(current_line_index, " (current_line_index + 1)")
		
	
	if current_line_index >= novel_script.size():
		file_end_reached = true
		if choice_at_end_of_script:
			_on_decision_selected()
		elif follow_scene:
			get_tree().change_scene_to_packed(follow_scene)
		else:
			_file_end_reached()
		
	else:
		if not file_end_reached:
			#print(current_line_index, ' | ', novel_script.size())
			current_line = novel_script[current_line_index]
			#print(current_line)
			if current_line.begins_with("/"):
				# if it's a command
				if current_line.substr(1, 5) == "talk ":
					speech_type = SPEECH_TYPE.TALK
					speaking_character = current_line.substr(6)
					
					if speaking_character == "Capitu":
						character_image.visible = true
						character_sprites.animation = "Falando"
						character_sprites.play()
					
					_read_line(true)
					return
					
					
				
				if current_line.substr(1, 5) == "think":
					speech_type = SPEECH_TYPE.THINK
					_read_line(true)
					return
					
				
				if current_line.substr(1, 5) == "bgimg":
					var image_name: StringName = ""
					
					image_name = current_line.substr(7)
					#set background image and animate screen for ths change
					background_image.texture = _fetch_background(image_name)
					
					_read_line(true)
					return
					
				
				if current_line.substr(1, 5) == "chimg":
					#whether it should animate the character when changing the sprite.
					var animate: bool = false
					var is_switch_animation: bool = false
					var image_name: StringName = ""
					
					image_name = current_line.substr(7)
					
					if current_line.substr(6, 9) == " animate ":
						animate = true
						image_name = current_line.substr(15)
						
					
					#animate the character image node if animate is true
					if animate:
						#print(animate, " animate chimg (", current_line.substr(15, 7), ")")
						if current_line.substr(15, 6) == "leave ":
							image_name = current_line.substr(21)
							character_animator.play(leave_animation_name)
							
						elif current_line.substr(15, 7) == "switch ":
							is_switch_animation = true
							image_name = current_line.substr(22)
							next_character_image_switch_image = _fetch_image(image_name)
							character_animator.play(switch_animation_name)
							
						else:
							character_animator.play(enter_animation_name)
							
						
					
					if image_name == "aflita":
						character_sprites.animation = "Aflita Piscando"
						character_sprites.play()
					elif image_name == "brava":
						character_sprites.animation = "Brava Piscando"
						character_sprites.play()
					elif image_name == "furiosa":
						character_sprites.animation = "Furiosa Piscando"
						character_sprites.play()
					elif image_name == "sorrindo":
						character_sprites.animation = "Sorrindo Piscando"
						character_sprites.play()
					elif image_name == "surpresa":
						character_sprites.animation = "Surpresa Piscando"
						character_sprites.play()
					
					#set character image to whatever object in character image dict has the same name as "image_name"
					if is_switch_animation == false and not image_name == "_":
						character_image.texture = _fetch_image(image_name)
						
					
					_read_line(true)
					return
					
				
				if current_line.substr(1, 5) == "music":
					#set music
					var music_name = current_line.substr(7)
					
					actual_music.stream = _fetch_song(music_name)
					actual_music.play()
					
					_read_line(true)
					return
					
				
				if current_line.substr(1, 5) == "sound":
					#set music
					var music_name = current_line.substr(7)
					
					actual_sfx.stream = _fetch_sfx(music_name)
					actual_sfx.play()
					
					_read_line(true)
					return
					
				
			else:
				# if it's text
				_display_speech(current_line)
				
			
		
	


func _display_speech(text: String) -> void:
	var final_scroll_speed = 1.0/text_scroll_speed
	
	# Sets a wrapper for each speech type, start and end. if tehre is only a start, the end one will be the same as the start one.
	if speech_type == SPEECH_TYPE.TALK:
		wrapper = ['"']
		
		name_label.text = speaking_character
		name_label.visible = true
		
	if speech_type == SPEECH_TYPE.THINK:
		wrapper = ['(', ')']
		
		name_label.visible = false
		
	if wrapper.size() == 1:
		wrapper.append(wrapper[0]) 
		
	
	text_animating = true
	
	text_label.visible_characters = 0
	text_label.text = wrapper[0] + '[fade start=' + str(text_label.visible_characters - 5) + ' length=5]' + text + '[/fade]' + wrapper[1]
	
	animate_text(final_scroll_speed, text)
	#print(final_scroll_speed)
	


func animate_text(wait_time: float, text: String) -> void:
	if text_label.visible_characters <= text_label.text.length() - 29 and text_animating:
		#print(text_label.visible_characters, "/", text_label.text.length() - 29, " | ", text_label.text)
		
		text_label.visible_characters += 1
		text_label.text = wrapper[0] + '[fade start=' + str(text_label.visible_characters - 5) + ' length=5]' + text + '[/fade]' + wrapper[1]
		
		await get_tree().create_timer(wait_time).timeout
		animate_text(wait_time, text)
		
	else:
		text_animating = false
		
	

func _fetch_image(image_name: StringName) -> Texture2D:
	if character_images.has(image_name):
		return character_images[image_name]
		
	else:
		push_error('Imagem não encontrada: "', image_name, '".')
		return null
		
	

func _fetch_background(image_name: StringName) -> Texture2D:
	if background_dictionary.has(image_name):
		return background_dictionary[image_name]
		
	else:
		push_error('Imagem não encontrada: "', image_name, '".')
		return null
		
	


func _fetch_song(song_name: StringName) -> AudioStream:
	if music_dictionary.has(song_name):
		return music_dictionary[song_name]
		
	else:
		push_error('Áudio não encontrado: "', song_name, '".')
		return null
		
	


func _fetch_sfx(song_name: StringName) -> AudioStream:
	if sfx_dictionary.has(song_name):
		return sfx_dictionary[song_name]
		
	else:
		push_error('Áudio não encontrado: "', song_name, '".')
		return null
		
	


func _switch_animation_call() -> void:
	character_image.texture = next_character_image_switch_image
	


func _file_end_reached() -> void:
	active = false
	
	if not next_node == null:
		if "reader_script" in next_node:
			next_node.text_label = text_label
			next_node.name_label = name_label
			next_node.text_scroll_speed = text_scroll_speed
			next_node.character_image = character_image
			next_node.character_images = character_images
			next_node.character_animator = character_animator
			next_node.enter_animation_name = enter_animation_name
			next_node.leave_animation_name = leave_animation_name
			next_node.switch_animation_name = switch_animation_name
			next_node.music_dictionary = music_dictionary
			next_node.background_dictionary = background_dictionary
			next_node.background_image = background_image
			next_node.actual_music = actual_music
			next_node.actual_sfx = actual_sfx
			next_node.decision_dictionary = decision_dictionary
			next_node.container_but = container_but
			next_node.character_sprites = character_sprites
			
		
		if next_node.has_method("_start"):
			next_node._start()
			
		else:
			push_error('next_node has no "_start()" function. This means the chain will stop here and nothing else will happen from this point forward. Please apply here a valid node with a "_start()" function. (', name, ')')
			
		
	else:
		push_warning("next_node is null (", name, ")")
		
	


func _on_decision_selected():
	if choice_at_end_of_script:
		for decision in decision_dictionary:
			var new_button = CHOICE_BUTTON.instantiate()
			container_but.visible = true
			
			new_button.previous_reader = self
			new_button.button_name = decision[0]
			new_button.next_node = get_node(decision[2])
			
			print("Le node ", new_button.next_node)
			container_but.add_child(new_button)
	
	
