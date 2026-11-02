extends StaticBody2D



@onready var player: CharacterBody2D = $"../Player"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_shape_2d_2: CollisionShape2D = $CollisionShape2D2
@onready var player_detector: Area2D = $PlayerDetector
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


var able_to_be_squished = false
var is_squished = false

func _process(delta: float) -> void:
	if player.can_squish == true:
		able_to_be_squished = true
		print(able_to_be_squished)
	else:
		able_to_be_squished = false

func _on_player_detector_body_entered(body: Node2D) -> void:
	print("touched")
	if body.name == "Player" and able_to_be_squished:
		die()

func die():
	animated_sprite_2d.play("squish")
	audio_stream_player_2d.play()
	collision_shape_2d.queue_free()
	collision_shape_2d_2.queue_free()
	player_detector.queue_free()
	is_squished = true
