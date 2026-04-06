// To parse this JSON data, do
//
//     final subCategoriesModel = subCategoriesModelFromJson(jsonString);

import 'dart:convert';

SubCategoriesModel? subCategoriesModelFromJson(String str) => SubCategoriesModel.fromJson(json.decode(str));

String subCategoriesModelToJson(SubCategoriesModel? data) => json.encode(data!.toJson());

class SubCategoriesModel {
  SubCategoriesModel({
    this.status,
    this.data,
  });

  int? status;
  List<Datum?>? data;

  factory SubCategoriesModel.fromJson(Map<String, dynamic> json) => SubCategoriesModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<Datum?>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())),
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.description,
    this.categoryId,
    this.userId,
    this.subcategoryId,
    this.image,
    this.imagePath,
    this.user,
  });

  int? id;
  String? title;
  String? description;
  int? categoryId;
  int? userId;
  int? subcategoryId;
  String? image;
  String? imagePath;
  List<User?>? user;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    categoryId: json["category_id"],
    userId: json["user_id"],
    subcategoryId: json["subcategory_id"],
    image: json["image"],
    imagePath: json["image_path"],
    user: json["user"] == null ? [] : List<User?>.from(json["user"]!.map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category_id": categoryId,
    "user_id": userId,
    "subcategory_id": subcategoryId,
    "image": image,
    "image_path": imagePath,
    "user": user == null ? [] : List<dynamic>.from(user!.map((x) => x!.toJson())),
  };
}

class User {
  User({
    this.id,
    this.authorName,
    this.imagePath,
  });

  int? id;
  String? authorName;
  String? imagePath;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    authorName: json["author_name"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "author_name": authorName,
    "image_path": imagePath,
  };
}
