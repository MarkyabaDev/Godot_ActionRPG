extends KinematicBody2D

var knockback = Vector2.ZERO

onready var stats = $Stats

func _ready():
	print(stats.maxHealth)
	print(stats.health)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)

func _on_Hurtbox_area_entered(area:Area2D):
	stats.health -= area.damage
	knockback = area.knockbackVector * 120


func _on_Stats_no_health():
	queue_free()
