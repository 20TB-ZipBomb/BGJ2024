extends Node

# Global script for holding references to things and stuff
var main: Node
var player: CharacterBody3D


signal shout_energy_changed(value: float) # set shout energy. 0 is no shout, 1 is shout ready
