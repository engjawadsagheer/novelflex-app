// To parse this JSON data, do
//
//     final postImageOtherFieldModel = postImageOtherFieldModelFromJson(jsonString);

import 'dart:convert';

PostImageOtherFieldModel? postImageOtherFieldModelFromJson(String str) => PostImageOtherFieldModel.fromJson(json.decode(str));

String postImageOtherFieldModelToJson(PostImageOtherFieldModel? data) => json.encode(data!.toJson());

class PostImageOtherFieldModel {
  PostImageOtherFieldModel({
    this.status,
    this.success,
    this.data,
  });

  int? status;
  String? success;
  Data? data;

  factory PostImageOtherFieldModel.fromJson(Map<String, dynamic> json) => PostImageOtherFieldModel(
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
    this.title,
    this.categoryId,
    this.subcategoryId,
    this.userId,
    this.description,
    this.image,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.imagePath,
  });

  String? title;
  String? categoryId;
  String? subcategoryId;
  int? userId;
  String? description;
  String? image;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  String? imagePath;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    title: json["title"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    userId: json["user_id"],
    description: json["description"],
    image: json["image"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "user_id": userId,
    "description": description,
    "image": image,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
    "image_path": imagePath,
  };
}
