// To parse this JSON data, do
//
//     final statusCheckModel = statusCheckModelFromJson(jsonString);

import 'dart:convert';

StatusCheckModel statusCheckModelFromJson(String str) => StatusCheckModel.fromJson(json.decode(str));

String statusCheckModelToJson(StatusCheckModel data) => json.encode(data.toJson());

class StatusCheckModel {
  StatusCheckModel({
    required this.status,
    required this.data,
    required this.aggrement,
  });

  int status;
  Data data;
  bool aggrement;

  factory StatusCheckModel.fromJson(Map<String, dynamic> json) => StatusCheckModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
    aggrement: json["aggrement"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
    "aggrement": aggrement,
  };
}

class Data {
  Data({
    required this.id,
    required this.type,
    required this.checkStatus,
    required this.profilePath,
    required this.backgroundPath,
  });

  int id;
  String type;
  String checkStatus;
  String profilePath;
  String backgroundPath;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    type: json["type"],
    checkStatus: json["check_status"],
    profilePath: json["profile_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "check_status": checkStatus,
    "profile_path": profilePath,
    "background_path": backgroundPath,
  };
}
