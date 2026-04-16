# idle_timer.gd — Click/tap to advance scene, press Home/R to restart
extends Node

@onready var scene_manager: Node = get_node("../SceneManager")

func _unhandled_input(event: InputEvent) -> void:
	# Click or tap → advance to next scene
	if event is InputEventScreenTouch and event.pressed:
		scene_manager.skip_to_next()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		scene_manager.skip_to_next()
	# Press R or Home → restart from S0
	elif event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_R or event.keycode == KEY_HOME:
			scene_manager.restart()
