// To parse this JSON data, do
//
//     final userPaymentModel = userPaymentModelFromJson(jsonString);

import 'dart:convert';

UserPaymentModel? userPaymentModelFromJson(String str) => UserPaymentModel.fromJson(json.decode(str));

String userPaymentModelToJson(UserPaymentModel? data) => json.encode(data!.toJson());

class UserPaymentModel {
  UserPaymentModel({
    this.status,
    this.success,
    this.totalAmount,
  });

  int? status;
  String? success;
  String? totalAmount;

  factory UserPaymentModel.fromJson(Map<String, dynamic> json) => UserPaymentModel(
    status: json["status"],
    success: json["success"],
    totalAmount: json["totalAmount"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success,
    "totalAmount": totalAmount,
  };
}
