// To parse this JSON data, do
//
//     final likeDislikeModel = likeDislikeModelFromJson(jsonString);

import 'dart:convert';

LikeDislikeModel? likeDislikeModelFromJson(String str) => LikeDislikeModel.fromJson(json.decode(str));

String likeDislikeModelToJson(LikeDislikeModel? data) => json.encode(data!.toJson());

class LikeDislikeModel {
  LikeDislikeModel({
    this.status,
    this.success,
    this.data,
  });

  int? status;
  String? success;
  Data? data;

  factory LikeDislikeModel.fromJson(Map<String, dynamic> json) => LikeDislikeModel(
    status: json["status"],
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.bookId,
    this.readerId,
    this.status,
  });

  String? bookId;
  String? readerId;
  String? status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bookId: json["book_id"],
    readerId: json["reader_id"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "book_id": bookId,
    "reader_id": readerId,
    "status": status,
  };
}
