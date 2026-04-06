// To parse this JSON data, do
//
//     final authorProfileEditModel = authorProfileEditModelFromJson(jsonString);

import 'dart:convert';

AuthorProfileEditModel authorProfileEditModelFromJson(String str) => AuthorProfileEditModel.fromJson(json.decode(str));

String authorProfileEditModelToJson(AuthorProfileEditModel data) => json.encode(data.toJson());

class AuthorProfileEditModel {
  AuthorProfileEditModel({
    required this.status,
    required this.data,
  });

  int status;
  Data data;

  factory AuthorProfileEditModel.fromJson(Map<String, dynamic> json) => AuthorProfileEditModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.type,
    required this.profilePhoto,
    required this.description,
    required this.registerdDate,
    required this.profilePath,
    required this.backgroundPath,
  });

  int id;
  String username;
  String email;
  String phone;
  String type;
  dynamic profilePhoto;
  String description;
  DateTime registerdDate;
  String profilePath;
  String backgroundPath;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    phone: json["phone"],
    type: json["type"],
    profilePhoto: json["profile_photo"],
    description: json["description"],
    registerdDate: DateTime.parse(json["registerd_date"]),
    profilePath: json["profile_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "phone": phone,
    "type": type,
    "profile_photo": profilePhoto,
    "description": description,
    "registerd_date": registerdDate.toIso8601String(),
    "profile_path": profilePath,
    "background_path": backgroundPath,
  };
}
