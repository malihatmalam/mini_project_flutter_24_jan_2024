

import 'dart:convert';

import 'package:mini_project_flutter_24_jan_2024/data/datasource/chat_api_data_source.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/chat_room.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/message.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/user.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/user_room.dart';

class ChatRepository{
  ChatApiDataSource chatApiDataSource = ChatApiDataSource();

  Future<UserRoom> getRoom(String username) async {
    var jsonArray = jsonDecode(await chatApiDataSource.getUserData(username))['data']['rooms'];
    List listRoom = jsonArray;
    return UserRoom(username: username, room: listRoom);
  }

  Future<ChatRoom> getChat(String room_id) async {
    var jsonArrayUsers = jsonDecode(await chatApiDataSource.getChatData(room_id))['data']['users'];
    var jsonArrayMessages = jsonDecode(await chatApiDataSource.getChatData(room_id))['data']['messages'];
    List<User> listUser = <User>[];
    List<Message> listMessage = <Message>[];

    // print(jsonArrayMessages);
    // Users
    for(var index = 0; index < jsonArrayUsers.length; index){
      listUser.add(User(username: jsonArrayUsers[index]));
    }

    // Messages
    for(var index = 0; index < jsonArrayMessages.length; index){
      listMessage.add(Message.fromJson(jsonArrayMessages[index]));
    }
    print(listMessage);

    return ChatRoom(users: listUser, messages: listMessage);
  }



}