extends Node2D

# Number of characters in our coins number
onready var length: int = str(GsGameState.coins).length()
onready var lblCoins: Label = $CanvasLayer/MarginContainer/lblCoins

# While loading we scramble the points text wildly
var scrambling: bool = true

func _ready() -> void:
	if GsEvents.connect("coin_acquired", self, "_on_coin_acquired") != OK:
		print(self.filename, ": Error connecting to coin_acquired signal.")
		
	start_scramble()

func _physics_process(_delta: float) -> void:
	if scrambling:
		call_deferred("scramble_coins_number")

func start_scramble():
	scrambling = true
	($TextScrambleTimer as Timer).start()

func scramble_coins_number():
	if length > 0:
		var output: String = ""
		for _i in length:
			output += str(randi() % 10)
		lblCoins.text = output

func _on_TextAnimationTimer_timeout() -> void:
	scrambling = false
	lblCoins.text = GsHelpers.format_number(GsGameState.coins)

func _on_coin_acquired() -> void:
	start_scramble()
