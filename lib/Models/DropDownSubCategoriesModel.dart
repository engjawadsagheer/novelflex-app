// To parse this JSON data, do
//
//     final dropDownSubCategoriesModel = dropDownSubCategoriesModelFromJson(jsonString);

import 'dart:convert';

List<DropDownSubCategoriesModel?>? dropDownSubCategoriesModelFromJson(String str) => json.decode(str) == null ? [] : List<DropDownSubCategoriesModel?>.from(json.decode(str)!.map((x) => DropDownSubCategoriesModel.fromJson(x)));

String dropDownSubCategoriesModelToJson(List<DropDownSubCategoriesModel?>? data) => json.encode(data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())));

class DropDownSubCategoriesModel {
  DropDownSubCategoriesModel({
    this.id,
    this.subcategoryId,
    this.subTitle,
    this.subTitleAr,
    this.createdAt,
    this.updatedAt,
    this.imagePath,
  });

  int? id;
  int? subcategoryId;
  String? subTitle;
  String? subTitleAr;
  DateTime? createdAt;
  String? updatedAt;
  String? imagePath;

  factory DropDownSubCategoriesModel.fromJson(Map<String, dynamic> json) => DropDownSubCategoriesModel(
    id: json["id"],
    subcategoryId: json["subcategory_id"],
    subTitle: json["sub_title"],
    subTitleAr: json["sub_title_ar"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subcategory_id": subcategoryId,
    "sub_title": subTitle,
    "sub_title_ar": subTitleAr,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
    "image_path": imagePath,
  };
}
