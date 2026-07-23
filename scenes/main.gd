extends Node


const day1:PackedScene = preload("res://scenes/house/day1/day1.tscn")

func _ready() -> void:
	add_child(day1.instantiate())
