// To parse this JSON data, do
//
//     final giftAmountModel = giftAmountModelFromJson(jsonString);

import 'dart:convert';

GiftAmountModel giftAmountModelFromJson(String str) => GiftAmountModel.fromJson(json.decode(str));

String giftAmountModelToJson(GiftAmountModel data) => json.encode(data.toJson());

class GiftAmountModel {
  GiftAmountModel({
    required this.status,
    required this.success,
    required this.totalAmount,
  });

  int status;
  String success;
  String totalAmount;

  factory GiftAmountModel.fromJson(Map<String, dynamic> json) => GiftAmountModel(
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
