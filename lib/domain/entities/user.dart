class User{
  String? username;

  User({ required this.username  });

  factory User.fromJson(Map<String, dynamic> json){
    return switch(json){
      {
      'username': String username,
      } => User(username: username),
      _ => throw const FormatException('Gagal membuat user')
    };
  }

  Map<String, dynamic> toJson(){
    return {
      'username' : this.username,
    };
  }
}