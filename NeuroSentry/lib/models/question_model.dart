class Question {
  String text;
  List<OptionModel> options;

  Question({
    required this.text,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      text: json['text'],
      options: List<OptionModel>.from(
          json['options'].map((option) => OptionModel.fromJson(option))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'options': options.map((option) => option.toJson()).toList(),
    };
  }
}

class OptionModel {
  String name;
  int points;

  OptionModel({
    required this.name,
    required this.points,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      name: json['name'],
      points: json['points'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'points': points,
    };
  }
}
