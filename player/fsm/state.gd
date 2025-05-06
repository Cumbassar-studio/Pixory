class_name State
extends Node


var state_machine: Node = null


func innner_unhandled_input(_event: InputEvent) -> void:
	pass


func inner_process(_delta: float) -> void:
	pass


func inner_physics_process(_delta: float) -> void:
	pass


func enter(_msg: Dictionary={}) -> void:
	pass


func exit() -> void:
	pass
