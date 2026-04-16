extends Node3D

## S3 — Immune Response at Gut Wall (60s)
## Segment 1 (0-20s): Anti-virus defense
## Segment 2 (20-40s): Anti-allergy response
## Segment 3 (40-60s): Anti-inflammation regulation

@onready var camera: Camera3D = $Camera3D
@onready var gut_wall: MeshInstance3D = $GutWall
@onready var signal_particles: GPUParticles3D = $SignalParticles
@onready var shield_effect: MeshInstance3D = $ShieldEffect
@onready var virus_particles: GPUParticles3D = $VirusParticles
@onready var allergen_particles: GPUParticles3D = $AllergenParticles
@onready var inflammation_light: OmniLight3D = $InflammationLight
@onready var bacteria_on_wall: Node3D = $BacteriaOnWall
@onready var phase_label: Label3D = $PhaseLabel

func _ready() -> void:
	# Initial state
	signal_particles.emitting = false
	shield_effect.scale = Vector3.ZERO
	shield_effect.visible = false
	virus_particles.emitting = false
	allergen_particles.emitting = false
	phase_label.modulate = Color(1, 1, 1, 0)

	_run_animation()

func _run_animation() -> void:
	var tween := create_tween()

	# ========== Segment 1 (0-20s): Anti-Virus ==========
	tween.tween_callback(func(): phase_label.text = "Immune Activation — Anti-Virus")
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Bacteria on wall start emitting signal particles
	tween.tween_callback(func():
		signal_particles.emitting = true
	).set_delay(2.0)

	# Shield begins forming
	tween.tween_callback(func():
		shield_effect.visible = true
	).set_delay(2.0)
	tween.tween_property(shield_effect, "scale", Vector3(2.5, 2.5, 2.5), 3.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	# Virus particles attack
	tween.tween_callback(func():
		virus_particles.emitting = true
	).set_delay(1.0)

	# Shield pulses to repel viruses
	tween.tween_property(shield_effect, "scale", Vector3(3.0, 3.0, 3.0), 1.0).set_delay(2.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(shield_effect, "scale", Vector3(2.5, 2.5, 2.5), 1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Virus particles stop (repelled)
	tween.tween_callback(func():
		virus_particles.emitting = false
	).set_delay(2.0)

	tween.tween_property(phase_label, "modulate:a", 0.0, 1.0).set_delay(1.0)

	# ========== Segment 2 (20-40s): Anti-Allergy ==========
	tween.tween_callback(func(): phase_label.text = "Immune Balance — Anti-Allergy")
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Camera shifts slightly
	tween.tween_property(camera, "position:x", 1.0, 3.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Allergen particles appear (yellow)
	tween.tween_callback(func():
		allergen_particles.emitting = true
	).set_delay(1.0)

	# Signal particles intensify — bacteria respond
	tween.tween_property(inflammation_light, "light_energy", 3.0, 2.0).set_delay(1.0)

	# Shield shifts color to cyan (calming)
	var shield_mat: StandardMaterial3D = shield_effect.get_surface_override_material(0)
	if shield_mat:
		tween.tween_method(func(val: float):
			if shield_mat:
				shield_mat.albedo_color = Color(
					lerp(0.259, 0.149, val),
					lerp(0.647, 0.776, val),
					lerp(0.961, 0.855, val),
					0.25
				)
		, 0.0, 1.0, 3.0)

	# Allergens neutralized
	tween.tween_callback(func():
		allergen_particles.emitting = false
	).set_delay(4.0)

	tween.tween_property(phase_label, "modulate:a", 0.0, 1.0).set_delay(1.0)

	# ========== Segment 3 (40-60s): Anti-Inflammation ==========
	tween.tween_callback(func(): phase_label.text = "Immune Regulation — Anti-Inflammation")
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Camera returns to center
	tween.tween_property(camera, "position:x", 0.0, 3.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Inflammation light turns red (inflammation)
	tween.tween_property(inflammation_light, "light_color", Color(0.937, 0.325, 0.314, 1.0), 3.0) \
		.set_delay(1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(inflammation_light, "light_energy", 5.0, 2.0)

	# Signal particles work — bacteria calm the inflammation
	tween.tween_property(inflammation_light, "light_color", Color(0.259, 0.647, 0.961, 1.0), 4.0) \
		.set_delay(2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(inflammation_light, "light_energy", 1.5, 4.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Shield settles at calm glow
	tween.tween_property(shield_effect, "scale", Vector3(2.0, 2.0, 2.0), 2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Signal particles stop, scene complete
	tween.tween_callback(func():
		signal_particles.emitting = false
	).set_delay(2.0)

	tween.tween_property(phase_label, "modulate:a", 0.0, 1.5)
