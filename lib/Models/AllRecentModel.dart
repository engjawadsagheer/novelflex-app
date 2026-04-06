// To parse this JSON data, do
//
//     final allRecentModel = allRecentModelFromJson(jsonString);

import 'dart:convert';

AllRecentModel allRecentModelFromJson(String str) => AllRecentModel.fromJson(json.decode(str));

String allRecentModelToJson(AllRecentModel data) => json.encode(data.toJson());

class AllRecentModel {
  AllRecentModel({
    required this.status,
    required this.data,
  });

  int status;
  List<Datum> data;

  factory AllRecentModel.fromJson(Map<String, dynamic> json) => AllRecentModel(
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
    required this.description,
    required this.categoryId,
    required this.subcategoryId,
    required this.paymentStatus,
    required this.userId,
    required this.lessonId,
    required this.image,
    required this.status,
    required this.isActive,
    required this.isSeen,
    required this.language,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    this.updatedAt,
    required this.imagePath,
    required this.categories,
    required this.user,
  });

  int id;
  String title;
  String description;
  int categoryId;
  int subcategoryId;
  int paymentStatus;
  int userId;
  dynamic lessonId;
  String image;
  dynamic status;
  int isActive;
  int isSeen;
  Language language;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime createdAt;
  dynamic updatedAt;
  String imagePath;
  List<Category> categories;
  List<User> user;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    paymentStatus: json["payment_status"],
    userId: json["user_id"],
    lessonId: json["lesson_id"],
    image: json["image"],
    status: json["status"],
    isActive: json["is_active"],
    isSeen: json["is_seen"],
    language: languageValues.map[json["language"]]!,
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    imagePath: json["image_path"],
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "payment_status": paymentStatus,
    "user_id": userId,
    "lesson_id": lessonId,
    "image": image,
    "status": status,
    "is_active": isActive,
    "is_seen": isSeen,
    "language": languageValues.reverse[language],
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "image_path": imagePath,
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
  };
}

class Category {
  Category({
    required this.id,
    required this.title,
    required this.imagePath,
  });

  int id;
  dynamic title;
  String imagePath;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: titleValues.map[json["title"]],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": titleValues.reverse[title],
    "image_path": imagePath,
  };
}

enum Title { COMICS, MANHWA, MANGA, NOVELS, COMEDY }

final titleValues = EnumValues({
  "Comedy": Title.COMEDY,
  "Comics": Title.COMICS,
  "Manga": Title.MANGA,
  "Manhwa": Title.MANHWA,
  "Novels": Title.NOVELS
});

enum Language { ARB, ENG }

final languageValues = EnumValues({
  "arb": Language.ARB,
  "eng": Language.ENG
});

class User {
  User({
    required this.id,
    required this.username,
    required this.profilePath,
    required this.backgroundPath,
  });

  int id;
  String username;
  String profilePath;
  String backgroundPath;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    profilePath: json["profile_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "profile_path": profilePath,
    "background_path": backgroundPath,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
