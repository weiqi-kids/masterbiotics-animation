extends Node3D

## S2 — Body Journey (75s) — The Showpiece
## Phase 1 (0-15s): Oral to esophagus — camera moves down
## Phase 2 (15-35s): Stomach — acid particles, bacteria survive
## Phase 3 (35-60s): Small intestine — sprouting animation
## Phase 4 (60-75s): Large intestine — colonization on gut wall

@onready var camera: Camera3D = $Camera3D
@onready var esophagus: MeshInstance3D = $Esophagus
@onready var stomach: MeshInstance3D = $Stomach
@onready var small_intestine: MeshInstance3D = $SmallIntestine
@onready var large_intestine: MeshInstance3D = $LargeIntestine
@onready var bacteria_group: Node3D = $BacteriaGroup
@onready var acid_particles: GPUParticles3D = $AcidParticles
@onready var sprout_particles: GPUParticles3D = $SproutParticles
@onready var gut_wall: MeshInstance3D = $GutWall
@onready var light: OmniLight3D = $OmniLight3D
@onready var phase_label: Label3D = $PhaseLabel

func _ready() -> void:
	# Initial state
	acid_particles.emitting = false
	sprout_particles.emitting = false
	phase_label.modulate = Color(1, 1, 1, 0)

	# Hide bacteria initially
	for child in bacteria_group.get_children():
		child.scale = Vector3.ZERO

	_run_animation()

func _run_animation() -> void:
	var tween := create_tween()

	# ========== Phase 1 (0-15s): Oral → Esophagus ==========
	# Show phase label
	tween.tween_callback(func(): phase_label.text = "Oral Cavity → Esophagus")
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Bacteria appear at mouth position
	tween.tween_callback(func():
		for child in bacteria_group.get_children():
			var grow_tween := create_tween()
			grow_tween.tween_property(child, "scale", Vector3.ONE, 0.8) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	).set_delay(1.0)

	# Camera travels down through the esophagus
	tween.tween_property(camera, "position", Vector3(0, -4, 3), 8.0).set_delay(2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(bacteria_group, "position:y", -4.0, 8.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Fade label
	tween.tween_property(phase_label, "modulate:a", 0.0, 1.0).set_delay(1.0)

	# ========== Phase 2 (15-35s): Stomach ==========
	tween.tween_callback(func():
		phase_label.text = "Stomach — Acid Survival"
		phase_label.position = Vector3(0, -6, 0)
	)
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Camera enters stomach area
	tween.tween_property(camera, "position", Vector3(0, -8, 4), 5.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(bacteria_group, "position:y", -8.0, 5.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Acid particles start
	tween.tween_callback(func():
		acid_particles.emitting = true
	).set_delay(1.0)

	# Light turns greenish/danger
	tween.tween_property(light, "light_color", Color(0.4, 0.733, 0.416, 1.0), 3.0) \
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(light, "light_energy", 3.0, 2.0)

	# Bacteria shake/wobble but survive
	tween.tween_callback(func():
		for child in bacteria_group.get_children():
			var shake := create_tween().set_loops(5)
			shake.tween_property(child, "rotation:z", 0.15, 0.3) \
				.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
			shake.tween_property(child, "rotation:z", -0.15, 0.3) \
				.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	).set_delay(1.0)

	# Acid fades, light returns
	tween.tween_callback(func():
		acid_particles.emitting = false
	).set_delay(5.0)
	tween.tween_property(light, "light_color", Color(1.0, 0.835, 0.31, 1.0), 2.0)
	tween.tween_property(phase_label, "modulate:a", 0.0, 1.0)

	# ========== Phase 3 (35-60s): Small Intestine — Sprouting ==========
	tween.tween_callback(func():
		phase_label.text = "Small Intestine — Spore Germination"
		phase_label.position = Vector3(0, -13, 0)
	)
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Camera moves deeper
	tween.tween_property(camera, "position", Vector3(0, -14, 3.5), 6.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(bacteria_group, "position:y", -14.0, 6.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Sprouting burst particles
	tween.tween_callback(func():
		sprout_particles.position = bacteria_group.position
		sprout_particles.emitting = true
	).set_delay(2.0)

	# Bacteria grow slightly (sprouting = becoming active)
	tween.tween_callback(func():
		for child in bacteria_group.get_children():
			var sprout := create_tween()
			sprout.tween_property(child, "scale", Vector3(1.3, 1.3, 1.3), 3.0) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	).set_delay(1.0)

	# Gold light burst
	tween.tween_property(light, "light_energy", 5.0, 2.0).set_delay(2.0)
	tween.tween_property(light, "light_energy", 2.0, 3.0)

	tween.tween_callback(func():
		sprout_particles.emitting = false
	).set_delay(2.0)

	tween.tween_property(phase_label, "modulate:a", 0.0, 1.0).set_delay(1.0)

	# ========== Phase 4 (60-75s): Large Intestine — Colonization ==========
	tween.tween_callback(func():
		phase_label.text = "Large Intestine — Colonization"
		phase_label.position = Vector3(0, -20, 0)
	)
	tween.tween_property(phase_label, "modulate:a", 1.0, 1.0)

	# Camera to large intestine
	tween.tween_property(camera, "position", Vector3(0, -20, 3), 5.0).set_delay(1.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.parallel().tween_property(bacteria_group, "position:y", -19.5, 5.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	# Bacteria move toward gut wall and attach
	tween.tween_callback(func():
		var idx := 0
		for child in bacteria_group.get_children():
			var attach := create_tween()
			var target_x := -1.5 + idx * 0.6
			attach.tween_property(child, "position:x", target_x, 2.0) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			attach.parallel().tween_property(child, "position:z", -1.0, 2.0) \
				.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			idx += 1
	).set_delay(1.0)

	# Gut wall glows to show colonization
	tween.tween_property(gut_wall, "transparency", 0.0, 3.0).set_delay(2.0) \
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

	# Warm light
	tween.tween_property(light, "light_color", Color(1.0, 0.835, 0.31, 1.0), 2.0)
	tween.tween_property(light, "light_energy", 3.0, 2.0)

	# Final fade
	tween.tween_property(phase_label, "modulate:a", 0.0, 1.5).set_delay(1.0)
