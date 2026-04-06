// To parse this JSON data, do
//
//     final searchAuthorbyCategoriesIdModel = searchAuthorbyCategoriesIdModelFromJson(jsonString);

import 'dart:convert';

SearchAuthorbyCategoriesIdModel? searchAuthorbyCategoriesIdModelFromJson(String str) => SearchAuthorbyCategoriesIdModel.fromJson(json.decode(str));

String searchAuthorbyCategoriesIdModelToJson(SearchAuthorbyCategoriesIdModel? data) => json.encode(data!.toJson());

class SearchAuthorbyCategoriesIdModel {
  SearchAuthorbyCategoriesIdModel({
    this.status,
    this.data,
  });

  int? status;
  List<Datum?>? data;

  factory SearchAuthorbyCategoriesIdModel.fromJson(Map<String, dynamic> json) => SearchAuthorbyCategoriesIdModel(
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
    this.userId,
    this.authorName,
    this.userimage,
    this.categoryId,
    this.title,
    this.publication,
    this.subscription,
    this.level,
    this.imagePath,
  });

  int? userId;
  String? authorName;
  String? userimage;
  int? categoryId;
  Title? title;
  int? publication;
  int? subscription;
  String? level;
  String? imagePath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userId: json["user_id"],
    authorName: json["author_name"],
    userimage: json["userimage"],
    categoryId: json["category_id"],
    title: titleValues!.map[json["title"]],
    publication: json["publication"],
    subscription: json["subscription"],
    level: json["Level"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "author_name": authorName,
    "userimage": userimage,
    "category_id": categoryId,
    "title": titleValues.reverse![title],
    "publication": publication,
    "subscription": subscription,
    "Level": level,
    "image_path": imagePath,
  };
}

enum Title { MANGA }

final titleValues = EnumValues({
  "Manga": Title.MANGA
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
