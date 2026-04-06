// To parse this JSON data, do
//
//     final userReferralModel = userReferralModelFromJson(jsonString);

import 'dart:convert';

UserReferralModel? userReferralModelFromJson(String str) => UserReferralModel.fromJson(json.decode(str));

String userReferralModelToJson(UserReferralModel? data) => json.encode(data!.toJson());

class UserReferralModel {
  UserReferralModel({
    this.status,
    this.success,
  });

  int? status;
  List<Success?>? success;

  factory UserReferralModel.fromJson(Map<String, dynamic> json) => UserReferralModel(
    status: json["status"],
    success: json["success"] == null ? [] : List<Success?>.from(json["success"]!.map((x) => Success.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success == null ? [] : List<dynamic>.from(success!.map((x) => x!.toJson())),
  };
}

class Success {
  Success({
    this.referralCode,
  });

  String? referralCode;

  factory Success.fromJson(Map<String, dynamic> json) => Success(
    referralCode: json["referral_code"],
  );

  Map<String, dynamic> toJson() => {
    "referral_code": referralCode,
  };
}
