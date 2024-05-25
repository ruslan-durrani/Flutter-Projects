class PostModel {
  String postUid;
  String? imageUrl;
  String profileUid;
  String? profilePic;
  String userName;
  String description;
  DateTime postTime;
  int likes;
  int commentCount;
  List<dynamic> likesProfileUid;
  bool isGroupShare;
  String? groupUid;

  PostModel({
    required this.postUid,
    this.imageUrl,
    required this.profileUid,
    this.profilePic,
    required this.userName,
    required this.description,
    required this.postTime,
    required this.likes,
    required this.commentCount,
    required this.likesProfileUid,
    required this.isGroupShare,
    this.groupUid,
  });

  factory PostModel.fromMap(Map map) {
    return PostModel(
        postUid: map['postUid'],
        profileUid: map['profileUid'],
        userName: map['userName'],
        description: map['description'],
        postTime: DateTime.parse(map['postTime']),
        likes: map['likes'],
        commentCount: map['commentCount'],
        imageUrl: map['imageUrl'],
        profilePic: map['profilePic'],
        likesProfileUid: map['likesProfileUid'],
        isGroupShare: map['isGroupShare'] ?? false,
        groupUid: map['groupUid']);
  }

  Map<String, dynamic> toMap() {
    return {
      'postUid': postUid,
      'profileUid': profileUid,
      'userName': userName,
      'description': description,
      'postTime': postTime.toIso8601String(),
      'likes': likes,
      'commentCount': commentCount,
      'imageUrl': imageUrl,
      'profilePic': profilePic,
      'likesProfileUid': likesProfileUid,
      'isGroupShare': isGroupShare,
      'groupUid': groupUid,
    };
  }
}
