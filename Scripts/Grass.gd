extends Node2D

const grassEffect = preload("res://Scenes/Effects/GrassEffect.tscn")
	
func create_grass_effect():
		var grassEffectInstance = grassEffect.instance()
		get_parent().add_child(grassEffectInstance)
		grassEffectInstance.global_position = global_position

func _on_Hurtbox_area_entered(area:Area2D):
	create_grass_effect()
	queue_free()
