class Message{
  String? username;
  String? text;
  int timestamp;

  Message({ required this.username, required this.text, required this.timestamp});

  factory Message.fromJson(dynamic json) {
    return Message(
        username : json['username'] as String,
        text : json['text'] as String,
        timestamp: int.parse(json['timestamp']) as int
    );
  }

  @override
  String toString() {
    return '{ ${this.username}, ${this.text}, ${this.timestamp} }';
  }

  // factory Message.fromJson(Map<String, dynamic> json){
  //   print('sedang di masukin');
  //   return switch(json){
  //     {
  //     'username': String username,
  //     'text': String text,
  //     'timestamp' : String timestamp
  //     } => Message(username: username, text: text, timestamp: timestamp),
  //     _ => throw const FormatException('Gagal membuat message')
  //   };
  // }

  Map<String, dynamic> toJson(){
    return {
      'username' : this.username,
      'text' : this.text,
      'timestamp': this.timestamp
    };
  }

}