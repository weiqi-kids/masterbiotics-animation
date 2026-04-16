# idle_timer.gd — Detects touch/click events and forwards to state machine
extends Node

@onready var state_machine: Node = get_node("../StateMachine")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		state_machine.on_touch_detected()
	elif event is InputEventMouseButton and event.pressed:
		state_machine.on_touch_detected()
