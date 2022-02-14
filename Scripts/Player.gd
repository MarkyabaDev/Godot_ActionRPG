extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var velocity = Vector2.ZERO
const MAX_SPEED = 100
const ACCELERATION = 500
const FRICTION = 500

# Onready var is only created if the Node (AnimationPlayer here) is ready.
# Shortcut to the _ready() function
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

# Called when the node enters the scene tree for the first time. 
# Similar to the Start() function in Unity.
func _ready():
	#animationPlayer = $AnimationPlayer
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Similar to the Update() function in Unity.
#func _process(delta):
#	pass

# Similar to the FixedUpdate() function in Unity for physics calculation and movement.
func _physics_process(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized()

	if inputVector != Vector2.ZERO:

		# Needs to be here, because it snaps back to left.
		animationTree.set("parameters/Idle/blend_position", inputVector)
		animationTree.set("parameters/Run/blend_position", inputVector)

		animationState.travel("Run")
		velocity = velocity.move_toward(MAX_SPEED * inputVector.normalized(), ACCELERATION* delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	velocity = move_and_slide(velocity)
