class User{
  final String id;
  final String name;
  final String email;
  final String notificationToken;
  List<String> userChatsList=[];

  User( {this.notificationToken="",required this.userChatsList, required this.id, required this.name, required this.email,});
}