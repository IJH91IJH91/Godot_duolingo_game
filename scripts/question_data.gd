extends Reference

# All quiz questions and answers
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

# Returns shuffled questions for a specific level
func get_questions(level_name):
	var questions = all_questions[level_name].duplicate()
	questions.shuffle()
	return questions

# Returns matching pairs for level 4
func get_level4_pairs():
	return all_questions["level4"]
