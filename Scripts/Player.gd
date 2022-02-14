extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2.ZERO
const MAX_SPEED = 100
const ACCELERATION = 500
const FRICTION = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello world")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

	if inputVector != Vector2.ZERO:
		velocity = velocity.move_toward(MAX_SPEED * inputVector, ACCELERATION* delta)
		velocity += inputVector.normalized() * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)
