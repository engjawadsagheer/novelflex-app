// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  UserModel({
    required this.status,
    required this.user,
  });

  int status;
  User user;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    status: json["status"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "user": user.toJson(),
  };
}

class User {
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.accessToken,
    required this.image,
    required this.expiredDays,
    required this.googleLogin,
  });

  int id;
  String username;
  String email;
  dynamic phone;
  String accessToken;
  dynamic image;
  int expiredDays;
  bool googleLogin;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    phone: json["phone"],
    accessToken: json["access_token"],
    image: json["image"],
    expiredDays: json["expired_days"],
    googleLogin: json["google_login"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "phone": phone,
    "access_token": accessToken,
    "image": image,
    "expired_days": expiredDays,
    "google_login": googleLogin,
  };
}
