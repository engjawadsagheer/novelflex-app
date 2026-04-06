// To parse this JSON data, do
//
//     final menuProfileModel = menuProfileModelFromJson(jsonString);

import 'dart:convert';

MenuProfileModel menuProfileModelFromJson(String str) => MenuProfileModel.fromJson(json.decode(str));

String menuProfileModelToJson(MenuProfileModel data) => json.encode(data.toJson());

class MenuProfileModel {
  MenuProfileModel({
    required this.status,
    required this.data,
  });

  int status;
  Data data;

  factory MenuProfileModel.fromJson(Map<String, dynamic> json) => MenuProfileModel(
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
    required this.registerdDate,
    required this.totalAmount,
    required this.profilePath,
    required this.backgroundPath,
  });

  int id;
  String username;
  String email;
  dynamic phone;
  String type;
  dynamic profilePhoto;
  DateTime registerdDate;
  int totalAmount;
  String profilePath;
  String backgroundPath;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    phone: json["phone"],
    type: json["type"],
    profilePhoto: json["profile_photo"],
    registerdDate: DateTime.parse(json["registerd_date"]),
    totalAmount: json["total_amount"],
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
    "registerd_date": registerdDate.toIso8601String(),
    "total_amount": totalAmount,
    "profile_path": profilePath,
    "background_path": backgroundPath,
  };
}
