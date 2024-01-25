import 'package:mini_project_flutter_24_jan_2024/domain/entities/room.dart';

import '../../data/repository/chat_repository.dart';

class CreateRoom{
  var repository = ChatRepository();

  Future<String> execute(Rooms room){
    print(room.from);
    print(room.to);
    print('------------------');
    return repository.postRoomData(room);
  }
}