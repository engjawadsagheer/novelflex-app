// To parse this JSON data, do
//
//     final forgetPasswordModelEmail = forgetPasswordModelEmailFromJson(jsonString);

import 'dart:convert';

ForgetPasswordModelEmail? forgetPasswordModelEmailFromJson(String str) => ForgetPasswordModelEmail.fromJson(json.decode(str));

String forgetPasswordModelEmailToJson(ForgetPasswordModelEmail? data) => json.encode(data!.toJson());

class ForgetPasswordModelEmail {
  ForgetPasswordModelEmail({
    this.status,
    this.user,
  });

  int? status;
  User? user;

  factory ForgetPasswordModelEmail.fromJson(Map<String, dynamic> json) => ForgetPasswordModelEmail(
    status: json["status"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "user": user!.toJson(),
  };
}

class User {
  User({
    this.id,
    this.fname,
    this.lname,
    this.email,
    this.phone,
    this.image,
    this.accessToken,
    this.expiredDays,
    this.googleId,
  });

  int? id;
  dynamic fname;
  dynamic lname;
  String? email;
  String? phone;
  String? image;
  String? accessToken;
  int? expiredDays;
  dynamic googleId;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    fname: json["fname"],
    lname: json["lname"],
    email: json["email"],
    phone: json["phone"],
    image: json["image"],
    accessToken: json["access_token"],
    expiredDays: json["expired_days"],
    googleId: json["google_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fname": fname,
    "lname": lname,
    "email": email,
    "phone": phone,
    "image": image,
    "access_token": accessToken,
    "expired_days": expiredDays,
    "google_id": googleId,
  };
}
