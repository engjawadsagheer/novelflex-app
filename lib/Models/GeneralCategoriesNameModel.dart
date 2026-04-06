// To parse this JSON data, do
//
//     final generalCategoriesNameModel = generalCategoriesNameModelFromJson(jsonString);

import 'dart:convert';

GeneralCategoriesNameModel? generalCategoriesNameModelFromJson(String str) => GeneralCategoriesNameModel.fromJson(json.decode(str));

String generalCategoriesNameModelToJson(GeneralCategoriesNameModel? data) => json.encode(data!.toJson());

class GeneralCategoriesNameModel {
  GeneralCategoriesNameModel({
    this.status,
    this.data,
  });

  int? status;
  List<Datum?>? data;

  factory GeneralCategoriesNameModel.fromJson(Map<String, dynamic> json) => GeneralCategoriesNameModel(
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
    this.titleAr,
    this.isActive,
    this.image,
    this.createdAt,
    this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.imagePath,
    this.productSubCategories,
  });

  int? id;
  String? title;
  String? titleAr;
  int? isActive;
  String? image;
  DateTime? createdAt;
  String? updatedAt;
  int? createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  String? imagePath;
  List<ProductSubCategory?>? productSubCategories;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    titleAr: json["titleAr"],
    isActive: json["is_active"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    imagePath: json["image_path"],
    productSubCategories: json["product_sub_categories"] == null ? [] : List<ProductSubCategory?>.from(json["product_sub_categories"]!.map((x) => ProductSubCategory.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "titleAr": titleAr,
    "is_active": isActive,
    "image": image,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "image_path": imagePath,
    "product_sub_categories": productSubCategories == null ? [] : List<dynamic>.from(productSubCategories!.map((x) => x!.toJson())),
  };
}

class ProductSubCategory {
  ProductSubCategory({
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

  factory ProductSubCategory.fromJson(Map<String, dynamic> json) => ProductSubCategory(
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
