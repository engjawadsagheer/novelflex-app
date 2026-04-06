// To parse this JSON data, do
//
//     final subscriptionModelClass = subscriptionModelClassFromJson(jsonString);

import 'dart:convert';

SubscriptionModelClass? subscriptionModelClassFromJson(String str) => SubscriptionModelClass.fromJson(json.decode(str));

String subscriptionModelClassToJson(SubscriptionModelClass? data) => json.encode(data!.toJson());

class SubscriptionModelClass {
  SubscriptionModelClass({
    this.status,
    this.success,
  });

  int? status;
  bool? success;

  factory SubscriptionModelClass.fromJson(Map<String, dynamic> json) => SubscriptionModelClass(
    status: json["status"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success,
  };
}
