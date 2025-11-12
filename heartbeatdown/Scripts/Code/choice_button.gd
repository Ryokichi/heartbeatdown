extends Button

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
@export var container_but: VBoxContainer

@export_category("Script End Choices")
## These variables only matter if choice_at_end_of_script is true.
## Esse aqui abaixo é o dicionário dos botões de decisão
@export var decision_dictionary: Array[Array] = []
## Nodes which the buttons in the options variable will direct to. The _start() function will be called. The button in index N will call _start() from the node indexed N here.
@export var responses: Array[Node] = []
@export var mostrar_but: bool = false

@export_category("Debug")
## Starts the script as soon as this node is instanced, helps debugging process.
@export var start_at_runtime: bool = false
## Closes game when the quotes key is pressed, for quick debugging and testing.
@export var quit_with_quote: bool = false
## Skips the script supposed to be read, starting the next node instantly.
@export var skip_novel_script: bool = false


@export var button_name: StringName = ""
@export var previous_reader: Node
@export var next_node: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = button_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_up() -> void:
	next_node.text_label = previous_reader.text_label
	next_node.name_label = previous_reader.name_label
	next_node.text_scroll_speed = previous_reader.text_scroll_speed
	next_node.character_image = previous_reader.character_image
	next_node.character_images = previous_reader.character_images
	next_node.character_animator = previous_reader.character_animator
	next_node.enter_animation_name = previous_reader.enter_animation_name
	next_node.leave_animation_name = previous_reader.leave_animation_name
	next_node.switch_animation_name = previous_reader.switch_animation_name
	next_node.music_dictionary = previous_reader.music_dictionary
	next_node.background_dictionary = previous_reader.background_dictionary
	next_node.background_image = previous_reader.background_image
	next_node.actual_music = previous_reader.actual_music
	next_node.actual_sfx = previous_reader.actual_sfx
	next_node.decision_dictionary = previous_reader.decision_dictionary
	next_node.container_but = previous_reader.container_but
	next_node.character_sprites = previous_reader.character_sprites
	
	previous_reader.container_but.queue_free()
	
	if next_node.has_method("_start"):
		next_node._start()
		
	
