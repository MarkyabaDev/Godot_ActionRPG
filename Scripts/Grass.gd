extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("attack"):
		var grassEffect = load("res://Scenes/Effects/GrassEffect.tscn")
		var grassEffectInstance = grassEffect.instance()
		var world = get_tree().current_scene
		world.add_child(grassEffectInstance)
		grassEffectInstance.global_position = global_position

		# Similar to the Destroy() function in Unity. Queues the object for destruction, if nothing is accessing it.
		queue_free()
	
