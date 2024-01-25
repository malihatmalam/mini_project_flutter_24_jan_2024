import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/room.dart';
import '../../domain/usecases/create_room.dart';

class AddRoomPage extends StatefulWidget{
  @override
  State<AddRoomPage> createState() => _AddRoomPageState();

}

class _AddRoomPageState extends State<AddRoomPage> {
  // Variable
  GlobalKey<FormState> _formRoom = GlobalKey<FormState>();
  TextEditingController _destinationController = TextEditingController();

  late var box;


  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    box = Hive.box('user');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Percakapan'),
        leading: GestureDetector(
          onTap: () {
            return context.go('/');
          },
          child: Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        alignment: Alignment.bottomCenter,
        child: Form(
          key: _formRoom,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 20),
                alignment: Alignment.topCenter,
                child:
                TextFormField(
                  controller: _destinationController,
                  decoration: InputDecoration(
                    labelText: 'Username Tujuan',
                    border: OutlineInputBorder(),
                  ),validator: (value) {
                  if(value!.length == 0){
                    return 'Tujuan tidak boleh kosong';
                  } else if(value == box.get('username')){
                    return 'Tidak boleh mengirim ke diri sendiri';
                  }
                  else {
                    return null;
                  }
                },
                ),
              ),
              Spacer(),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          onPressed: () async {
                            print('dicoba');
                            if (_formRoom.currentState!.validate()) {
                              Rooms _room = Rooms(
                                from: box.get('username'),
                                to: _destinationController.text,
                              );
                              print(_room);
                              String _newRoom = await CreateRoom().execute(_room);
                              context.go('/chat/${_newRoom}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Berhasil membuat percakapan baru')
                                  )
                              );
                            } else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ada yang salah bro')
                                  )
                              );
                            }
                          },
                          child: Expanded(
                            child: Text('Lanjutkan'),
                          ),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}