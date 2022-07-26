extends CanvasLayer

class_name GSGameContinue

signal continued
signal not_continued

export(int) var seconds: int = 10

onready var lblTimer: Label = $ModalContainer/lblTimer
onready var btnContinue: Button = $ModalContainer/modalBackground/btnContinue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lblHighScore: Label = $ModalContainer/lblHighScore
	var lblYourScore: Label = $ModalContainer/lblYourScore
	
	btnContinue.text = 'USE ' + str(GsGameState.continue_cost)
	lblHighScore.text = 'HIGH SCORE: ' + GsHelpers.format_number(GsGameState.high_score)
	lblYourScore.text = 'YOUR SCORE: ' + GsHelpers.format_number(GsGameState.score)
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
	emit_signal("not_continued")
	queue_free()


func _on_btnContinue_pressed() -> void:
	emit_signal("continued")
	queue_free()

func _on_ContinueTimer_timeout() -> void:
	if seconds == 0:
		_on_btnClose_pressed()
		return
	
	seconds -= 1
	_set_continue_seconds_text(seconds)
