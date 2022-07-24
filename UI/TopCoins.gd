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
	lblCoins.text = format_number(GsGameState.coins)

func _on_coin_acquired() -> void:
	start_scramble()
	
func format_number(num: int) -> String:
	var num_str: String = str(num)
	var str_length: int = num_str.length()
	var s: String
	
	if str_length < 4:
		return num_str
	
	for i in range(str_length):
			if((str_length - i) % 3 == 0 and i > 0):
				s = str(s, ",", num_str[i])
			else:
				s = str(s, num_str[i])
			
	return s
