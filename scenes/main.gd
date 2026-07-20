extends Node


const house:PackedScene = preload("res://scenes/house/day1/house.tscn")

func _ready() -> void:
	add_child(house.instantiate())
