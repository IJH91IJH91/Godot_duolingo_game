extends Control

var all_questions = {
	"level1": [
		{"question": "What is ㄱ?", "options": ["g", "n", "d"], "answer": "g", "explanation": "ㄱ looks like a Gun, g for gun"},
		{"question": "What is ㄴ?", "options": ["g", "n", "d"], "answer": "n", "explanation": "ㄴ its like a cartoon nose"},
		{"question": "What is ㄷ?", "options": ["g", "n", "d"], "answer": "d", "explanation": "ㄷ cartoon d*** "},
		{"question": "What is ㄹ?", "options": ["l", "m", "b"], "answer": "l", "explanation": "ㄹ le snake!"},
		{"question": "What is ㅁ?", "options": ["l", "m", "b"], "answer": "m", "explanation": "ㅁ its like a mouth"},
		{"question": "What is ㅂ?", "options": ["l", "m", "b"], "answer": "b", "explanation": "ㅂ its a Bucket of water"}
	],
	"level2": [
		{"question": "What is ㅅ?", "options": ["s", "silent", "j"], "answer": "s", "explanation": "ㅅ S-standing man"},
		{"question": "What is ㅇ?", "options": ["s", "silent", "j"], "answer": "silent", "explanation": "ㅇ no noise"},
		{"question": "What is ㅈ?", "options": ["s", "silent", "j"], "answer": "j", "explanation": "ㅈ no mnemonic "},
		{"question": "What is ㅊ?", "options": ["ch", "m", "b"], "answer": "ch", "explanation": "ㅊ  !"},
		{"question": "What is ㅋ?", "options": ["ch", "m", "b"], "answer": "k", "explanation": "ㅋ k kill"},
		{"question": "What is ㅌ?", "options": ["ch", "m", "b"], "answer": "t", "explanation": "ㅌ "},
		{"question": "What is ㅐ?", "options": ["s", "h", "p"], "answer": "p", "explanation": "ㅐ P for PART 2 "},
		{"question": "What is ㅎ?", "options": ["s", "h", "p"], "answer": "h", "explanation": "ㅎ h hat "}
	],
	"level3": [
		{"question": "What is ㅏ?", "options": ["a", "ya", "o"], "answer": "a", "explanation": "ㅏ  a "},
		{"question": "What is ㅑ?", "options": ["a", "ya", "o"], "answer": "ya", "explanation": "ㅑ  ya "},
		{"question": "What is ㅓ?", "options": ["o", "yo", "u"], "answer": "o", "explanation": "ㅓ  o "},
		{"question": "What is ㅕ?", "options": ["o", "yo", "u"], "answer": "yo", "explanation": "ㅕ  yo "},
		{"question": "What is ㅣ?", "options": ["ee", "a", "o"], "answer": "ee", "explanation": "ㅣ  ee "}
	],
	"level4": [
		{"korean": "사과", "english": "Apple"},
		{"korean": "물", "english": "Water"},
		{"korean": "책", "english": "Book"},
		{"korean": "고양이", "english": "Cat"},
		{"korean": "개", "english": "Dog"}
]
}

var current_level = ""
var questions = []  # This will hold the current level's questions
var current_question_index = 0
var score = 0
var lives = 3
var answered_questions = []
var quiz_started = false
var level4_words = []
var selected_buttons = []
var selected_words = []

onready var question_label = $QuizContainer/MarginContainer/QuestionLabel
onready var score_label = $QuizContainer/HBoxContainer/ScoreLabel
onready var lives_label = $QuizContainer/HBoxContainer/LivesLabel
onready var option_buttons = [
	$QuizContainer/VBoxContainer/Option1,
	$QuizContainer/VBoxContainer/Option2,
	$QuizContainer/VBoxContainer/Option3
]
onready var next_button = $QuizContainer/NextButton
onready var feedback_label = $QuizContainer/FeedbackLabel
onready var explanation_label = $QuizContainer/ExplanationLabel
onready var progress_bar = $QuizContainer/MarginContainer2/ProgressBar
onready var level1_button = $Level1Button
onready var level2_button = $Level2Button
onready var level3_button = $Level3Button
onready var level4_button = $Level4Button
onready var quiz_container = $QuizContainer
onready var grid_container = $QuizContainer/GridContainer

func _ready():
	randomize()
	setup_ui()
	hide_quiz_elements()  # Hide quiz elements initially
	level1_button.connect("pressed", self, "_on_level1_pressed")
	level2_button.connect("pressed", self, "_on_level2_pressed")
	level3_button.connect("pressed", self, "_on_level3_pressed")
	level4_button.connect("pressed", self, "_on_level4_pressed")

func setup_ui():
	score_label.text = "Score: 0"
	lives_label.text = "Lives: " + str(lives)
	next_button.hide()
	feedback_label.hide()
	explanation_label.hide()
	grid_container.hide()
	
	next_button.connect("pressed", self, "_on_next_pressed")
	for button in option_buttons:
		button.connect("pressed", self, "_on_option_pressed", [button])
	
	progress_bar.max_value = questions.size()
	progress_bar.value = 0

func hide_grid_elements():
	grid_container.hide()

func show_grid_elements():
	grid_container.show()

func hide_quiz_elements():
	quiz_container.hide()

func show_quiz_elements():
	quiz_container.show()

func load_level(level_name):
	current_level = level_name
	questions = all_questions[level_name]
	start_quiz()

func _on_level1_pressed():
	level1_button.hide()
	level2_button.hide()
	level3_button.hide()
	level4_button.hide()
	show_quiz_elements()
	load_level("level1")

