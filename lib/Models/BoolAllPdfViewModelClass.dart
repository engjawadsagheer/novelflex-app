// To parse this JSON data, do
//
//     final boolAllPdfViewModelClass = boolAllPdfViewModelClassFromJson(jsonString);

import 'dart:convert';

BoolAllPdfViewModelClass boolAllPdfViewModelClassFromJson(String str) => BoolAllPdfViewModelClass.fromJson(json.decode(str));

String boolAllPdfViewModelClassToJson(BoolAllPdfViewModelClass data) => json.encode(data.toJson());

class BoolAllPdfViewModelClass {
  BoolAllPdfViewModelClass({
    required this.status,
    required this.success,
    required this.data,
  });

  int status;
  String success;
  List<Datum> data;

  factory BoolAllPdfViewModelClass.fromJson(Map<String, dynamic> json) => BoolAllPdfViewModelClass(
    status: json["status"],
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.bookId,
    required this.userId,
    required this.pdfStatus,
    this.image,
    this.lesson,
    required this.filename,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.lessonPath,
    required this.book,
  });

  int id;
  int bookId;
  int userId;
  int pdfStatus;
  dynamic image;
  dynamic lesson;
  String filename;
  String status;
  DateTime createdAt;
  String updatedAt;
  String lessonPath;
  List<Book> book;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    bookId: json["book_id"],
    userId: json["user_id"],
    pdfStatus: json["pdf_status"],
    image: json["image"],
    lesson: json["lesson"],
    filename: json["filename"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    lessonPath: json["lesson_path"],
    book: List<Book>.from(json["book"].map((x) => Book.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "book_id": bookId,
    "user_id": userId,
    "pdf_status": pdfStatus,
    "image": image,
    "lesson": lesson,
    "filename": filename,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "lesson_path": lessonPath,
    "book": List<dynamic>.from(book.map((x) => x.toJson())),
  };
}

class Book {
  Book({
    required this.id,
    required this.image,
    required this.isActive,
    required this.imagePath,
  });

  int id;
  String image;
  int isActive;
  String imagePath;

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    image: json["image"],
    isActive: json["is_active"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "is_active": isActive,
    "image_path": imagePath,
  };
}
