extends Area2D

export(bool) var show_hit = true

const hitEffect = preload("res://Scenes/Effects/HitEffect.tscn")

func _on_Hurtbox_area_entered(area:Area2D):
	if !show_hit:
		return
		
	var hitEffectInstance = hitEffect.instance()
	var world = get_tree().current_scene
	world.add_child(hitEffectInstance)
	hitEffectInstance.global_position = global_position
