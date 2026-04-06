// To parse this JSON data, do
//
//     final pdfUploadModel = pdfUploadModelFromJson(jsonString);

import 'dart:convert';

PdfUploadModel pdfUploadModelFromJson(String str) => PdfUploadModel.fromJson(json.decode(str));

String pdfUploadModelToJson(PdfUploadModel data) => json.encode(data.toJson());

class PdfUploadModel {
  PdfUploadModel({
    required this.status,
    required this.success,
    required this.data,
  });

  int status;
  String success;
  List<Datum> data;

  factory PdfUploadModel.fromJson(Map<String, dynamic> json) => PdfUploadModel(
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
    required this.lesson,
    required this.pdfStatus,
    required this.imagePath,
  });

  int id;
  int bookId;
  String lesson;
  int pdfStatus;
  String imagePath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    bookId: json["book_id"],
    lesson: json["lesson"],
    pdfStatus: json["pdf_status"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "book_id": bookId,
    "lesson": lesson,
    "pdf_status": pdfStatus,
    "image_path": imagePath,
  };
}
