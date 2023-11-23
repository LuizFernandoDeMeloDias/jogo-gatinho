extends Sprite
class_name player_sprite
signal game_over

var normal_ataque: bool = true
var sufix = "_direita"

export(NodePath) onready var animation  = get_node(animation) as AnimationPlayer
export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var ataque_colision = get_node(ataque_colision) as CollisionShape2D


func animate(direction: Vector2) -> void:
	verificar_position(direction)
	if player.on_hit or player.dead:
		hit_behaviour()
	elif player.atacando or player.next_to_wall():
		action_behaviour()
	
	elif direction.y != 0:
		movimento_v_verification(direction)
	elif player.caiu == true:
		animation.play("caiu")
	else:
		movimente_h_verification(direction)

func verificar_position(direction: Vector2) -> void:
	if direction.x > 0:
		sufix = "_direita"
		flip_h = false
		player.direction = -1
		position = Vector2.ZERO
		player.wall_ray.cast_to.x = 4.5
	elif direction.x < 0:
		sufix = "_esquerda"
		flip_h = true
		player.direction = 1
		position = Vector2(-2, 0)
		player.wall_ray.cast_to.x = -7.3



func action_behaviour() -> void:
	if player.next_to_wall():
		animation.play("wall_slide")
	elif player.atacando == true:
		animation.play("ataque_garra" + sufix)
	
func hit_behaviour():
	player.set_physics_process(false)
	ataque_colision.set_deferred("disabled", true)
	if player.dead:
		animation.play("morrendo")
	elif player.on_hit:
		animation.play("levou_dano")

func movimento_v_verification(direction: Vector2) -> void:
	if direction.y > 0:
		player.caiu = true
		animation.play("caindo")
	elif direction.y < 0:
		animation.play("pulando")


func movimente_h_verification(direction: Vector2) -> void:
	if direction.x != 0:
		animation.play("correndo")
	else:
		animation.play("parado")

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"caiu":
			player.caiu = false
		"ataque_garra_direita":
			normal_ataque = false
			player.atacando = false
		"ataque_garra_esquerda":
			normal_ataque = false
			player.atacando = false
		"levou_dano":
			player.on_hit = false
			player.set_physics_process(true)
		"morrendo":
			emit_signal("game_over")
			
