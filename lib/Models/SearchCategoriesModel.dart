// To parse this JSON data, do
//
//     final searchCategoriesModel = searchCategoriesModelFromJson(jsonString);

import 'dart:convert';

SearchCategoriesModel? searchCategoriesModelFromJson(String str) => SearchCategoriesModel.fromJson(json.decode(str));

String searchCategoriesModelToJson(SearchCategoriesModel? data) => json.encode(data!.toJson());

class SearchCategoriesModel {
  SearchCategoriesModel({
    this.status,
    this.data,
  });

  int? status;
  List<Datum?>? data;

  factory SearchCategoriesModel.fromJson(Map<String, dynamic> json) => SearchCategoriesModel(
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
