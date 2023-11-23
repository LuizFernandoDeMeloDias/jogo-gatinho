extends KinematicBody2D
class_name enemy_template

onready var texture: Sprite = get_node("texture") # conecta a textura
onready var floor_ray: RayCast2D = get_node("floor_ray") # conecta a colissão que detecta o chão
onready var animation: AnimationPlayer = get_node("animation") # conecta ao objeto que gerencia as animações 

var pode_morrer: bool = false
var levou_dano: bool = false
var pode_atacar: bool = false
var preparar_ataque: bool = false
var player_procurado: bool = false




var velocidade: Vector2
var player_ref = null


export(int) var speed = rand_range(10, 20)
export(int) var gravidade_speed
export(int) var proximity_threshold
export(int) var ray_cast_defaut_position
export(int) var detection_area_position

func _physics_process(delta: float) -> void:
	gravity(delta)
	move_behavior() # chama a função move_behaviour
	verify_position() #chama a funcção pra verificar a posição de si mesmo 
	texture.animate(velocidade)
	velocidade = move_and_slide(velocidade, Vector2.UP)
	
func gravity(delta: float) -> void:
	velocidade.y  += delta * gravidade_speed


func move_behavior() -> void:
	if player_ref != null and player_procurado: # se o player entrou na colissão de visão
		var distancia: Vector2 = player_ref.global_position - global_position
		#subtrai o position global.x do player com a dele
		var direction: Vector2 = distancia.normalized() # normaliza transformando em 1 ou -1
		if abs(distancia.x) <= proximity_threshold: 
			#se ele chegar perto do player ele para
			velocidade.x = 0 
			if pode_atacar == false:
				preparar_ataque = true
			else:
				preparar_ataque = false
		elif floor_collision() and not pode_atacar:
			velocidade.x = direction.x * speed
		else:
			pode_atacar = false
			velocidade.x = 0
			
		return
	elif player_ref != null and !player_procurado:
		get_node("pensamento").visible = true
		get_node("pensamento").play("avistou")
	elif player_ref == null:
		pass
	velocidade.x = 0
func floor_collision() -> bool:
	if floor_ray.is_colliding():
		return true
	return false
	
	
func verify_position() -> void:
	if player_ref != null:
		var direction: float = sign(player_ref.global_position.x - global_position.x)
		if direction == 1:
			texture.flip_h = false
			get_node("detection_area/collision").position.x  = abs(detection_area_position)
			floor_ray.position.x = abs(ray_cast_defaut_position)
		elif direction == -1:
			texture.flip_h = true
			floor_ray.position.x = ray_cast_defaut_position
			get_node("detection_area/collision").position.x = detection_area_position

func morrer() -> void:
	set_physics_process(false)
