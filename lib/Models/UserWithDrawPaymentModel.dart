// To parse this JSON data, do
//
//     final userWithDrawPaymentModel = userWithDrawPaymentModelFromJson(jsonString);

import 'dart:convert';

UserWithDrawPaymentModel? userWithDrawPaymentModelFromJson(String str) => UserWithDrawPaymentModel.fromJson(json.decode(str));

String userWithDrawPaymentModelToJson(UserWithDrawPaymentModel? data) => json.encode(data!.toJson());

class UserWithDrawPaymentModel {
  UserWithDrawPaymentModel({
    this.status,
    this.success,
    this.totalAmount,
  });

  int? status;
  String? success;
  String? totalAmount;

  factory UserWithDrawPaymentModel.fromJson(Map<String, dynamic> json) => UserWithDrawPaymentModel(
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
