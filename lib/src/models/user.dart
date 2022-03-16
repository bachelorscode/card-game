class MainUser {
  MainUser({
    required this.jwtToken,
    required this.user,
  });
  late final String jwtToken;
  late final User user;

  MainUser.fromJson(Map<String, dynamic> json) {
    jwtToken = json['jwtToken'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['jwtToken'] = jwtToken;
    _data['user'] = user.toJson();
    return _data;
  }
}

class User {
  User({
    required this.username,
    required this.password,
    required this.amount,
    required this.inBetting,
    required this.mobile,
    required this.active,
    required this.token,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String username;
  late final String password;
  late final int amount;
  late final int inBetting;
  late final String mobile;
  late final bool active;
  late final List<String> token;
  late final String id;
  late final String createdAt;
  late final String updatedAt;

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    amount = json['amount'];
    inBetting = json['inBetting'];
    mobile = json['mobile'];
    active = json['active'];
    token = json['token'] == null
        ? []
        : List.castFrom<dynamic, String>(json['token']);
    id = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['username'] = username;
    _data['password'] = password;
    _data['amount'] = amount;
    _data['inBetting'] = inBetting;
    _data['mobile'] = mobile;
    _data['active'] = active;
    _data['token'] = token;
    _data['_id'] = id;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}
