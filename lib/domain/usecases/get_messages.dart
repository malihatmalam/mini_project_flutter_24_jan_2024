
import 'package:mini_project_flutter_24_jan_2024/domain/entities/chat_message.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/chat_room.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/message.dart';

import '../../data/repository/chat_repository.dart';

class GetMessage{
  var repository = ChatRepository();

  Future<ChatMessage> execute(room_id)  async {
    // print(repository.getMessageChat(room_id));
    try {
      return repository.getMessageChat(room_id);
    } on Exception catch (e) {
      // Anything else that is an exception
      print('Unknown exception: $e');
      return ChatMessage(users: [], messages: []);
    } catch (e) {
      // No specified type, handles all
      print('Something really unknown: $e');
      Message message = Message(username: null, text: null, timestamp: 0);
      return ChatMessage(users: [], messages: [message]);
    }

  }
}