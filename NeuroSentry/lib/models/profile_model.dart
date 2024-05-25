class UserProfile {
  String profileId;
  String profileName;
  DateTime profileDoB;
  String profileGender;
  String? profilePic;
  int followerCount;
  int followingCount;
  int? todayNutritionScore;
  int? todaySleepScore;
  int? todayMoodScore;
  int? todayThoughtsScore;
  DateTime? todayCompletionDateTime;
  double? averageScore;
  List<dynamic> followingUids;
  List<dynamic> bookMarkPosts;
  List<dynamic> bookMarkArticles;

  UserProfile({
    required this.profileId,
    required this.profileName,
    required this.profileDoB,
    required this.profileGender,
    this.followerCount = 0,
    this.followingCount = 0,
    this.profilePic,
    this.todayNutritionScore,
    this.todaySleepScore,
    this.todayMoodScore,
    this.todayThoughtsScore,
    this.todayCompletionDateTime,
    this.averageScore,
    required this.followingUids,
    required this.bookMarkPosts,
    this.bookMarkArticles = const [],
  });

  // Factory method to create a UserProfile object from a map
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      profileId: map['profileId'],
      profileName: map['profileName'],
      profileDoB: DateTime.parse(map['profileDoB']),
      profileGender: map['profileGender'],
      profilePic: map['profilePic'],
      followerCount: map['followerCount'] ?? 0,
      followingCount: map['followingCount'] ?? 0,
      todayNutritionScore: map['todayNutritionScore'],
      todaySleepScore: map['todaySleepScore'],
      todayMoodScore: map['todayMoodScore'],
      todayThoughtsScore: map['todayThoughtsScore'],
      todayCompletionDateTime: map['todayCompletionDateTime'] != null
          ? DateTime.parse(map['todayCompletionDateTime'])
          : null,
      averageScore: map['averageScore'] != null
          ? double.parse(map['averageScore'].toString())
          : null,
      followingUids: map['followingUids'] ?? [],
      bookMarkPosts: map['bookMarkPosts'] ?? [],
      bookMarkArticles: map['bookMarkArticles'] ?? [],
    );
  }

  // Method to convert UserProfile object to a map
  Map<String, dynamic> toMap() {
    return {
      'profileId': profileId,
      'profileName': profileName,
      'profileDoB': profileDoB.toIso8601String(),
      'profileGender': profileGender,
      'profilePic': profilePic,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'todayNutritionScore': todayNutritionScore,
      'todaySleepScore': todaySleepScore,
      'todayMoodScore': todayMoodScore,
      'todayThoughtsScore': todayThoughtsScore,
      'todayCompletionDateTime': todayCompletionDateTime?.toIso8601String(),
      'averageScore': averageScore,
      'followingUids': followingUids,
      'bookMarkPosts': bookMarkPosts,
      'bookMarkArticles': bookMarkArticles,
    };
  }
}
