import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/chat.dart';
import '../../domain/entities/chat_room.dart';
import '../../domain/usecases/get_chat.dart';
import '../../domain/usecases/send_chat.dart';

class ChatPage extends StatefulWidget{
  late String? roomId;
  ChatPage(this.roomId);

  @override
  State<ChatPage> createState() => _ChatPageState(roomId);
}

class _ChatPageState extends State<ChatPage>{
  // Variable
  // String? roomId = '8SFkk';

  late var box;

  String? _roomId;

  _ChatPageState(this._roomId);
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    box = Hive.box('user');
  }

  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
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
            flex: 1,
            child: FutureBuilder<ChatRoom>(
              future: GetChat().execute(_roomId),
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  var _messages = snapshot.data!.messages;
                  return
                    Column(
                      children: <Widget>[
                        Expanded(
                          child: ListView(
                            children: List.generate(_messages!.length, (index) {
                              bool _part = _messages[index].username == box.get('username');
                              var date = DateTime.fromMillisecondsSinceEpoch(_messages[index].timestamp);
                              String datetime = date.hour.toString() + " : " + date.minute.toString() + "  " + date.day.toString() + "/" + date.month.toString() + "/" + date.year.toString()  ;
                              return
                                Bubble(
                                  margin: BubbleEdges.only(top: 10),
                                  nip: _part ? BubbleNip.rightTop : BubbleNip.leftTop,
                                  alignment: _part ? Alignment.topRight : Alignment.topLeft,
                                  color: _part ? Colors.lightBlueAccent : Colors.white70,
                                  child: Expanded(
                                    child: Align(
                                      alignment: _part ? Alignment.topRight : Alignment.topLeft,
                                      child: Column(
                                        children: [
                                          Text('${_messages[index].username}', style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          )),
                                          Text('${_messages[index].text}', textAlign: TextAlign.right),
                                          Text('${datetime}', style: TextStyle(fontSize: 10)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            ),
                          ),
                        ),
                      ],
                    );
                }
                else if(snapshot.hasError){
                  return Text('${snapshot.error}');
                }else{
                  return Text('Belum ada data');
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
                    onPressed: () {
                      setState(() {
                        Chat message = Chat(
                            id: _roomId,
                            username: box.get('username'),
                            text: _messageController.text
                        );
                        SendChat().execute(message);
                      });
                    },
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