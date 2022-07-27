extends Node

# Emitted from Scripts/GSCustomizationManager.gd
signal avatar_changed(new_avatar) # warning-ignore:unused_signal
# Fires when the player hits a coin/gem. Emitted in Props/Gem.gd
signal coin_acquired # warning-ignore:unused_signal
# Fires when the player crosses a distance number. Emitted in UI/LevelDistance.gd
signal distance_marker_reached(number) # warning-ignore:unused_signal
# Emitted in UI/MainMenu.gd
signal started_new_game # warning-ignore:unused_signal
