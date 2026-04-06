// To parse this JSON data, do
//
//     final dropDownCategoriesModel = dropDownCategoriesModelFromJson(jsonString);

import 'dart:convert';

List<DropDownCategoriesModel?>? dropDownCategoriesModelFromJson(String str) => json.decode(str) == null ? [] : List<DropDownCategoriesModel?>.from(json.decode(str)!.map((x) => DropDownCategoriesModel.fromJson(x)));

String dropDownCategoriesModelToJson(List<DropDownCategoriesModel?>? data) => json.encode(data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())));

class DropDownCategoriesModel {
  DropDownCategoriesModel({
    this.categoryId,
    this.title,
    this.titleAr,
    this.image,
    this.isActive,
    this.imagePath,
  });

  int? categoryId;
  String? title;
  String? titleAr;
  String? image;
  int? isActive;
  String? imagePath;

  factory DropDownCategoriesModel.fromJson(Map<String, dynamic> json) => DropDownCategoriesModel(
    categoryId: json["category_id"],
    title: json["title"],
    titleAr: json["titleAr"],
    image: json["image"],
    isActive: json["is_active"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "title": title,
    "titleAr": titleAr,
    "image": image,
    "is_active": isActive,
    "image_path": imagePath,
  };
}
