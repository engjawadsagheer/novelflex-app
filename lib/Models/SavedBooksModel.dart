// To parse this JSON data, do
//
//     final savedBooksModel = savedBooksModelFromJson(jsonString);

import 'dart:convert';

SavedBooksModel savedBooksModelFromJson(String str) => SavedBooksModel.fromJson(json.decode(str));

String savedBooksModelToJson(SavedBooksModel data) => json.encode(data.toJson());

class SavedBooksModel {
  SavedBooksModel({
    required this.status,
    required this.data,
  });

  int status;
  List<Datum> data;

  factory SavedBooksModel.fromJson(Map<String, dynamic> json) => SavedBooksModel(
    status: json["status"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.title,
    required this.image,
    required this.username,
    required this.paymentStatus,
    required this.imagePath,
  });

  int id;
  String title;
  String image;
  String username;
  int paymentStatus;
  String imagePath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    username: json["username"],
    paymentStatus: json["payment_status"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "username": username,
    "payment_status": paymentStatus,
    "image_path": imagePath,
  };
}
