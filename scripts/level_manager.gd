extends Reference

var quiz_controller = null
var question_data = null
var current_questions = []
var selected_buttons = []
var selected_words = []
var menu_button = null

func init(controller, data):
	quiz_controller = controller
	question_data = data

func load_level(level_name):
	quiz_controller.current_level = level_name
	current_questions = question_data.get_questions(level_name)
	quiz_controller.current_question_index = 0
	start_quiz()

func start_quiz():
	quiz_controller.progress_bar.max_value = current_questions.size()
	show_question()
	quiz_controller.quiz_started = true

func show_question():
	var question = current_questions[quiz_controller.current_question_index]
	
	# Update UI
	quiz_controller.question_label.text = question["question"]
	quiz_controller.progress_bar.value = quiz_controller.current_question_index
	
	# Shuffle options
	var shuffled_options = question["options"].duplicate()
	shuffled_options.shuffle()
	
	# Assign options to buttons
	for i in range(quiz_controller.option_buttons.size()):
		quiz_controller.option_buttons[i].text = shuffled_options[i]
		quiz_controller.option_buttons[i].disabled = false
		quiz_controller.option_buttons[i].add_color_override("font_color", Color(1, 1, 1))
	
	# Reset feedback
	quiz_controller.feedback_label.hide()
	quiz_controller.explanation_label.hide()
	quiz_controller.next_button.hide()

func handle_answer(button):
	var selected_answer = button.text
	var question = current_questions[quiz_controller.current_question_index]
	var correct_answer = question["answer"]
	
	# Disable all buttons
	for btn in quiz_controller.option_buttons:
		btn.disabled = true
	
	if selected_answer == correct_answer:
		handle_correct_answer(button)
	else:
		handle_wrong_answer(button)
	
	# Show explanation
	quiz_controller.explanation_label.text = question["explanation"]
	quiz_controller.explanation_label.show()
	
	# Show next button if not last question
	if quiz_controller.current_question_index < current_questions.size() - 1:
		quiz_controller.next_button.show()
	else:
		show_final_results()

func handle_correct_answer(button):
	quiz_controller.score += 10
	quiz_controller.score_label.text = "Score: " + str(quiz_controller.score)
	quiz_controller.feedback_label.text = "Correct! +10 points"
	quiz_controller.feedback_label.add_color_override("font_color", Color(0, 1, 0))
	quiz_controller.feedback_label.show()
	button.add_color_override("font_color", Color(0, 1, 0))

func handle_wrong_answer(button):
	quiz_controller.lives -= 1
	quiz_controller.lives_label.text = "Lives: " + str(quiz_controller.lives)
	quiz_controller.feedback_label.text = "Incorrect! -1 life"
	quiz_controller.feedback_label.add_color_override("font_color", Color(1, 0, 0))
	quiz_controller.feedback_label.show()
	button.add_color_override("font_color", Color(1, 0, 0))
	
	# Highlight correct answer
	for btn in quiz_controller.option_buttons:
		if btn.text == current_questions[quiz_controller.current_question_index]["answer"]:
			btn.add_color_override("font_color", Color(0, 1, 0))
	
	if quiz_controller.lives <= 0:
		show_final_results()

func next_question():
	quiz_controller.current_question_index += 1
	show_question()

func show_final_results():
	for button in quiz_controller.option_buttons:
		button.hide()
	#next_button.hide()
	quiz_controller.question_label.hide()
	
	var final_message = """
	Quiz Complete!
	Final Score: %d
	Questions Correct: %d/%d
	""" % [quiz_controller.score, quiz_controller.score / 10, question_data.questions.size()]
	
	quiz_controller.feedback_label.text = final_message
	quiz_controller.feedback_label.show()
	
	# Create the menu button and store a reference to it
	menu_button = Button.new()
	menu_button.text = "Return to Menu"
	add_child(menu_button)
	menu_button.connect("pressed", self, "return_to_menu")

# Level 4 specific functions
func load_level4():
	var level4_words = question_data.get_level4_pairs()
	var korean_words = []
	var english_words = []
	
	for pair in level4_words:
		korean_words.append(pair["korean"])
		english_words.append(pair["english"])

	korean_words.shuffle()
	english_words.shuffle()

	# Clear previous connections
	for i in range(10):
		var button_path = "QuizContainer/GridContainer/MatchButton" + str(i+1)
		if quiz_controller.has_node(button_path):
			var button = quiz_controller.get_node(button_path)
			if button.is_connected("pressed", self, "_on_match_button_pressed"):
				button.disconnect("pressed", self, "_on_match_button_pressed")

	# Assign Korean words to the left column (buttons 1-5)
	for i in range(5):
		var button_path = "QuizContainer/GridContainer/MatchButton" + str(i+1)
		if quiz_controller.has_node(button_path):
			var button = quiz_controller.get_node(button_path)
			button.text = korean_words[i]
			button.connect("pressed", self, "_on_match_button_pressed", [button])

	# Assign English words to the right column (buttons 6-10)
	for i in range(5):
		var button_path = "QuizContainer/GridContainer/MatchButton" + str(i+6)
		if quiz_controller.has_node(button_path):
			var button = quiz_controller.get_node(button_path)
			button.text = english_words[i]
			button.connect("pressed", self, "_on_match_button_pressed", [button])

func _on_match_button_pressed(button):
	if button in selected_buttons:
		return  # Prevent selecting the same button twice

	selected_buttons.append(button)
	selected_words.append(button.text)
	
	# If two words are selected, check for a match
	if selected_words.size() == 2:
		check_match()

func check_match():
	if selected_words.size() != 2:
		return

	var first_word = selected_words[0]
	var second_word = selected_words[1]
	var level4_words = question_data.get_level4_pairs()

	var is_match = false
	for pair in level4_words:
		if (pair["korean"] == first_word and pair["english"] == second_word) or \
		   (pair["english"] == first_word and pair["korean"] == second_word):
			is_match = true
			break

	if is_match:
		for button in selected_buttons:
			button.hide()  # Hide the matched buttons
		quiz_controller.feedback_label.text = "Correct!"
		quiz_controller.feedback_label.add_color_override("font_color", Color(0, 1, 0))
	else:
		quiz_controller.feedback_label.text = "Try again!"
		quiz_controller.feedback_label.add_color_override("font_color", Color(1, 0, 0))

	quiz_controller.feedback_label.show()

	# Reset selection
	selected_buttons.clear()
	selected_words.clear()

	# Check if all pairs are matched
	if check_all_matched():
		show_final_results()

func check_all_matched():
	for i in range(10):
		var button_path = "QuizContainer/GridContainer/MatchButton" + str(i+1)
		if quiz_controller.has_node(button_path):
			var button = quiz_controller.get_node(button_path)
			if button.visible:
				return false
	return true
