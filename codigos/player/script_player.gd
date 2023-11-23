extends KinematicBody2D
class_name Player

onready var player_sprite: Sprite = get_node("Sprite")
onready var wall_ray: RayCast2D = get_node("wallray")
onready var stats: Node = get_node("stats_player")


var velocidade: Vector2
var direction: int = 1
var jump_count: int = 0
var jump_wall_count: int = 0
var on_hit: bool = false
var dead: bool = false


var caiu: bool = false
var atacando: bool = false
var on_wall: bool = false

var pode_realiar_actions:bool = true
var not_on_wall: bool = true

export(int) var speed
export(int) var jump_speed
export(int) var gravidade_player

export(int) var gravidade_wall
export(int) var jump_wall
export(int) var wall_impulse




func _physics_process(delta: float):
	movimento_horizontal_env()
	movimento_vetical_env()
	actions_env()
	
	gravidade(delta)
	velocidade = move_and_slide(velocidade, Vector2.UP)
	player_sprite.animate(velocidade)

func movimento_horizontal_env() -> void:
	if pode_realiar_actions == false or atacando:
		velocidade.x = 0
		return
	var input_direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocidade.x = input_direction * speed
	
func movimento_vetical_env() -> void:
	if is_on_floor():
		jump_wall_count = 0
	if is_on_floor() or is_on_wall():
		jump_count = 0
		
	var condition_jump: bool = pode_realiar_actions and not atacando
	if Input.is_action_just_pressed("ui_up") and jump_count < 2 and condition_jump and jump_wall_count < 2:
		jump_count += 1
		if not is_on_floor() and not is_on_wall():
			jump_wall_count +=1
		if next_to_wall() and not is_on_floor() and jump_wall_count < 2:
			jump_wall_count +=1
			velocidade.y = jump_wall
			velocidade.x += wall_impulse * direction
		
		else:
			velocidade.y = jump_speed

func actions_env() -> void:
	ataque()

func ataque():
	var condicion_ataque: bool = not atacando
	
	if Input.is_action_just_pressed("ataque") and condicion_ataque and is_on_floor():
		atacando = true
		player_sprite.normal_ataque = true


func gravidade(delta: float) -> void:
	if next_to_wall():
		velocidade.y += gravidade_wall * delta
		if velocidade.y >= gravidade_wall:
			velocidade.y = gravidade_wall
	else:
		velocidade.y += delta * gravidade_player
		if velocidade.y >= gravidade_player:
			velocidade.y = gravidade_player
			


func next_to_berada() -> void:
	if wall_ray.is_colliding() and not is_on_floor():
		pass
	pass
	
func next_to_wall() -> bool:
	if wall_ray.is_colliding() and not is_on_floor():
		if not_on_wall:
			velocidade.y = 0
			not_on_wall = false
			
		return true
	else:
		not_on_wall = true
		return false
