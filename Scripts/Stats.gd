extends Node

# export is like the public key word/ SerializedField property in unity and exposes the variable as editable to the editor
export(int) var maxHealth = 1 setget set_max_health

# setget is similar to the properties in C#, but you have to create a func for it, like here with set_health, get_health
# Calling down, signaling up
var health = maxHealth setget set_health, get_health

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_health(value):
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")

func set_max_health(value):
	maxHealth = value
	self.health = min(health, maxHealth)
	emit_signal("max_health_changed", maxHealth)

func get_health():
	return health

func _ready():
	self.health = maxHealth