extends Node

# Global script for holding references to things and stuff
var main: Node
var player: CharacterBody2D


signal shout(player_position: Vector2) # Provides the position the shout originated from
signal shout_energy(value: float) # set shout energy. 0 is no shout, 1 is shout ready
