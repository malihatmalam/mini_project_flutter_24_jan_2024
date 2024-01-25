import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/usecases/get_messages.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/user_room.dart';
import '../../domain/usecases/get_chat.dart';
import '../../domain/usecases/get_rooms.dart';

enum MenuItem{ logout }

class HomePageRevisi extends StatefulWidget {
  @override
  State<HomePageRevisi> createState() => _HomePageRevisiState();
}

class _HomePageRevisiState extends State<HomePageRevisi> {

  // Variable
  MenuItem? _selectMenuItem;
  late var box;


  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    box = Hive.box('user');
  }

  @override
  Widget build(BuildContext context) {
    String _username = box.get('username', defaultValue: '');
    if(box.get('isLogin', defaultValue: false) == false){
      context.go('/login');
    }
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Homepage'),
          actions: [
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              child: GestureDetector(
                  onTap: () {

                  },
                  child: Icon(Icons.camera_alt_rounded)
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              child: GestureDetector(
                  onTap: () {

                  },
                  child: Icon(Icons.search)
              ),
            ),
            Container(
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(5),
                child: PopupMenuButton<MenuItem>(
                    initialValue: _selectMenuItem,
                    itemBuilder: (context) => <PopupMenuEntry<MenuItem>>[
                      PopupMenuItem(
                        value: MenuItem.logout,
                        onTap: () {
                          box.put('isLogin', false);
                          box.put('username', '');
                          context.go('/login');
                        },
                        child:
                        Row(
                          children: [
                            Icon(Icons.logout),
                            Text('Keluar')
                          ],
                        ),
                      )]
                )
            )
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message),
                        Text(' Chat'),
                      ],
                    ),
                  )
              ),
              Tab(
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people),
                        Text(' Pembaharuan'),
                      ],
                    ),
                  )
              ),
              Tab(
                  child: Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.call),
                        Text(' Panggilan'),
                      ],
                    ),
                  )
              ),
            ],
          ),
        ),
        body: TabBarView(
            children: [
              Scaffold(
                body: FutureBuilder<UserRoom>(
                  future: GetRooms().execute(_username),
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      List? listRooms = snapshot.data!.room;
                      return Padding(
                        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                        child: Column(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: ListView(
                                      scrollDirection: Axis.vertical,
                                      children: List.generate(listRooms!.length, (index) {
                                        return FutureBuilder<ChatMessage>(
                                          future: GetMessage().execute(listRooms[index]),
                                          builder: (context, snapshot) {
                                            if(snapshot.hasData){
                                              var _users = snapshot.data!.users;
                                              var _messages = snapshot.data!.messages;
                                              var date = DateTime.fromMillisecondsSinceEpoch(_messages!.last.timestamp);
                                              String datetime = date.year.toString() + "/" + date.month.toString() + "/" + date.day.toString();
                                              return Card(
                                                margin: EdgeInsets.all(10),
                                                color: Colors.white70,
                                                elevation: 10.0,
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  margin: EdgeInsets.all(5),
                                                  child: ListTile(
                                                    leading: CircleAvatar(
                                                      child: Text('${_users[1][0]}'),
                                                    ),
                                                    title: Text(
                                                      '${_users[1]}',
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    subtitle: Text('${_messages?.last.text}'),
                                                    trailing: Text('${datetime}'),
                                                    onTap: () {
                                                      context.go('/chat/${listRooms[index]}');
                                                    },
                                                  ),
                                                ),
                                              );
                                            }else if(snapshot.hasError){
                                              return Text('${snapshot.error}');
                                            }else{
                                              return Text('');
                                            }
                                          },
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }else if(snapshot.hasError){
                      return Text('${snapshot.error}');
                    }else{
                      return Column(children: [CircularProgressIndicator()],);
                    }
                  },
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    context.go('/room');
                  },child: Icon(Icons.add),
                ),
              ),
              Center(
                child: Text('Status Chat'),
              ),
              Center(
                child: Text('Panggilan'),
              ),
            ]
        ),
      ),
    );
  }
}