class GoalModel {
  final String title;
  final String img;
  final List<String> goals;
  GoalModel({required this.title, required this.img, required this.goals});
  static List<GoalModel> goalList = [
    GoalModel(
        title: "Get Fit",
        img: 'assets/images/training.png',
        goals: ['short execise', 'long exercise', 'run', 'walk', 'bike']),
    GoalModel(title: "Better Sleep", img: 'assets/images/sleep.png', goals: [
      'sleep 8 hrs',
      'light dinner',
      'no late coffee',
      'no screen before sleep',
      'fixed bedtime'
    ]),
    GoalModel(
        title: "Break Bad Habits",
        img: 'assets/images/bad-habits.png',
        goals: [
          'no smoking',
          'no alcohol',
          'limit social media',
          'no late night',
          'limit tv'
        ]),
    GoalModel(title: "Get Healthy", img: 'assets/images/diet.png', goals: [
      'no soda',
      'no sweet',
      'no fast food',
      'drink water',
      'no overeating'
    ]),
    GoalModel(
        title: "Reduce Stress",
        img: 'assets/images/fear.png',
        goals: ['meditation', 'laugh', 'outdoor time', 'be grateful', 'rest']),
    GoalModel(
        title: "Build Habits",
        img: 'assets/images/bad-habits.png',
        goals: [
          'make bed',
          'wash face',
          'brush teeth',
          'wake early',
          'take shower'
        ]),
  ];
}
