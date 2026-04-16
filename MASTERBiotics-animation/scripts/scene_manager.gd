# scene_manager.gd — Loads/unloads scenes, manages transitions and auto-play timeline
extends Node

signal scene_started(scene_id: String)
signal auto_play_loop_complete()

const SCENES: Array[Dictionary] = [
	{ "id": "scene_0", "path": "res://scenes/opening/Opening.tscn", "duration": 15.0 },
	{ "id": "scene_1", "path": "res://scenes/spore_intro/SporeIntro.tscn", "duration": 60.0 },
	{ "id": "scene_2", "path": "res://scenes/body_journey/BodyJourney.tscn", "duration": 75.0 },
	{ "id": "scene_3", "path": "res://scenes/immune/Immune.tscn", "duration": 60.0 },
	{ "id": "scene_4", "path": "res://scenes/wellness/Wellness.tscn", "duration": 60.0 },
	{ "id": "scene_5", "path": "res://scenes/clinical/Clinical.tscn", "duration": 60.0 },
	{ "id": "scene_6", "path": "res://scenes/ending/Ending.tscn", "duration": 45.0 },
]

var _current_index := -1
var _current_scene_node: Node = null
var _auto_playing := false
var _scene_timer := 0.0
var _transitioning := false

@onready var scene_container: Node3D = get_node("../SceneContainer")
@onready var js_bridge: Node = get_node("../JSBridge")
@onready var transition_overlay: ColorRect = get_node("../TransitionLayer/TransitionOverlay")

func _process(delta: float) -> void:
	if _auto_playing and not _transitioning:
		_scene_timer += delta
		var current_duration: float = SCENES[_current_index].duration if _current_index >= 0 else 0.0
		if _scene_timer >= current_duration:
			_advance_auto_play()

func start_auto_play() -> void:
	_auto_playing = true
	if _current_index < 0:
		_current_index = 0
	else:
		_current_index = (_current_index + 1) % SCENES.size()
	_load_scene(_current_index)

func pause_auto_play() -> void:
	_auto_playing = false

func show_idle_screen() -> void:
	_auto_playing = false

func jump_to_scene(scene_id: String) -> void:
	for i in range(SCENES.size()):
		if SCENES[i].id == scene_id:
			_current_index = i
			_auto_playing = false
			_load_scene(i)
			return
	push_warning("[SceneManager] Unknown scene_id: %s" % scene_id)

func _advance_auto_play() -> void:
	var next_index := _current_index + 1
	if next_index >= SCENES.size():
		auto_play_loop_complete.emit()
		return
	_current_index = next_index
	_load_scene(next_index)

func _load_scene(index: int) -> void:
	_transitioning = true
	_scene_timer = 0.0

	# Fade out
	if transition_overlay:
		var tween := create_tween()
		tween.tween_property(transition_overlay, "color:a", 1.0, 0.4)
		await tween.finished

	# Remove old scene
	if _current_scene_node:
		_current_scene_node.queue_free()
		_current_scene_node = null

	# Load new scene
	var scene_data: Dictionary = SCENES[index]
	var packed_scene := load(scene_data.path) as PackedScene
	if packed_scene:
		_current_scene_node = packed_scene.instantiate()
		scene_container.add_child(_current_scene_node)

	js_bridge.notify_scene_change(scene_data.id)
	scene_started.emit(scene_data.id)

	# Fade in
	if transition_overlay:
		var tween_in := create_tween()
		tween_in.tween_property(transition_overlay, "color:a", 0.0, 0.4)
		await tween_in.finished

	_transitioning = false
	print("[SceneManager] Loaded: %s" % scene_data.id)
