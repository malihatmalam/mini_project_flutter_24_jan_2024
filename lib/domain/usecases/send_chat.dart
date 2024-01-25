import 'package:mini_project_flutter_24_jan_2024/domain/entities/chat.dart';

import '../../data/repository/chat_repository.dart';

class SendChat{
  var repository = ChatRepository();

  Future<bool> execute(Chat message){
    print(message.username);
    print(message.text);
    print(message.id);
    print('------------------');
    return repository.postSendMessage(message);
  }
}