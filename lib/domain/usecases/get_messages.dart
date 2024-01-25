
import 'package:mini_project_flutter_24_jan_2024/domain/entities/chat_message.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/chat_room.dart';

import '../../data/repository/chat_repository.dart';

class GetMessage{
  var repository = ChatRepository();

  Future<ChatMessage> execute(room_id)  async {
    // print(repository.getMessageChat(room_id));
    return repository.getMessageChat(room_id);
  }
}