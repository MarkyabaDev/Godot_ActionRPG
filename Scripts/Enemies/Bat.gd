extends KinematicBody2D

enum {	
	IDLE,
	WADNDER,
	CHASE
}

const enemyDeathEffect = preload("res://Scenes/Effects/EnemyDeathEffect.tscn")

export var acceleration = 300
export var friction = 200
export var maxSpeed = 50


var state = IDLE

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox

func _ready():
	print(stats.maxHealth)
	print(stats.health)

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
		WADNDER:
			pass
		
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direction = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(maxSpeed * direction, acceleration * delta)
			else:
				state = IDLE
	sprite.flip_h = velocity.x < 0
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		print("Chase")
		state = CHASE

func _on_Hurtbox_area_entered(area:Area2D):
	stats.health -= area.damage
	knockback = area.knockbackVector * 120
	hurtbox.create_hit_effect()

func _on_Stats_no_health():
	queue_free()
	create_death_effect()

func create_death_effect():
	var enemyDeathEffectInstance = enemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffectInstance)
	enemyDeathEffectInstance.global_position = global_position
