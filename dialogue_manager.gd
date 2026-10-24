extends CanvasLayer


@onready var control: Control = $Control
@onready var label: Label = $Control/Label
@onready var audio: AudioStreamPlayer2D = $Control/AudioStreamPlayer2D


var dialogue_lines: Array[String] = []
var current_line = 0
var is_dialogue_active = false

func _ready():
	control.visible = false
	
	
func start_dialogue(lines: Array[String]):
	get_tree().paused = true
	
	
	
	dialogue_lines = lines
	current_line = 0
	is_dialogue_active = true
	control.visible = true
	label.text = dialogue_lines[current_line]
	
	audio.play()
	
	
func _input(event):
	if not is_dialogue_active:
		return
	if event.is_action_pressed("ui_jump"):
		advance_dialogue()
		
func advance_dialogue():
	if current_line < dialogue_lines.size() - 1:
		current_line += 1
		label.text = dialogue_lines[current_line]
		audio.play()
	else:
		get_tree().paused = false
		
		is_dialogue_active = false
		
		control.visible = false
		
	
	
