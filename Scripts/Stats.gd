extends Node

# export is like the public key word in unity and exposes the variable as editable to the editor
export(int) var maxHealth = 1

# setget is similar to the properties in C#, but you have to create a func for it, like here with set_health, get_health
# Calling down, signaling up
onready var health = maxHealth setget set_health, get_health

signal no_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")

func get_health():
	return health