extends Node3D

@onready var state_machine: Node = $StateMachine
@onready var scene_manager: Node = $SceneManager
@onready var js_bridge: Node = $JSBridge

func _ready() -> void:
	scene_manager.auto_play_loop_complete.connect(state_machine.on_auto_play_loop_complete)
	js_bridge.web_command_received.connect(_on_web_command)
	print("[Main] Ready. Starting in AUTO_PLAY.")

func _on_web_command(command: String, payload: Variant) -> void:
	match command:
		"jump_to_scene":
			state_machine.on_jump_to_scene(str(payload))
		"set_language":
			TranslationServer.set_locale(str(payload))
			js_bridge.set_language(str(payload))
		_:
			push_warning("[Main] Unknown web command: %s" % command)
