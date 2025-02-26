extends Control

# Child nodes that will be assigned in the editor
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
onready var level_buttons = [
	$Level1Button,
	$Level2Button,
	$Level3Button,
	$Level4Button
]
onready var quiz_container = $QuizContainer
onready var grid_container = $QuizContainer/GridContainer

# Game state variables
var current_level = ""
var current_question_index = 0
var score = 0
var lives = 3
var quiz_started = false

# Load other scripts as dependencies
var question_data = preload("res://scripts/question_data.gd").new()
var ui_manager = preload("res://scripts/ui_manager.gd").new()
var level_manager = preload("res://scripts/level_manager.gd").new()

func _ready():
	randomize()
	ui_manager.init(self)
	level_manager.init(self, question_data)
	setup_level_buttons()
	ui_manager.hide_quiz_elements()

func setup_level_buttons():
	level_buttons[0].connect("pressed", self, "_on_level_pressed", ["level1"])
	level_buttons[1].connect("pressed", self, "_on_level_pressed", ["level2"])
	level_buttons[2].connect("pressed", self, "_on_level_pressed", ["level3"])
	level_buttons[3].connect("pressed", self, "_on_level_pressed", ["level4"])
	
	next_button.connect("pressed", self, "_on_next_pressed")
	for button in option_buttons:
		button.connect("pressed", self, "_on_option_pressed", [button])

func _on_level_pressed(level_name):
	for button in level_buttons:
		button.hide()
	
	ui_manager.show_quiz_elements()
	
	if level_name == "level4":
		ui_manager.show_grid_elements()
		for button in option_buttons:
			button.hide()
		level_manager.load_level4()
	else:
		level_manager.load_level(level_name)

func _on_option_pressed(button):
	level_manager.handle_answer(button)

func _on_next_pressed():
	level_manager.next_question()

func return_to_menu():
	# Reset game state
	current_question_index = 0
	score = 0
	lives = 3
	
	# Reset UI
	ui_manager.reset_ui()
	for button in level_buttons:
		button.show()
