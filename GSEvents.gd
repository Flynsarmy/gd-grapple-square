extends Node

# Fires when the player crosses a distance number. Emitted in UI/LevelDistance.gd
signal distance_marker_reached(number) # warning-ignore:unused_signal
# Fires when the player hits a coin/gem. Emitted in Props/Gem.gd
signal coin_acquired # warning-ignore:unused_signal
