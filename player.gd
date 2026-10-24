extends CharacterBody2D


var SPEED = 100.0
var jump_velocity = -300.0
var canGroundPound = false
var isGroundPounding = false
var ground_pound_velocity = 500
var ACCEL = 90
var shake_fade = 20.0
var shake_strength = 0.0
var original_camera_offset = Vector2.ZERO
var did_tutorial_1 = false
var did_tutorial_2 = false
var did_tutorial_3 = false
var did_tutorial_4 = false
var did_tutorial_5 = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var camera_2d: Camera2D = $Camera2D
@onready var dialogue_manager: CanvasLayer = %DialogueManager
@onready var player_audio: AudioStreamPlayer2D = %PlayerAudio
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var dialogue_manager_tutorial: CanvasLayer = $"../DialogueManager"










func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor() and not isGroundPounding:
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_velocity
		audio_stream_player_2d_2.play()

	# Moving in directions and flipping the characters and animations
	var direction := Input.get_axis("ui_left", "ui_right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
		
	if not isGroundPounding:
		if is_on_floor():
			if direction == 0:
				animated_sprite_2d.play("idle")
			else:
				animated_sprite_2d.play("walking")
		else:
			animated_sprite_2d.play("jump")


	
	if not isGroundPounding:
		if direction:
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL * delta)
		else:
			velocity.x = move_toward(velocity.x, direction * SPEED, ACCEL * delta)
	
	
	
	# Running
	if Input.is_action_pressed("ui_run"):
		SPEED = 150
		animated_sprite_2d.speed_scale = 1.5
	else:
		SPEED = 100
		animated_sprite_2d.speed_scale = 1.0
		
		
	if Input.is_action_just_pressed("ui_ground_pound") and not is_on_floor() and not isGroundPounding:
		isGroundPounding = true
		velocity = Vector2.ZERO
		animated_sprite_2d.play("roll")
		timer.start()
		audio_stream_player_2d.play()

		
		
		

	move_and_slide()
	
	
	if shake_strength > 0:
		camera_2d.offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		shake_strength = move_toward(shake_strength, 0, 40 * delta)
	else:
		camera_2d.offset = Vector2.ZERO
	
	if is_on_floor() and isGroundPounding:
		isGroundPounding = false
		timer.stop()
		shake_camera(6.0)



func shake_camera(strength: float):
	shake_strength = strength

func _on_timer_timeout():
	if not is_on_floor() and isGroundPounding:
		velocity.y = ground_pound_velocity
		velocity.x = 0
		player_audio.play()
		
func restart_game():
	if Input.is_action_just_pressed("ui_restart"):
		get_tree().reload_current_scene()
		
func _process(delta: float) -> void:
	restart_game()
		
# The dialogue






func wait_for_dialogue():
	while dialogue_manager.is_dialogue_active:
		await get_tree().create_timer(0.1, true, false, true).timeout

	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_chief_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		dialogue_manager.start_dialogue(["Oh! It's you!",
		"You're the new volunteer to explore the big world!",
		"...",
		"You don't know how to do anything?",
		"...",
		"Wow, I really thought as a volunteer you would be able to...",
		"Well, that doesn't matter. I will teach you.",
		"Let's go up!"] as Array[String])
		
		wait_for_dialogue()
		

		


func _on_tutorial_1_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not did_tutorial_1:
		dialogue_manager_tutorial.start_dialogue(["This is the outside world.",
		"We move around with magical elements called Keys",
		"To jump, press the Z key."] as Array[String])
		did_tutorial_1 = true
		



func _on_tutorial_2_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not did_tutorial_2:
		dialogue_manager_tutorial.start_dialogue(["Good! You made it up here!",
		"Now this gap is too far to cross with a normal jump.",
		"So instead, you can hold down the X key to run.",
		"Then you will have enough momentum to make the gap.",
		"There is also an EVEN EASIER way to cross the gap."] as Array[String])
		did_tutorial_2 = true


func _on_tutorial_3_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not did_tutorial_3:
		dialogue_manager_tutorial.start_dialogue(["AWESOME!!! You made the gap!",
		"Now continue on to the next part!"] as Array[String])
		did_tutorial_3 = true
		

		


func _on_tutorial_4_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not did_tutorial_4:
		dialogue_manager_tutorial.start_dialogue(["Us tinies have a weird physics relationship with the large world.",
		"This ball here will bend to your will.",
		"With this new knowledge, try to knock over the arrows and meet me on the other side.",
		"If you ever get stuck, press the R key."] as Array[String])
		did_tutorial_4 = true
		



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and not did_tutorial_5:
		dialogue_manager_tutorial.start_dialogue(["AMAZING!!! You finished!",
		"Now head through the door to start your first adventure!!!"] as Array[String])
		did_tutorial_5 = true
		


func _on_darkness_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		get_tree().change_scene_to_file("res://scenes/control.tscn")
