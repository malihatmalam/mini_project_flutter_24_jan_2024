import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/chat.dart';
import '../../domain/entities/chat_room.dart';
import '../../domain/usecases/get_chat.dart';
import '../../domain/usecases/send_chat.dart';

@immutable
class ChatPage extends StatefulWidget{
  late String? roomId;
  ChatPage(this.roomId);

  @override
  State<ChatPage> createState() => _ChatPageState(roomId);
}

class _ChatPageState extends State<ChatPage>{
  // Variable
  TextEditingController _messageController = TextEditingController();
  bool _isButtonActive = false;
  late var box;

  String? _roomId;

  _ChatPageState(this._roomId);
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    box = Hive.box('user');
    _messageController.addListener(() {
      setState(() {
        _isButtonActive = _messageController.text.isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var _userDestination = box.get('usernameDestination', defaultValue: '');
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              child: Text('${_userDestination[0]}'),
            ),
            SizedBox(
              width: 10,
            ),
            Text('${_userDestination}'),
          ],
        ),
        leading: GestureDetector(
          onTap: () {
            return context.go('/');
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child:
            FutureBuilder<ChatRoom>(
              future: GetChat().execute(_roomId),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  var _messages = snapshot.data!.messages;
                  return
                    ListView(
                      children: List.generate(_messages!.length, (index) {
                        bool _part = _messages[index].username == box.get('username');
                        var date = DateTime.fromMillisecondsSinceEpoch(_messages[index].timestamp);
                        String datetime = date.hour.toString() + " : " + date.minute.toString() + "  " + date.day.toString() + "/" + date.month.toString() + "/" + date.year.toString()  ;
                        return
                          Column(
                            children: [
                              Bubble(
                                margin: BubbleEdges.only(left:10,top: 10, right: 10, bottom: 5),
                                nip: _part ? BubbleNip.rightTop : BubbleNip.leftTop,
                                alignment: _part ? Alignment.topRight : Alignment.topLeft,
                                color: _part ? Colors.lightBlueAccent : Colors.white70,
                                child: Column(
                                  crossAxisAlignment: _part ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Text('${_messages[index].text}', textAlign: TextAlign.right),
                                    Text('${datetime}', style: TextStyle(fontSize: 10), textAlign: TextAlign.right),
                                  ],
                                ),
                              ),
                            ],
                          );
                      }
                      ),
                    );
                }
                else if(snapshot.hasError){
                  return Text('${snapshot.error}');
                }else{
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Message',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _isButtonActive ? () {
                      setState(() {
                        Chat message = Chat(
                            id: _roomId,
                            username: box.get('username'),
                            text: _messageController.text
                        );
                        SendChat().execute(message);
                        _messageController.text = '';
                      });
                    } : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}