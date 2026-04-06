// To parse this JSON data, do
//
//     final bookEditModel = bookEditModelFromJson(jsonString);

import 'dart:convert';

BookEditModel? bookEditModelFromJson(String str) => BookEditModel.fromJson(json.decode(str));

String bookEditModelToJson(BookEditModel? data) => json.encode(data!.toJson());

class BookEditModel {
  BookEditModel({
    this.status,
    this.data,
  });

  int? status;
  Data? data;

  factory BookEditModel.fromJson(Map<String, dynamic> json) => BookEditModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.title,
    this.authorName,
    this.description,
    this.categoryId,
    this.subcategoryId,
    this.userId,
    this.lessonId,
    this.image,
    this.status,
    this.isActive,
    this.isSeen,
    this.language,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    this.createdAt,
    this.updatedAt,
    this.imagePath,
    this.user,
    this.chapter,
  });

  int? id;
  String? title;
  dynamic authorName;
  String? description;
  int? categoryId;
  int? subcategoryId;
  int? userId;
  dynamic lessonId;
  String? image;
  String? status;
  int? isActive;
  int? isSeen;
  String? language;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime? createdAt;
  dynamic updatedAt;
  String? imagePath;
  List<User?>? user;
  List<Chapter?>? chapter;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    title: json["title"],
    authorName: json["author_name"],
    description: json["description"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    userId: json["user_id"],
    lessonId: json["lesson_id"],
    image: json["image"],
    status: json["status"],
    isActive: json["is_active"],
    isSeen: json["is_seen"],
    language: json["language"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    imagePath: json["image_path"],
    user: json["user"] == null ? [] : List<User?>.from(json["user"]!.map((x) => User.fromJson(x))),
    chapter: json["chapter"] == null ? [] : List<Chapter?>.from(json["chapter"]!.map((x) => Chapter.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "author_name": authorName,
    "description": description,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "user_id": userId,
    "lesson_id": lessonId,
    "image": image,
    "status": status,
    "is_active": isActive,
    "is_seen": isSeen,
    "language": language,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
    "image_path": imagePath,
    "user": user == null ? [] : List<dynamic>.from(user!.map((x) => x!.toJson())),
    "chapter": chapter == null ? [] : List<dynamic>.from(chapter!.map((x) => x!.toJson())),
  };
}

class Chapter {
  Chapter({
    this.id,
    this.bookId,
    this.userId,
    this.image,
    this.lesson,
    this.filename,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.imagePath,
  });

  int? id;
  int? bookId;
  int? userId;
  dynamic image;
  dynamic lesson;
  String? filename;
  String? status;
  DateTime? createdAt;
  String? updatedAt;
  String? imagePath;

  factory Chapter.fromJson(Map<String, dynamic> json) => Chapter(
    id: json["id"],
    bookId: json["book_id"],
    userId: json["user_id"],
    image: json["image"],
    lesson: json["lesson"],
    filename: json["filename"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "book_id": bookId,
    "user_id": userId,
    "image": image,
    "lesson": lesson,
    "filename": filename,
    "status": status,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt,
    "image_path": imagePath,
  };
}

class User {
  User({
    this.id,
    this.username,
    this.imagePath,
    this.backgroundPath,
  });

  int? id;
  String? username;
  String? imagePath;
  String? backgroundPath;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    username: json["username"],
    imagePath: json["image_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "image_path": imagePath,
    "background_path": backgroundPath,
  };
}
