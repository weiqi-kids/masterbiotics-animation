extends Node3D

## S4 — Wellness: GLP-1 / Dopamine / Antioxidant (60s)
## Segment 1 (0-20s): GLP-1 signal from gut to pancreas/stomach
## Segment 2 (20-40s): Vagus nerve → Dopamine in brain
## Segment 3 (40-60s): Antioxidant — SOD neutralizes ROS

@onready var camera: Camera3D = $Camera3D
@onready var gut: MeshInstance3D = $Gut
@onready var pancreas: MeshInstance3D = $Pancreas
@onready var stomach2: MeshInstance3D = $Stomach2
@onready var brain: MeshInstance3D = $Brain
@onready var vagus_nerve: MeshInstance3D = $VagusNerve
@onready var ros_particles: GPUParticles3D = $ROSParticles
@onready var sod_particles: GPUParticles3D = $SODParticles
@onready var dopamine_particles: GPUParticles3D = $DopamineParticles
@onready var signal_beam_pancreas: MeshInstance3D = $SignalBeamPancreas
@onready var signal_beam_stomach: MeshInstance3D = $SignalBeamStomach
@onready var light: OmniLight3D = $OmniLight3D
@onready var phase_label: Label3D = $PhaseLabel

func _ready() -> void:
	# Initial state — hide beams and particles
	signal_beam_pancreas.visible = false
	signal_beam_stomach.visible = false
	vagus_nerve.visible = false
	ros_particles.emitting = false
	sod_particles.emitting = false
	dopamine_particles.emitting = false
	phase_label.modulate = Color(1, 1, 1, 0)

	# Organs start dim
	pancreas.transparency = 0.7
	stomach2.transparency = 0.7
	brain.transparency = 0.7

	_run_animation()

func _run_animation() -> void:
	var tween := create_tween()

	# ========== Segment 1 (0-20s): GLP-1 ==========
	tween.tween_callback(func(): phase_label.text = "GLP-1 Signal Pathway")
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Gut glows
	tween.tween_property(light, "light_energy", 3.0, 2.0).set_delay(2.0)

	# Signal beam to pancreas appears
	tween.tween_callback(func():
		signal_beam_pancreas.visible = true
		signal_beam_pancreas.scale = Vector3(0, 1, 0)
	).set_delay(1.0)
	tween.tween_property(signal_beam_pancreas, "scale:x", 1.0, 2.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	# Pancreas lights up
	tween.tween_property(pancreas, "transparency", 0.0, 2.0).set_delay(1.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Signal beam to stomach
	tween.tween_callback(func():
		signal_beam_stomach.visible = true
		signal_beam_stomach.scale = Vector3(0, 1, 0)
	).set_delay(1.0)
	tween.tween_property(signal_beam_stomach, "scale:x", 1.0, 2.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	# Stomach lights up
	tween.tween_property(stomach2, "transparency", 0.0, 2.0).set_delay(1.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	tween.tween_property(phase_label, "modulate:a", 0.0, 1.0).set_delay(1.0)

	# ========== Segment 2 (20-40s): Vagus Nerve → Dopamine ==========
	tween.tween_callback(func(): phase_label.text = "Vagus Nerve → Dopamine Release")
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Camera shifts up toward brain
	tween.tween_property(camera, "position", Vector3(0, 2.5, 6), 4.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Vagus nerve appears (connecting gut to brain)
	tween.tween_callback(func():
		vagus_nerve.visible = true
		vagus_nerve.transparency = 1.0
	).set_delay(1.0)
	tween.tween_property(vagus_nerve, "transparency", 0.3, 3.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Brain lights up
	tween.tween_property(brain, "transparency", 0.0, 3.0).set_delay(1.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Dopamine burst in brain area
	tween.tween_callback(func():
		dopamine_particles.emitting = true
	).set_delay(1.0)

	# Warm golden glow
	tween.tween_property(light, "light_energy", 4.0, 2.0).set_delay(1.0)
	tween.tween_property(light, "light_energy", 2.5, 2.0)

	tween.tween_callback(func():
		dopamine_particles.emitting = false
	).set_delay(2.0)

	tween.tween_property(phase_label, "modulate:a", 0.0, 1.0).set_delay(1.0)

	# ========== Segment 3 (40-60s): Antioxidant (SOD vs ROS) ==========
	tween.tween_callback(func(): phase_label.text = "SOD Antioxidant Activity")
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Camera centers
	tween.tween_property(camera, "position", Vector3(0, 0, 6), 3.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# ROS particles appear (red, damaging)
	tween.tween_callback(func():
		ros_particles.emitting = true
	).set_delay(1.0)

	# Light turns reddish
	tween.tween_property(light, "light_color", Color(0.937, 0.325, 0.314, 1.0), 3.0) \
		.set_delay(1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)

	# SOD particles appear (green, neutralizing)
	tween.tween_callback(func():
		sod_particles.emitting = true
	).set_delay(2.0)

	# Light transitions to healthy green
	tween.tween_property(light, "light_color", Color(0.4, 0.733, 0.416, 1.0), 4.0) \
		.set_delay(1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# ROS fades, SOD wins
	tween.tween_callback(func():
		ros_particles.emitting = false
	).set_delay(3.0)

	tween.tween_callback(func():
		sod_particles.emitting = false
	).set_delay(2.0)

	# Light returns to gold
	tween.tween_property(light, "light_color", Color(1.0, 0.835, 0.31, 1.0), 2.0)
	tween.tween_property(phase_label, "modulate:a", 0.0, 1.5)
