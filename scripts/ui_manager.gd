extends Reference

var quiz_controller = null

func init(controller):
	quiz_controller = controller
	setup_ui()

func setup_ui():
	quiz_controller.score_label.text = "Score: 0"
	quiz_controller.lives_label.text = "Lives: " + str(quiz_controller.lives)
	quiz_controller.next_button.hide()
	quiz_controller.feedback_label.hide()
	quiz_controller.explanation_label.hide()
	quiz_controller.grid_container.hide()

func hide_grid_elements():
	quiz_controller.grid_container.hide()

func show_grid_elements():
	quiz_controller.grid_container.show()

func hide_quiz_elements():
	quiz_controller.quiz_container.hide()

func show_quiz_elements():
	quiz_controller.quiz_container.show()

func reset_ui():
	for button in quiz_controller.option_buttons:
		button.show()
		button.disabled = false
		button.add_color_override("font_color", Color(1, 1, 1))
	
	quiz_controller.question_label.show()
	quiz_controller.quiz_container.hide()
	quiz_controller.grid_container.hide()
