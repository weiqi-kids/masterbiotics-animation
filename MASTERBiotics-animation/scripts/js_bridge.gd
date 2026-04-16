# js_bridge.gd — JavaScript bridge for HTML5 export
extends Node

signal web_command_received(command: String, payload: Variant)

var _callback_ref: JavaScriptObject = null

func _ready() -> void:
	if OS.has_feature("web"):
		_callback_ref = JavaScriptBridge.create_callback(_on_web_command)
		var window := JavaScriptBridge.get_interface("window")
		window.registerGodotCallback(_callback_ref)
		print("[JSBridge] Registered web callback")
	else:
		print("[JSBridge] Not running in browser, bridge disabled")

func _on_web_command(args: Array) -> void:
	var json_str: String = args[0] if args.size() > 0 else "{}"
	var parsed = JSON.parse_string(json_str)
	if parsed is Dictionary:
		var command: String = parsed.get("command", "")
		var payload = parsed.get("payload", null)
		web_command_received.emit(command, payload)
		print("[JSBridge] Received: %s -> %s" % [command, str(payload)])

func notify_scene_change(scene_id: String) -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.onGodotSceneChange('%s')" % scene_id)

func notify_chart_trigger(chart_id: String, delay_ms: int = 0) -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.onGodotChartTrigger('%s', %d)" % [chart_id, delay_ms])

func notify_mode_change(mode: String) -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.onGodotModeChange('%s')" % mode)

func set_language(lang: String) -> void:
	if OS.has_feature("web"):
		JavaScriptBridge.eval("window.onGodotSetLanguage('%s')" % lang)
