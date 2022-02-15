extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MAX_SPEED = 100
const ROLL_SPEED = 150
const ACCELERATION = 500
const FRICTION = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var velocity = Vector2.ZERO
var rollVector = Vector2.LEFT
var state = MOVE



# Onready var is only created if the Node (AnimationPlayer here) is ready.
# Shortcut to the _ready() function
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox

# Called when the node enters the scene tree for the first time. 
# Similar to the Start() function in Unity.
func _ready():
	animationTree.active = true
	swordHitbox.knockbackVector = rollVector


# Called every frame. 'delta' is the elapsed time since the previous frame.
# Similar to the Update() function in Unity.
#func _process(delta):
#	pass

# Similar to the FixedUpdate() function in Unity for physics calculation and movement.
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state()

func move_state(delta):
	var inputVector = Vector2.ZERO
	inputVector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	inputVector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	inputVector = inputVector.normalized()

	if inputVector != Vector2.ZERO:
		rollVector = inputVector
		swordHitbox.knockbackVector = inputVector

		# Needs to be here, because it snaps back to left.
		animationTree.set("parameters/Idle/blend_position", inputVector)
		animationTree.set("parameters/Run/blend_position", inputVector)
		animationTree.set("parameters/Attack/blend_position", inputVector)
		animationTree.set("parameters/Roll/blend_position", inputVector)

		animationState.travel("Run")
		velocity = velocity.move_toward(MAX_SPEED * inputVector.normalized(), ACCELERATION* delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	move()

	if Input.is_action_just_pressed("attack"):
		state = ATTACK

	if Input.is_action_just_pressed("roll"):
		state = ROLL

func attack_state():
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func roll_state():
	velocity = rollVector * ROLL_SPEED
	animationState.travel("Roll")	
	move()

func attack_animation_finished():
	state = MOVE

func roll_animation_finished():
	velocity = velocity * 0.7
	state = MOVE

func move():
	velocity = move_and_slide(velocity)