class Room{
  String? from;
  String? to;

  Room({ required this.from, required this.to});

  factory Room.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
      'from': String from,
      'to': String to
      } => Room(from: from, to: to),
      _ => throw const FormatException('Gagal membuat room')
    };
  }

  Map<String, dynamic> toJson(){
    return {
      'from' : this.from,
      'to' : this.to
    };
  }

}