extends Node2D
class_name level

onready var player: KinematicBody2D = get_node("player")
func _ready():
	var _game_over: bool = player.get_node("Sprite").connect("game_over",self, "on_game_over")
	#conecta uma função na sprite do player 

func on_game_over() -> void:
	var reload: bool = get_tree().reload_current_scene()
	#caso o player morra a cena reinicia
