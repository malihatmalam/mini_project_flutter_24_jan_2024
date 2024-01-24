import 'package:mini_project_flutter_24_jan_2024/domain/entities/message.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/user.dart';

class ChatRoom{
  List<User> users;
  List<Message>? messages;

  ChatRoom({ required this.users, required this.messages});

  factory ChatRoom.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
      'users': List<User> users,
      'messages': List<Message> messages
      } => ChatRoom(users: users,messages: messages ),
      _ => throw const FormatException('Gagal membuat chat')
    };
  }

  Map<String, dynamic> toJson(){
    return {
      'users' : this.users,
      'messages' : this.messages
    };
  }

}