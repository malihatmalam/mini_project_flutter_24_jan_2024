import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mini_project_flutter_24_jan_2024/domain/usecases/create_room.dart';
import 'package:mini_project_flutter_24_jan_2024/presentation/pages/add_room_page.dart';
import 'package:mini_project_flutter_24_jan_2024/presentation/pages/chat_page.dart';
import 'package:mini_project_flutter_24_jan_2024/presentation/pages/home_page.dart';
import 'package:mini_project_flutter_24_jan_2024/presentation/pages/home_page2.dart';
import 'package:mini_project_flutter_24_jan_2024/presentation/pages/login_page.dart';

import 'domain/entities/room.dart';

final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          name: 'homepage',
          path: '/',
        // builder: (context, state) => ChatPage(),
        //   builder: (context, state) => HomePage(),
          builder: (context, state) => HomePageRevisi(),

      ),
      GoRoute(
        name: 'login',
        path: '/login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        name: 'chat',
        path: '/chat/:room_id',
        builder: (context, state) {
          var room_id = state.pathParameters['room_id'];
          return ChatPage(room_id);
        }
      ),
      GoRoute(
          name: 'room',
          path: '/room',
          builder: (context, state) {
            return AddRoomPage();
          }
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
      debugShowCheckedModeBanner: false,
    );
  }
}



