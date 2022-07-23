extends CanvasLayer

class_name GSGameContinue

signal continued

export(int) var seconds: int = 10
export(int) var cost_to_continue: int = 10
export(int) var score: int = 0
export(int) var high_score: int = 0

onready var lblTimer: Label = $ModalContainer/lblTimer
onready var btnContinue: Button = $ModalContainer/modalBackground/btnContinue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lblHighScore: Label = $ModalContainer/lblHighScore
	var lblYourScore: Label = $ModalContainer/lblYourScore
	
	btnContinue.text = 'USE ' + str(cost_to_continue)
	lblHighScore.text = 'HIGH SCORE: ' + str(high_score)
	lblYourScore.text = 'YOUR SCORE: ' + str(score)
	_set_continue_seconds_text(seconds)
	
	var animator: AnimationPlayer = $BoxAnimator
	animator.play("SlideUp")
	yield(animator, "animation_finished")
	
	# Make the Continue button flash
	animator = $ModalContainer/modalBackground/btnContinue/btnContinueAnimator
	animator.play("Flash")

func _set_continue_seconds_text(seconds_remaining: int):
	lblTimer.text = str(seconds_remaining)


func _on_btnClose_pressed() -> void:
	if get_tree().change_scene("res://UI/MainMenu.tscn") != OK:
		print(self.filename, ": An unexpected error occured when trying to switch to the MainMenu scene")


func _on_btnContinue_pressed() -> void:
	emit_signal("continued")
	queue_free()

func _on_ContinueTimer_timeout() -> void:
	if seconds == 0:
		if get_tree().change_scene("res://UI/MainMenu.tscn") != OK:
			print(self.filename, ": An unexpected error occured when trying to switch to the MainMenu scene")
		return
	
	seconds -= 1
	_set_continue_seconds_text(seconds)
