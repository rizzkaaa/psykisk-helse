class Question {
  final String text;
  final List<String> options;

  Question({required this.text, required this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['text'],
      options: List<String>.from(json['options']),
    );
  }
}