import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/usecases/auth_users.dart';

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
          color: Colors.white70,
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
                            child: Text('Masuk'),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size.fromHeight(50),
                            ),
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