class User {
  String? get id => _id;
  String? username;
  String? photoUrl;
  String? _id;
  bool? active;
  DateTime? lastseen;

  User(
      {required String username,
      required String photoUrl,
      required bool active,
      required DateTime lastseen});

  toJson() => {
        'username': username,
        'photoUrl': photoUrl,
        'active': active,
        'lastseen': lastseen,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    final user = User(
      username: json['username'],
      photoUrl: json['photoUrl'],
      active: json['active'],
      lastseen: json['lastseen'],
    );
    user._id = json['_id'];
    return user;
  }
}
