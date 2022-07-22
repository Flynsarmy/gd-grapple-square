extends CanvasLayer

class_name GSGameContinue

signal continued

export(int) var seconds: int = 5
export(int) var cost: int = 10
export(int) var best_score: int = 0
export(int) var your_score: int = 0

onready var lblTimer: Label = $lblTimer
onready var btnContinue: Button = $btnContinue

var btn_continue_color_toggled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lblBestScore: Label = $lblBestScore
	var lblYourScore: Label = $lblYourScore
	
	btnContinue.text = 'USE ' + str(cost)
	lblBestScore.text = 'BEST SCORE: ' + str(best_score)
	lblYourScore.text = 'YOUR SCORE: ' + str(your_score)
	_set_continue_seconds_text(seconds)

func _set_continue_seconds_text(seconds_remaining: int):
	lblTimer.text = str(seconds_remaining)


func _on_btnClose_pressed() -> void:
	if get_tree().change_scene("res://UI/MainMenu.tscn") != OK:
		print("An unexpected error occured when trying to switch to the MainMenu scene")


func _on_btnContinue_pressed() -> void:
	emit_signal("continued")
	queue_free()


func _on_FlashTimer_timeout() -> void:
	var new_color: Color

	if btn_continue_color_toggled:
		new_color = Color("ffc762") # Gold
	else:
		 new_color = Color.white # White
	
	var stylebox: StyleBoxFlat = btnContinue.get_stylebox("normal")
	stylebox.bg_color = new_color

	btn_continue_color_toggled = !btn_continue_color_toggled


func _on_ContinueTimer_timeout() -> void:
	if seconds == 0:
		if get_tree().change_scene("res://UI/MainMenu.tscn") != OK:
			print("An unexpected error occured when trying to switch to the MainMenu scene")
		return
	
	seconds -= 1
	_set_continue_seconds_text(seconds)
