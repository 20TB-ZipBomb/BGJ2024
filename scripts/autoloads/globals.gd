extends Node

# Global script for holding references to things and stuff
var main: Node
var player: CharacterBody3D
signal animal_penned_signal(animal: Animal)

## Current wave number, used for balancing storm behavior and animals spawned
var current_storm_wave_number: int


signal shout_energy_changed(value: float) # set shout energy. 0 is no shout, 1 is shout ready
