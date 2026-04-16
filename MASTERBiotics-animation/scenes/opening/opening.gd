extends Node3D

@onready var particles: GPUParticles3D = $ParticleEmitter
@onready var logo: Label3D = $LogoText
@onready var light: OmniLight3D = $OmniLight3D

func _ready() -> void:
    var tween := create_tween()

    # Phase 2 (5-10s): Particles attract toward center
    tween.tween_callback(func():
        var mat := particles.process_material as ParticleProcessMaterial
        if mat:
            mat.radial_accel_min = -1.5
            mat.radial_accel_max = -1.5
    ).set_delay(5.0)

    # Phase 3 (10-13s): Logo fades in with glow
    tween.tween_property(logo, "modulate:a", 1.0, 2.0).set_delay(5.0)
    tween.parallel().tween_property(light, "light_energy", 2.0, 2.0)

    # Phase 4 (13-15s): Camera pushes forward through logo
    tween.tween_property($Camera3D, "position:z", -2.0, 2.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