func _on_level2_pressed():
	level1_button.hide()
	level2_button.hide()
	level3_button.hide()
	level4_button.hide()
	show_quiz_elements()
	load_level("level2")

func _on_level3_pressed():
	level1_button.hide()
	level2_button.hide()
	level3_button.hide()
	level4_button.hide()
	show_quiz_elements()
	load_level("level3")
	
func _on_level4_pressed():
	level1_button.hide()
	level2_button.hide()
	level3_button.hide()
	level4_button.hide()
	show_quiz_elements()
	show_grid_elements()
	for button in option_buttons:
		button.hide()
	load_level4()
	
func load_level4():
	print("Loading Level 4")  # Debugging

	level4_words = all_questions["level4"]  # Load correct words

	var korean_words = []
	var english_words = []
	
	for pair in level4_words:
		korean_words.append(pair["korean"])
		english_words.append(pair["english"])

	korean_words.shuffle()
	english_words.shuffle()  # Shuffle separately

	# Assign Korean words to the left column (buttons 1-5)
	for i in range(5):
		var path = "QuizContainer/GridContainer/MatchButton" + str(i+1)
		if has_node(path):
			var button = get_node(path)
			button.text = korean_words[i]
			button.connect("pressed", self, "_on_match_button_pressed", [button])
		else:
			print("Error: Could not find node", path)

	# Assign English words to the right column (buttons 6-10)
	for i in range(5):
		var path = "QuizContainer/GridContainer/MatchButton" + str(i+6)
		if has_node(path):
			var button = get_node(path)
			button.text = english_words[i]
			button.connect("pressed", self, "_on_match_button_pressed", [button])
		else:
			print("Error: Could not find node", path)

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

	var is_match = false
	for pair in level4_words:
		if (pair["korean"] == first_word and pair["english"] == second_word) or \
		   (pair["english"] == first_word and pair["korean"] == second_word):
			is_match = true
			break

	if is_match:
		for button in selected_buttons:
			button.hide()  # Hide the matched buttons
		feedback_label.text = "Correct!"
		feedback_label.add_color_override("font_color", Color(0, 1, 0))
	else:
		feedback_label.text = "Try again!"
		feedback_label.add_color_override("font_color", Color(1, 0, 0))

	feedback_label.show()

	# Reset selection
	selected_buttons.clear()
	selected_words.clear()

	# Check if all pairs are matched
	if check_all_matched():
		show_final_results()

func check_all_matched(): # If all buttons are hidden, the game is finished
	for i in range(10):
		var button = get_node("QuizContainer/GridContainer/MatchButton" + str(i+1))
		if button.visible:
			return false
	return true

func start_quiz():
	questions.shuffle()
	show_question()

func show_question():
	var question = questions[current_question_index]
	# Update UI
	question_label.text = question["question"]
	progress_bar.value = current_question_index
	# Shuffle options
	var shuffled_options = question["options"].duplicate()
	shuffled_options.shuffle()
	# Assign options to buttons
	for i in range(option_buttons.size()):
		option_buttons[i].text = shuffled_options[i]
		option_buttons[i].disabled = false
	# Reset feedback
	feedback_label.hide()
	explanation_label.hide()
	next_button.hide()

func _on_option_pressed(button):
	var selected_answer = button.text
	var question = questions[current_question_index]
	var correct_answer = question["answer"]
	# Disable all buttons
	for btn in option_buttons:
		btn.disabled = true
	
	if selected_answer == correct_answer:
		handle_correct_answer(button)
	else:
		handle_wrong_answer(button)
	# Show explanation
	explanation_label.text = question["explanation"]
	explanation_label.show()
	# Show next button if not last question
	if current_question_index < questions.size() - 1:
		next_button.show()
	else:
		show_final_results()

func handle_correct_answer(button):
	score += 10
	score_label.text = "Score: " + str(score)
	feedback_label.text = "Correct! +10 points"
	feedback_label.add_color_override("font_color", Color(0, 1, 0))
	feedback_label.show()
	button.add_color_override("font_color", Color(0, 1, 0))

func handle_wrong_answer(button):
	lives -= 1
	lives_label.text = "Lives: " + str(lives)
	feedback_label.text = "Incorrect! -1 life"
	feedback_label.add_color_override("font_color", Color(1, 0, 0))
	feedback_label.show()
	button.add_color_override("font_color", Color(1, 0, 0))
	
	# Highlight correct answer
	for btn in option_buttons:
		if btn.text == questions[current_question_index]["answer"]:
			btn.add_color_override("font_color", Color(0, 1, 0))
	
	if lives <= 0:
		show_final_results()

func _on_next_pressed():
	current_question_index += 1
	show_question()

func show_final_results():
	for button in option_buttons:
		button.hide()
	next_button.hide()
	question_label.hide()
	
	var final_message = """
	Quiz Complete!
	Final Score: %d
	Questions Correct: %d/%d
	""" % [score, score / 10, questions.size()]
	
	feedback_label.text = final_message
	feedback_label.show()
	
	var menu_button = Button.new()
	menu_button.text = "Return to Menu"
	add_child(menu_button)
	menu_button.connect("pressed", self, "return_to_menu")

func return_to_menu():
	#menu_button.queue_free()
	current_question_index = 0
	score = 0
	lives = 3
	answered_questions.clear()
	# Reset UI
	for button in option_buttons:
		button.show()
		button.disabled = false
		button.add_color_override("font_color", Color(1, 1, 1))
	
	question_label.show()
	level1_button.show()
	level2_button.show()
	level3_button.show()
	level4_button.show()
	quiz_container.hide()
	grid_container.hide()
