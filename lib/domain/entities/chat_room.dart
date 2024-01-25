import 'package:mini_project_flutter_24_jan_2024/domain/entities/message.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/user.dart';

class ChatRoom{
  List<Message>? messages;

  ChatRoom({required this.messages});

  factory ChatRoom.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
      'messages': List<Message> messages
      } => ChatRoom(messages: messages ),
      _ => throw const FormatException('Gagal membuat chat')
    };
  }

  Map<String, dynamic> toJson(){
    return {
      'messages' : this.messages
    };
  }

}