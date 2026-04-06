// To parse this JSON data, do
//
//     final bookReviewModel = bookReviewModelFromJson(jsonString);

import 'dart:convert';

BookReviewModel bookReviewModelFromJson(String str) => BookReviewModel.fromJson(json.decode(str));

String bookReviewModelToJson(BookReviewModel data) => json.encode(data.toJson());

class BookReviewModel {
  BookReviewModel({
    required this.status,
    required this.success,
    required this.data,
  });

  int status;
  String success;
  List<Datum> data;

  factory BookReviewModel.fromJson(Map<String, dynamic> json) => BookReviewModel(
    status: json["status"],
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.comment,
    required this.status,
    required this.username,
    required this.profilePhoto,
  });

  int id;
  int userId;
  String comment;
  int status;
  String username;
  String profilePhoto;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    comment: json["comment"],
    status: json["status"],
    username: json["username"],
    profilePhoto: json["profile_photo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "comment": comment,
    "status": status,
    "username": username,
    "profile_photo": profilePhoto,
  };
}
