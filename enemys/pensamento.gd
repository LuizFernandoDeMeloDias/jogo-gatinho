extends AnimatedSprite

export(NodePath) onready var enemy = get_node(enemy)

func _process(delta):
	if enemy.player_procurado:
		visible = true
		play("puto")
