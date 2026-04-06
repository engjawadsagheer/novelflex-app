// To parse this JSON data, do
//
//     final userStatusTypeModel = userStatusTypeModelFromJson(jsonString);

import 'dart:convert';

UserStatusTypeModel? userStatusTypeModelFromJson(String str) => UserStatusTypeModel.fromJson(json.decode(str));

String userStatusTypeModelToJson(UserStatusTypeModel? data) => json.encode(data!.toJson());

class UserStatusTypeModel {
  UserStatusTypeModel({
    this.status,
    this.success,
    this.data,
  });

  int? status;
  String? success;
  List<Datum?>? data;

  factory UserStatusTypeModel.fromJson(Map<String, dynamic> json) => UserStatusTypeModel(
    status: json["status"],
    success: json["success"],
    data: json["data"] == null ? [] : List<Datum?>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.type,
  });

  int? id;
  String? type;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
  };
}
