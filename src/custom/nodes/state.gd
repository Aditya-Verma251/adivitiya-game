extends Node

class_name State

func state_ready() -> State:
	return null

func state_process(delta: float) -> State:
	return null

func state_physics_process(delta: float) -> State:
	return null

func state_input(event: InputEvent) -> State:
	return null

func handle_key_input(event: InputEvent) -> State:
	return null

func handle_input(event: InputEvent) -> State:
	return null
