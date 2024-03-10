class_name TransitionArea
extends Area2D

@export var next_level: PackedScene

## the character capable of changing the scene
var main_character: Character

## This is called when the main character enters the transition area.
signal change_level(next_level: PackedScene)

func _on_body_entered(body):
	if body == main_character:
		change_level.emit(next_level)
