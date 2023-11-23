extends Node2D
onready var timer: Timer = Timer.new()
onready var animation: AnimationPlayer = get_node("animation")


func _ready():
	add_child(timer) 
	#instancia um no do tipo TIMER para fazer a animação
	timer.wait_time = 5
	timer.start()
	timer.connect("timeout", self, "time_over")

func time_over():
	animation.play("vento")
	timer.wait_time = rand_range(4, 10)
	pass

func _on_animation_animation_finished(anim_name):
	animation.stop()
	timer.start()
