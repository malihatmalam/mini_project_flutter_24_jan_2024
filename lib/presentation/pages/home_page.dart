import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/user_room.dart';
import '../../domain/usecases/get_rooms.dart';

enum MenuItem{ logout }

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
              FutureBuilder<UserRoom>(
                future: GetRooms().execute(_username),
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    List? listRooms = snapshot.data!.room;
                    return Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: List.generate(listRooms!.length, (index) {
                                return Card(
                                  margin: EdgeInsets.all(10),
                                  color: Colors.white70,
                                  elevation: 10.0,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    margin: EdgeInsets.all(5),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child: Text('${listRooms[index][0]}'),
                                      ),
                                      title: Text(
                                        '${listRooms[index]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      onTap: () {
                                        context.go('/chat/${listRooms[index]}');
                                      },
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                          Expanded(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: FloatingActionButton(
                                  onPressed: () {
                                    context.go('/room');
                                  },child: Icon(Icons.add),
                                ),
                              )
                          )
                        ],
                      ),
                    );
                  }else if(snapshot.hasError){
                    return Text('${snapshot.error}');
                  }else{
                    return Text('Belum ada data');
                  }
                },
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