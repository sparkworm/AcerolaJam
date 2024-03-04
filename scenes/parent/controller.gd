## This class controls a character
class_name Controller
extends Node

@export var character: Character

signal move(direction: Vector2)
signal rotate(target_direction: float, delta: float)
