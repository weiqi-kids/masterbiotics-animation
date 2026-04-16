extends Node3D

## S1 — Spore Introduction (60s)
## Phase 1 (0-20s): Two bacteria appear and are introduced
## Phase 2 (20-40s): Spore shell forms around BC bacteria
## Phase 3 (40-60s): Acid environment — regular bacteria dissolves, spore survives

@onready var camera: Camera3D = $Camera3D
@onready var bc_bacteria: MeshInstance3D = $BC_Bacteria
@onready var bs_bacteria: MeshInstance3D = $BS_Bacteria
@onready var spore_shell: MeshInstance3D = $SporeShell
@onready var acid_particles: GPUParticles3D = $AcidParticles
@onready var title_label: Label3D = $TitleLabel
@onready var light: OmniLight3D = $OmniLight3D

func _ready() -> void:
	# Initial state
	bc_bacteria.scale = Vector3.ZERO
	bs_bacteria.scale = Vector3.ZERO
	spore_shell.scale = Vector3.ZERO
	spore_shell.visible = false
	acid_particles.emitting = false
	title_label.modulate = Color(1, 1, 1, 0)

	_run_animation()

func _run_animation() -> void:
	var tween := create_tween()

	# --- Phase 1 (0-20s): Bacteria appear ---
	# Title fades in
	tween.tween_property(title_label, "modulate:a", 1.0, 1.5)

	# BC bacteria (gold) grows in from left
	tween.tween_property(bc_bacteria, "scale", Vector3.ONE, 2.0).set_delay(1.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

	# BS bacteria (blue) grows in from right
	tween.tween_property(bs_bacteria, "scale", Vector3.ONE, 2.0).set_delay(1.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

	# Gentle float animation for both bacteria
	tween.tween_property(bc_bacteria, "position:y", -0.8, 3.0).set_delay(2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(bs_bacteria, "position:y", 0.8, 3.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Camera slowly zooms to BC
	tween.tween_property(camera, "position", Vector3(-1.5, 0, 5), 4.0).set_delay(2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Title fades out before Phase 2
	tween.tween_property(title_label, "modulate:a", 0.0, 1.0).set_delay(1.0)

	# --- Phase 2 (20-40s): Spore shell forms ---
	# Show spore shell and grow it around BC
	tween.tween_callback(func():
		spore_shell.visible = true
		spore_shell.position = bc_bacteria.position
	).set_delay(1.0)

	tween.tween_property(spore_shell, "scale", Vector3(1.4, 1.4, 1.4), 4.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	# Shell pulsing glow — light energy ramps
	tween.tween_property(light, "light_energy", 3.0, 2.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(light, "light_energy", 1.5, 2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Camera centers back
	tween.tween_property(camera, "position", Vector3(0, 0, 6), 3.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# --- Phase 3 (40-60s): Acid test ---
	# Start acid particles
	tween.tween_callback(func():
		acid_particles.emitting = true
	).set_delay(2.0)

	# Background light shifts to danger red
	tween.tween_property(light, "light_color", Color(0.937, 0.325, 0.314, 1.0), 3.0) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)

	# BS bacteria (no spore) dissolves — shrinks and fades
	tween.tween_property(bs_bacteria, "scale", Vector3(0.1, 0.1, 0.1), 5.0).set_delay(2.0) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property(bs_bacteria, "transparency", 1.0, 5.0) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)

	# Spore shell glows stronger — it survives
	tween.tween_property(light, "light_energy", 4.0, 2.0).set_delay(1.0)
	tween.tween_property(light, "light_color", Color(1.0, 0.835, 0.31, 1.0), 2.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Acid stops
	tween.tween_callback(func():
		acid_particles.emitting = false
	).set_delay(2.0)

	# Final — gentle pulse on spore
	tween.tween_property(spore_shell, "scale", Vector3(1.5, 1.5, 1.5), 1.5) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(spore_shell, "scale", Vector3(1.4, 1.4, 1.4), 1.5) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
