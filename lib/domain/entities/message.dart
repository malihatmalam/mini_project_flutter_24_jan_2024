class Message{
  String? username;
  String? text;
  String? timestamp;

  Message({ required this.username, required this.text, required this.timestamp});

  factory Message.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
      'username': String username,
      'text': String text,
      'timestamp' : String timestamp
      } => Message(username: username, text: text, timestamp: timestamp),
      _ => throw const FormatException('Gagal membuat message')
    };
  }

  Map<String, dynamic> toJson(){
    return {
      'username' : this.username,
      'text' : this.text,
      'timestamp': this.timestamp
    };
  }

}