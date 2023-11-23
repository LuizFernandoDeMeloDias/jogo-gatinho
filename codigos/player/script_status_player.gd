extends Node
class_name player_stats


export(NodePath) onready var player = get_node(player) as KinematicBody2D
export(NodePath) onready var collisionarea = get_node(collisionarea) as Area2D
onready var timer: Timer = Timer.new()
onready var invencibility_timer = timer
var vida_base: int = 15
var mana_base: int = 0
var ataque_basico: int = 1
var ataque_basico_magico: int = 0
var defesa_base: int = 0

var vida_bonus: int = 0
var ataque_bonus: int = 0
var mana_bonus: int = 0
var ataque_magico_bonus: int = 0
var defesa_bonus: int = 0

var vida_atual: int 
var mana_atual: int

var mana_maxima: int
var vida_maxima: int

var experiencia_atual: int = 0

var level: int = 0
var dicionario_nivel: Dictionary = {
	"1": 25,
	"2": 50,
	"3": 100,
	"4": 150,
	"5": 250,
	"6": 370,
	"7": 450,
	"8": 570,
	"9": 700,
	"10": 1000
}


func _ready():
	add_child(timer)
	timer.one_shot = true
	timer.connect("timeout", self, "on_invencibility_timeout")
	
	mana_atual = mana_base + mana_bonus
	mana_maxima = mana_atual
	
	vida_atual = vida_base + vida_bonus
	vida_maxima = vida_atual


func update_exp(valor: int) -> void:
	experiencia_atual = valor
	if experiencia_atual >= dicionario_nivel[str(level)] and level <= 10:
		var restos_exp: int = experiencia_atual - dicionario_nivel[str(level)]
		experiencia_atual = restos_exp
		passou_de_nivel()
		level += 1
	elif experiencia_atual >= dicionario_nivel[str(level)] and level == 9:
		experiencia_atual = dicionario_nivel[str(level)]

func passou_de_nivel():
	mana_atual = mana_base + mana_bonus
	vida_atual =  vida_base + vida_bonus

func uptade_vida(tipo: String, valor: int):
	match tipo:
		"tirar":
			damage(valor)
			if vida_atual <= 0:
				player.dead = true
			else:
				player.on_hit = true
				player.atacando = false
				pass
		"por":
			if vida_atual >= vida_maxima:
				vida_atual = vida_maxima

func damage(valor: int) -> void:
	vida_atual -= valor


func update_mana(tipo: String, valor: int) -> void:
	match tipo:
		"tirar":
			mana_atual += valor
			if mana_atual >= mana_maxima:
				mana_atual = mana_maxima
		"por":
			mana_atual -= valor

func _on_colliszion_area_area_entered(area):
	if area.name == "area_ataque_inimigo":
		uptade_vida("tirar", area.damage())
		collisionarea.set_deferred("Monitoring", false)
		invencibility_timer.start(area.invencibility_timer)
		
		
func on_invencibility_timeout() -> void:
	collisionarea.set_deferred("Monitoring", true)
	
	
