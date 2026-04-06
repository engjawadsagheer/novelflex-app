// To parse this JSON data, do
//
//     final seeAllBooksModelClass = seeAllBooksModelClassFromJson(jsonString);

import 'dart:convert';

SeeAllBooksModelClass seeAllBooksModelClassFromJson(String str) => SeeAllBooksModelClass.fromJson(json.decode(str));

String seeAllBooksModelClassToJson(SeeAllBooksModelClass data) => json.encode(data.toJson());

class SeeAllBooksModelClass {
  SeeAllBooksModelClass({
    required this.status,
    required this.data,
  });

  int status;
  List<Datum> data;

  factory SeeAllBooksModelClass.fromJson(Map<String, dynamic> json) => SeeAllBooksModelClass(
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
    required this.userId,
    this.lessonId,
    required this.paymentStatus,
    required this.image,
    this.status,
    required this.isActive,
    required this.isSeen,
    required this.language,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    this.updatedAt,
    required this.imagePath,
    required this.user,
  });

  int id;
  String title;
  String description;
  int categoryId;
  int subcategoryId;
  int userId;
  dynamic lessonId;
  int paymentStatus;
  String image;
  String? status;
  int isActive;
  int isSeen;
  Language language;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime createdAt;
  DateTime? updatedAt;
  String imagePath;
  List<User> user;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    userId: json["user_id"],
    lessonId: json["lesson_id"],
    paymentStatus: json["payment_status"],
    image: json["image"],
    status: json["status"],
    isActive: json["is_active"],
    isSeen: json["is_seen"],
    language: languageValues.map[json["language"]]!,
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    imagePath: json["image_path"],
    user: List<User>.from(json["user"].map((x) => User.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "user_id": userId,
    "lesson_id": lessonId,
    "payment_status": paymentStatus,
    "image": image,
    "status": status,
    "is_active": isActive,
    "is_seen": isSeen,
    "language": languageValues.reverse[language],
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "image_path": imagePath,
    "user": List<dynamic>.from(user.map((x) => x.toJson())),
  };
}

enum Language { ENG, ARB }

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
