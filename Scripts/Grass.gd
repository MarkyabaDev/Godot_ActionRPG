extends Node2D
	
func create_grass_effect():
		var grassEffect = load("res://Scenes/Effects/GrassEffect.tscn")
		var grassEffectInstance = grassEffect.instance()
		var world = get_tree().current_scene
		world.add_child(grassEffectInstance)
		grassEffectInstance.global_position = global_position

func _on_Hurtbox_area_entered(area:Area2D):
	create_grass_effect()
	queue_free()
