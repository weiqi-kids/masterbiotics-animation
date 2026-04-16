extends Node3D

## S5 — Clinical: Protein Absorption (60s)
## Phase 1 (0-20s): Food enters, large protein molecules visible
## Phase 2 (20-40s): Enzymatic breakdown — large → small molecules
## Phase 3 (40-60s): Absorption comparison — with vs without MASTERBiotics

@onready var camera: Camera3D = $Camera3D
@onready var human_silhouette: MeshInstance3D = $HumanSilhouette
@onready var digestive_tract: MeshInstance3D = $DigestiveTract
@onready var protein_large: Node3D = $ProteinLarge
@onready var protein_small: Node3D = $ProteinSmall
@onready var absorption_particles: GPUParticles3D = $AbsorptionParticles
@onready var waste_particles: GPUParticles3D = $WasteParticles
@onready var light: OmniLight3D = $OmniLight3D
@onready var phase_label: Label3D = $PhaseLabel

func _ready() -> void:
	# Initial state
	absorption_particles.emitting = false
	waste_particles.emitting = false
	phase_label.modulate = Color(1, 1, 1, 0)

	# Hide small proteins initially
	for child in protein_small.get_children():
		child.scale = Vector3.ZERO
		child.visible = false

	_run_animation()

func _run_animation() -> void:
	var tween := create_tween()

	# ========== Phase 1 (0-20s): Food enters ==========
	tween.tween_callback(func(): phase_label.text = "Protein Digestion")
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Camera focuses on upper digestive tract
	tween.tween_property(camera, "position", Vector3(0, 1, 5), 3.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Large protein molecules descend into tract
	tween.tween_callback(func():
		for child in protein_large.get_children():
			var fall := create_tween()
			fall.tween_property(child, "position:y", child.position.y - 2.0, 4.0) \
				.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	).set_delay(2.0)

	# Light focuses on the proteins
	tween.tween_property(light, "light_energy", 3.0, 2.0).set_delay(2.0)

	# Gentle tumbling rotation on large proteins
	tween.tween_callback(func():
		for child in protein_large.get_children():
			var spin := create_tween().set_loops(3)
			spin.tween_property(child, "rotation:y", TAU, 3.0)
	).set_delay(2.0)

	tween.tween_property(phase_label, "modulate:a", 0.0, 1.0).set_delay(3.0)

	# ========== Phase 2 (20-40s): Enzymatic breakdown ==========
	tween.tween_callback(func(): phase_label.text = "Enzymatic Breakdown — MASTERBiotics")
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Camera moves to mid-section
	tween.tween_property(camera, "position", Vector3(0, -0.5, 4.5), 4.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Gold glow = enzyme activity
	tween.tween_property(light, "light_color", Color(1.0, 0.835, 0.31, 1.0), 2.0).set_delay(1.0)
	tween.tween_property(light, "light_energy", 4.0, 1.5)

	# Large proteins shrink (being digested)
	tween.tween_callback(func():
		for child in protein_large.get_children():
			var shrink := create_tween()
			shrink.tween_property(child, "scale", Vector3(0.2, 0.2, 0.2), 4.0) \
				.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	).set_delay(1.0)

	# Small proteins appear (digested fragments)
	tween.tween_callback(func():
		for child in protein_small.get_children():
			child.visible = true
			var appear := create_tween()
			appear.tween_property(child, "scale", Vector3.ONE, 1.5) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	).set_delay(3.0)

	tween.tween_property(light, "light_energy", 2.5, 2.0).set_delay(2.0)
	tween.tween_property(phase_label, "modulate:a", 0.0, 1.0).set_delay(1.0)

	# ========== Phase 3 (40-60s): Absorption ==========
	tween.tween_callback(func(): phase_label.text = "Enhanced Absorption")
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Camera to lower digestive area
	tween.tween_property(camera, "position", Vector3(0, -2, 4), 3.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Absorption particles (bright, many = good absorption)
	tween.tween_callback(func():
		absorption_particles.emitting = true
	).set_delay(1.0)

	# Green healthy glow
	tween.tween_property(light, "light_color", Color(0.4, 0.733, 0.416, 1.0), 3.0) \
		.set_delay(1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Small proteins move outward through wall (absorbed)
	tween.tween_callback(func():
		for child in protein_small.get_children():
			var absorb := create_tween()
			absorb.tween_property(child, "position:x", child.position.x + sign(child.position.x) * 2.0, 4.0) \
				.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
			absorb.parallel().tween_property(child, "scale", Vector3(0.3, 0.3, 0.3), 4.0)
	).set_delay(1.0)

	# Waste particles (dim, few = efficient)
	tween.tween_callback(func():
		waste_particles.emitting = true
	).set_delay(2.0)

	# Final glow
	tween.tween_property(light, "light_energy", 3.0, 2.0).set_delay(3.0)
	tween.tween_property(light, "light_color", Color(1.0, 0.835, 0.31, 1.0), 2.0)

	tween.tween_callback(func():
		absorption_particles.emitting = false
		waste_particles.emitting = false
	).set_delay(2.0)

	tween.tween_property(phase_label, "modulate:a", 0.0, 1.5)
