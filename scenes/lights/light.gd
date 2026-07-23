@tool

extends Node3D

var material:StandardMaterial3D = preload("res://assets/materials/light_base.tres").duplicate()

@export var lit:bool = true:
	set(value):
		lit = value
		_set_lit()
@export var color:Color = Color.WHITE:
	set(value):
		color = value
		_set_light_color()

func _ready() -> void:
	$Light.set_surface_override_material(1, material)
	material.albedo_color = color
	material.emission = color
	$OmniLight3D.light_color = color

func _set_lit():
	if lit:
		$OmniLight3D.light_energy = 0.2
		material.emission_enabled = true
	else:
		$OmniLight3D.light_energy = 0.0
		material.emission_enabled = false

func _set_light_color():
	material.albedo_color = color
	$OmniLight3D.light_color = color
	material.emission = color
