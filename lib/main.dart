import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/entities/chat_room.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/usecases/auth_users.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/usecases/get_chat.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/usecases/get_rooms.dart';

import 'domain/entities/user_room.dart';

final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          name: 'homepage',
          path: '/',
        builder: (context, state) => ChatPage(),
        // builder: (context, state) => HomePage(),
      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        name: 'chat',
        path: '/chat',
        builder: (context, state) => ChatPage(),
      ),
    ]
);


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('user');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Mini Project Chat',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late var box;
  @override
  void initState() {
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
              child: GestureDetector(
                  onTap: () {

                  },
                  child: Icon(Icons.menu)
              ),
            ),
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
                                  backgroundImage: NetworkImage('https://picsum.photos/250?image=9'),
                                ),
                                title: Text(
                                  '${listRooms[index]}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                onTap: () {

                                },
                              ),
                            ),
                          );
                        }),
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

class LoginPage extends StatefulWidget{
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  // Variable
  GlobalKey<FormState> _loginform = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();

  // Local database
  var box = Hive.box('user');

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Loginpage', style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 300,
                width: 300,
                child: Image(
                    image: AssetImage('image/login.jpg')
                )
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: _loginform,
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if(value!.length == 0) {
                            return 'Username tidak boleh kosong!';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            print('dicoba');
                            if (_loginform.currentState!.validate()) {
                              if(await AuthUser().execute(_usernameController.text)) {
                                print('dicoba');
                                box.put('isLogin', true);
                                box.put('username', _usernameController.text);

                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Berhasil masuk')
                                    )
                                );
                                context.go('/');
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Username tidak ditemukan')
                                    )
                                );
                              }
                            } else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ada yang salah bro')
                                  )
                              );
                            }
                          },
                          child: Text('Masuk')
                      )
                    ],
                  ),
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatPage extends StatefulWidget{
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{
  // Variable
  late String? _roomId = '8SFkk';

  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Room : ${_roomId}'),
      ),
      body: FutureBuilder<ChatRoom>(
        future: GetChat().execute('${_roomId}'),
        builder: (context, snapshot) {
        if(snapshot.hasData){
          List? _messages = snapshot.data!.messages;
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: _messages?.length,
                  itemBuilder: (context, index) {
                    // var message = messages[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${_messages?[index].username.toUpperCase()}'),
                      ),
                      title: Text('${_messages?[index].username} : ${_messages?[index].text}'),
                      // subtitle: Text('Timestamp: ${message['timestamp']}'),
                      subtitle: Text('Timestamp: ${_messages?[index].timestamp}'),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: _messageController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Message',
                  ),
                ),
              ),
              ElevatedButton(
                child: const Text('Send'),
                onPressed: () {

                },
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
    );
  }
}

