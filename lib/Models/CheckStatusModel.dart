// To parse this JSON data, do
//
//     final checkStatusModel = checkStatusModelFromJson(jsonString);

import 'dart:convert';

CheckStatusModel? checkStatusModelFromJson(String str) => CheckStatusModel.fromJson(json.decode(str));

String checkStatusModelToJson(CheckStatusModel? data) => json.encode(data!.toJson());

class CheckStatusModel {
  CheckStatusModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  String? data;

  factory CheckStatusModel.fromJson(Map<String, dynamic> json) => CheckStatusModel(
    status: json["status"],
    message: json["message"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data,
  };
}
