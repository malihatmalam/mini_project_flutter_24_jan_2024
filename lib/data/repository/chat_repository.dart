

import 'dart:convert';

import 'package:mini_project_flutter_24_jan_2024/data/datasource/chat_api_data_source.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/chat_message.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/chat_room.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/message.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/user_room.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import '../../domain/entities/chat.dart';

class ChatRepository{
  ChatApiDataSource chatApiDataSource = ChatApiDataSource();

  Future<UserRoom> getRoom(String username) async {
    var jsonArray = jsonDecode(await chatApiDataSource.getUserData(username))['data']['rooms'];
    List listRoom = jsonArray;
    print(listRoom);
    listRoom.sort((a, b) => b.compareTo(a));
    print(listRoom);
    return UserRoom(username: username, room: listRoom);
  }

  Future<ChatRoom> getChat(String room_id) async {
    var jsonArrayMessages = jsonDecode(await chatApiDataSource.getChatData(room_id))['data']['messages'] as List;
    List<Message> listMessage = jsonArrayMessages.map((message) => Message.fromJson(message)).toList();
    return ChatRoom(messages: listMessage);
  }

  Future<ChatMessage> getMessageChat(String room_id) async {
    List jsonArrayUsers = jsonDecode(await chatApiDataSource.getChatData(room_id))['data']['users'] as List;
    var jsonArrayMessages = jsonDecode(await chatApiDataSource.getChatData(room_id))['data']['messages'] as List;
    List<Message> listMessage = jsonArrayMessages.map((message) => Message.fromJson(message)).toList();
    return ChatMessage(users: jsonArrayUsers,messages: listMessage);
  }

  Future<bool> postSendMessage(Chat chat) async {
    var response = await chatApiDataSource.postChatData(chat.toJson());
    return jsonDecode(response)['data'];
  }

  Future<String> postRoomData(room) async {
    var response = await chatApiDataSource.postRoomData(room.toJson());
    return jsonDecode(response)['data']['id'];
  }

}