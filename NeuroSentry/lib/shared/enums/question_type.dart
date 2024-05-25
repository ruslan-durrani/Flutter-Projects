enum QuestionType {
  mood('mood'),
  thoughts('thoughts'),
  sleep('sleep'),
  nutrition('nutrition');

  final String type;
  const QuestionType(this.type);

  factory QuestionType.fromString(String string) {
    return values.firstWhere((element) => element.type == string);
  }
}
