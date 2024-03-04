class_name GameScene
extends Node

## this array contains all the other scenes that the GameScene can transition to
#@export var next_scenes: Array[PackedScene]

## emitted to initiate the process that will replace this scene with the specified scene
signal scene_changed(scene: PackedScene)

