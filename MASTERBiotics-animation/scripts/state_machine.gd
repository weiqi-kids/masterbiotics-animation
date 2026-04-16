# state_machine.gd — Manages AUTO_PLAY / INTERACTIVE / IDLE states
extends Node

signal state_changed(new_state: String)

enum State { AUTO_PLAY, INTERACTIVE, IDLE }

const IDLE_DISPLAY_DURATION := 5.0
const INTERACTIVE_TIMEOUT := 30.0

var current_state: State = State.AUTO_PLAY
var _idle_timer := 0.0
var _interactive_timer := 0.0

@onready var scene_manager: Node = get_node("../SceneManager")
@onready var js_bridge: Node = get_node("../JSBridge")

func _ready() -> void:
	# Defer so all sibling @onready vars are initialized first
	_enter_state.call_deferred(State.AUTO_PLAY)

func _process(delta: float) -> void:
	match current_state:
		State.IDLE:
			_idle_timer += delta
			if _idle_timer >= IDLE_DISPLAY_DURATION:
				_enter_state(State.AUTO_PLAY)
		State.INTERACTIVE:
			_interactive_timer += delta
			if _interactive_timer >= INTERACTIVE_TIMEOUT:
				_enter_state(State.AUTO_PLAY)

func _enter_state(new_state: State) -> void:
	current_state = new_state
	var state_name := _state_name(new_state)

	match new_state:
		State.AUTO_PLAY:
			scene_manager.start_auto_play()
		State.INTERACTIVE:
			_interactive_timer = 0.0
			scene_manager.pause_auto_play()
		State.IDLE:
			_idle_timer = 0.0
			scene_manager.show_idle_screen()

	js_bridge.notify_mode_change(state_name)
	state_changed.emit(state_name)
	print("[StateMachine] -> %s" % state_name)

func on_auto_play_loop_complete() -> void:
	if current_state == State.AUTO_PLAY:
		_enter_state(State.IDLE)

func on_touch_detected() -> void:
	match current_state:
		State.AUTO_PLAY, State.IDLE:
			_enter_state(State.INTERACTIVE)
		State.INTERACTIVE:
			_interactive_timer = 0.0

func on_jump_to_scene(scene_id: String) -> void:
	if current_state == State.INTERACTIVE:
		_interactive_timer = 0.0
		scene_manager.jump_to_scene(scene_id)

func _state_name(state: State) -> String:
	match state:
		State.AUTO_PLAY: return "auto"
		State.INTERACTIVE: return "interactive"
		State.IDLE: return "idle"
	return "unknown"
