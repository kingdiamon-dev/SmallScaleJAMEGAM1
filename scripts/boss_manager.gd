extends Node

@onready var overworld_music: AudioStreamPlayer2D = $"../OverworldMusic"
@onready var boss_music: AudioStreamPlayer2D = $"../BossMusic"




func start_boss():
	print("Started")
	overworld_music.stop()
	boss_music.play()
