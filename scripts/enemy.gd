extends RigidBody2D

@onready var player: CharacterBody2D = $"../../Player"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var player_detector: Area2D = $PlayerDetector
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2
@onready var area_2d: Area2D = $Area2D

var able_to_be_squished = false
var is_squished = false
var speed = -50
var direction = -1



	
func _process(delta: float) -> void:
	if player.can_squish:
		able_to_be_squished = true
	else:
		able_to_be_squished = false

	if not is_squished:
		if ray_cast_2d.is_colliding():
			direction = 1
		elif ray_cast_2d_2.is_colliding():
			direction = -1

		linear_velocity.x = speed * direction
	else:
		linear_velocity.x = 0


func die():
	animated_sprite_2d.play("squish")
	audio_stream_player_2d.play()
	collision_shape_2d.queue_free()
	area_2d.queue_free()
	player_detector.queue_free()
	is_squished = true


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body == player and able_to_be_squished:
		print("touched")
		die()
		





func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		get_tree().reload_current_scene()
