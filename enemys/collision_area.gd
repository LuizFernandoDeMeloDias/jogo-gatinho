extends Area2D

class_name collision_area

onready var timer: Timer = get_node("Timer")

export(int) var vida
export(float) var invencibilidade_tempo
export(NodePath) onready var enemy = get_node(enemy)




func _on_collision_area_area_entered(area):
	print("aaa")
	if area.get_parent() is Player:
		var status_player: Node = area.get_parent().get_node("stats_player")
		var player_atack: int = status_player.ataque_basico + status_player.ataque_bonus
		update_vida(player_atack)
		print("oi")

func update_vida(dano: int) -> void:
	vida -= dano
	if vida <= 0:
		enemy.pode_morrer = true
		return
	enemy.levou_dano = true
	
