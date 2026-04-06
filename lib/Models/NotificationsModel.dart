// To parse this JSON data, do
//
//     final notificationsModel = notificationsModelFromJson(jsonString);

import 'dart:convert';

NotificationsModel notificationsModelFromJson(String str) => NotificationsModel.fromJson(json.decode(str));

String notificationsModelToJson(NotificationsModel data) => json.encode(data.toJson());

class NotificationsModel {
  NotificationsModel({
    required this.status,
    required this.message,
    required this.data,
  });

  int status;
  String message;
  List<Datum> data;

  factory NotificationsModel.fromJson(Map<String, dynamic> json) => NotificationsModel(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookImage,
    required this.userImage,
    required this.titleEn,
    required this.titleAr,
    required this.bodyEn,
    required this.bodyAr,
    required this.seen,
  });

  int id;
  int bookId;
  dynamic bookTitle;
  dynamic bookImage;
  dynamic userImage;
  String titleEn;
  TitleAr titleAr;
  String bodyEn;
  String bodyAr;
  int seen;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    bookId: json["book_id"],
    bookTitle: json["book_title"],
    bookImage: json["bookImage"],
    userImage: json["user_image"],
    titleEn: json["title_en"],
    titleAr: titleArValues.map[json["title_ar"]]!,
    bodyEn: json["body_en"],
    bodyAr: json["body_ar"],
    seen: json["seen"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "book_id": bookId,
    "book_title": bookTitle,
    "bookImage": bookImage,
    "user_image": userImage,
    "title_en": titleEn,
    "title_ar": titleArValues.reverse[titleAr],
    "body_en": bodyEn,
    "body_ar": bodyAr,
    "seen": seen,
  };
}

enum TitleAr { EMPTY }

final titleArValues = EnumValues({
  "تعتحميل كتاب جديد": TitleAr.EMPTY
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
