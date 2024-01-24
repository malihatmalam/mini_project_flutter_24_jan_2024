
import 'package:mini_project_flutter_24_jan_2024/domain/entities/chat_room.dart';

import '../../data/repository/chat_repository.dart';

class GetChat{
  var repository = ChatRepository();

  Future<ChatRoom> execute(room_id)  async {
    return repository.getChat(room_id);
  }
}