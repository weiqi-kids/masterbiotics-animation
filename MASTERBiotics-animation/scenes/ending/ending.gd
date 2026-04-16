extends Node3D

## S6 — Ending: Zoom Out + Logo (45s)
## Phase 1 (0-15s): Camera zooms out, particles converge inward
## Phase 2 (15-30s): Logo appears with glow, brand text fades in
## Phase 3 (30-45s): Logo pulses gently, URL appears

@onready var camera: Camera3D = $Camera3D
@onready var particles: GPUParticles3D = $ParticleEmitter
@onready var logo_text: Label3D = $LogoText
@onready var brand_text: Label3D = $BrandText
@onready var url_text: Label3D = $UrlText
@onready var light: OmniLight3D = $OmniLight3D

func _ready() -> void:
	# Initial state
	logo_text.modulate = Color(1, 1, 1, 0)
	brand_text.modulate = Color(1, 1, 1, 0)
	url_text.modulate = Color(1, 1, 1, 0)
	light.light_energy = 0.0

	_run_animation()

func _run_animation() -> void:
	var tween := create_tween()

	# ========== Phase 1 (0-15s): Zoom out + particles converge ==========
	# Camera starts close and pulls back
	tween.tween_property(camera, "position:z", 10.0, 12.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Particles begin
	tween.parallel().tween_callback(func():
		particles.emitting = true
	)

	# Gradually increase attraction (negative radial_accel = inward)
	tween.tween_callback(func():
		var mat := particles.process_material as ParticleProcessMaterial
		if mat:
			mat.radial_accel_min = -0.8
			mat.radial_accel_max = -0.8
	).set_delay(3.0)

	tween.tween_callback(func():
		var mat := particles.process_material as ParticleProcessMaterial
		if mat:
			mat.radial_accel_min = -1.5
			mat.radial_accel_max = -1.5
	).set_delay(3.0)

	# Light begins warming up
	tween.parallel().tween_property(light, "light_energy", 1.5, 8.0) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)

	# ========== Phase 2 (15-30s): Logo + brand appear ==========
	# Logo fades in
	tween.tween_property(logo_text, "modulate:a", 1.0, 3.0).set_delay(2.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Light intensifies with logo
	tween.parallel().tween_property(light, "light_energy", 3.0, 3.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Brand text fades in below logo
	tween.tween_property(brand_text, "modulate:a", 1.0, 3.0).set_delay(2.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Particles reach max convergence
	tween.tween_callback(func():
		var mat := particles.process_material as ParticleProcessMaterial
		if mat:
			mat.radial_accel_min = -2.0
			mat.radial_accel_max = -2.0
	).set_delay(2.0)

	# ========== Phase 3 (30-45s): Gentle pulse + URL ==========
	# URL fades in
	tween.tween_property(url_text, "modulate:a", 1.0, 2.0).set_delay(1.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Logo gentle pulse (loop for remainder)
	tween.tween_property(light, "light_energy", 3.5, 2.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(light, "light_energy", 2.5, 2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(light, "light_energy", 3.5, 2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(light, "light_energy", 2.5, 2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(light, "light_energy", 3.0, 2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
