extends enemy_texture
class_name guarda001_texture

func animate(velocity: Vector2) -> void:
	if enemy.pode_morrer or enemy.levou_dano:
		action_behavior()
	else:
		move_behaviour(velocity)

func action_behavior() -> void:
	if enemy.pode_morrer:
		animation.play("Morte")
		enemy.levou_dano = false
		enemy.pode_atacar = false
	elif enemy.levou_dano:
		animation.play("Dano")
		enemy.pode_atacar = false
		
func move_behaviour(velocity: Vector2) -> void:
	if velocity.x != 0:
		animation.play("correndo")
	elif enemy.preparar_ataque and !enemy.pode_atacar:
		animation.play("preparando_ataque")
	elif !enemy.preparar_ataque and enemy.pode_atacar: #aqui é se o enimigo está apto para atacar e já se preparou
		animation.play("ataque")
	else:
		animation.play("parado") # se nada daquilo acontecer ele fica parado
		
func _on_animation_finished(anim_name: String):
	match anim_name:
		"Dano":
			enemy.levou_dano = false
			enemy.set_physics_process(true)
			
		"Morte":
			enemy.morrer()
		
		"preparando_ataque":
			enemy.pode_atacar = true
		
		"ataque":
			animation.play("ataque")

