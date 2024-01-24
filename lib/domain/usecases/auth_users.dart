
import 'package:mini_project_flutter_24_jan_2024/data/repository/chat_repository.dart';

import '../entities/user_room.dart';

class AuthUser{
  String? _username;
  var repository = ChatRepository();

  Future<bool> execute(username)  async {
    Future<UserRoom> data = repository.getRoom(username);
    UserRoom user = await data;
    print(user.room);
    if(user.room?.length == 0){
      return false;
    }else{
      return true;
    }
  }

}