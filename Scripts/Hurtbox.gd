extends Area2D

const hitEffect = preload("res://Scenes/Effects/HitEffect.tscn")

var invicibility = false setget set_invincible, get_invincible

onready var timer = $Timer

signal invicibility_started
signal invicibility_ended

func set_invincible(value):
	invicibility = value
	if invicibility == true:
		emit_signal("invicibility_started")
	else:
		emit_signal("invicibility_ended")


func get_invincible():
	return invicibility

func start_invincibility(duration):
	self.invicibility = true
	timer.start(duration)


func create_hit_effect():		
	var hitEffectInstance = hitEffect.instance()
	var world = get_tree().current_scene
	world.add_child(hitEffectInstance)
	hitEffectInstance.global_position = global_position


func _on_Timer_timeout():
	# Using self.invicibility causes the variable to be set via setter and not directlys
	self.invicibility = false


func _on_Hurtbox_invicibility_started():
	# Has been changed in later versions from monitorable to monitoring
	set_deferred("monitoring", false)


func _on_Hurtbox_invicibility_ended():
	monitoring = true
