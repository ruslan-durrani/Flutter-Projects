class CommentModel {
  String userName;
  String commentUid;
  String postUid;
  String profileUid;
  String? profilePic;
  String comment;
  int likes;
  List<dynamic> likesProfileUid;

  CommentModel({
    required this.userName,
    required this.commentUid,
    required this.postUid,
    required this.profileUid,
    this.profilePic,
    required this.comment,
    required this.likes,
    required this.likesProfileUid,
  });

  factory CommentModel.fromMap(Map map) {
    return CommentModel(
      userName: map['userName'],
      commentUid: map['commentUid'],
      postUid: map['postUid'],
      profileUid: map['profileUid'],
      comment: map['comment'],
      profilePic: map['profilePic'],
      likes: map['likes'],
      likesProfileUid: map['likesProfileUid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'commentUid': commentUid,
      'postUid': postUid,
      'profileUid': profileUid,
      'comment': comment,
      'profilePic': profilePic,
      'likes': likes,
      'likesProfileUid': likesProfileUid,
    };
  }
}
