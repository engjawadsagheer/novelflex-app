// To parse this JSON data, do
//
//     final readerProfileModel = readerProfileModelFromJson(jsonString);

import 'dart:convert';

ReaderProfileModel readerProfileModelFromJson(String str) => ReaderProfileModel.fromJson(json.decode(str));

String readerProfileModelToJson(ReaderProfileModel data) => json.encode(data.toJson());

class ReaderProfileModel {
  ReaderProfileModel({
    required this.status,
    required this.data,
  });

  int status;
  Data data;

  factory ReaderProfileModel.fromJson(Map<String, dynamic> json) => ReaderProfileModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.type,
    required this.profilePhoto,
    this.description,
    required this.registerdDate,
    required this.following,
    required this.books,
    required this.profilePath,
    required this.backgroundPath,
  });

  int id;
  String username;
  String email;
  dynamic phone;
  String type;
  dynamic profilePhoto;
  dynamic description;
  DateTime registerdDate;
  List<Following> following;
  List<Book> books;
  String profilePath;
  String backgroundPath;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    email: json["email"],
    phone: json["phone"],
    type: json["type"],
    profilePhoto: json["profile_photo"],
    description: json["description"],
    registerdDate: DateTime.parse(json["registerd_date"]),
    following: List<Following>.from(json["following"].map((x) => Following.fromJson(x))),
    books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
    profilePath: json["profile_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "phone": phone,
    "type": type,
    "profile_photo": profilePhoto,
    "description": description,
    "registerd_date": registerdDate.toIso8601String(),
    "following": List<dynamic>.from(following.map((x) => x.toJson())),
    "books": List<dynamic>.from(books.map((x) => x.toJson())),
    "profile_path": profilePath,
    "background_path": backgroundPath,
  };
}

class Book {
  Book({
    required this.id,
    required this.title,
    required this.bookImage,
    required this.profilePath,
    required this.backgroundPath,
  });

  int id;
  String title;
  String bookImage;
  String profilePath;
  String backgroundPath;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    title: json["title"],
    bookImage: json["book_image"],
    profilePath: json["profile_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "book_image": bookImage,
    "profile_path": profilePath,
    "background_path": backgroundPath,
  };
}

class Following {
  Following({
    required this.id,
    required this.username,
    required this.profilePhoto,
    required this.profilePath,
    required this.backgroundPath,
  });

  int id;
  String username;
  String profilePhoto;
  String profilePath;
  String backgroundPath;

  factory Following.fromJson(Map<String, dynamic> json) => Following(
    id: json["id"],
    username: json["username"],
    profilePhoto: json["profile_photo"],
    profilePath: json["profile_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "profile_photo": profilePhoto,
    "profile_path": profilePath,
    "background_path": backgroundPath,
  };
}
