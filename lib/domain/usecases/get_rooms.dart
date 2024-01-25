
import '../../data/repository/chat_repository.dart';
import '../entities/user_room.dart';


class GetRooms{
  var repository = ChatRepository();

  Future<UserRoom> execute(username)  async {
    return repository.getRoom(username);
  }
}