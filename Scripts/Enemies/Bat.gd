extends KinematicBody2D

enum {	
	IDLE,
	WANDER,
	CHASE
}

const enemyDeathEffect = preload("res://Scenes/Effects/EnemyDeathEffect.tscn")

export var acceleration = 300
export var friction = 200
export var maxSpeed = 50

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderContoller = $WanderController

var state

func _ready():
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, friction * delta)
	knockback = move_and_slide(knockback)

	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wanderContoller.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			if wanderContoller.get_time_left() == 0:
				update_wander()

			accelerate_toward_point(delta, wanderContoller.target_position)
			
			if global_position.distance_to(wanderContoller.target_position) <= maxSpeed * delta: 
				update_wander()
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_toward_point(delta, player.global_position)
			else:
				state = IDLE

	sprite.flip_h = velocity.x < 0
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)

func accelerate_toward_point(delta, point):
	var direction = global_position.direction_to(point).normalized()
	velocity = velocity.move_toward(maxSpeed * direction, acceleration * delta)

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderContoller.start_wander_timer(rand_range(1,3))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

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
