// To parse this JSON data, do
//
//     final socailLinksModel = socailLinksModelFromJson(jsonString);

import 'dart:convert';

SocailLinksModel socailLinksModelFromJson(String str) => SocailLinksModel.fromJson(json.decode(str));

String socailLinksModelToJson(SocailLinksModel data) => json.encode(data.toJson());

class SocailLinksModel {
  int status;
  String message;
  Data data;

  SocailLinksModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory SocailLinksModel.fromJson(Map<String, dynamic> json) => SocailLinksModel(
    status: json["status"],
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int id;
  int userId;
  dynamic facebookLink;
  dynamic youtubeLink;
  dynamic instagramLink;
  dynamic twitterLink;
  dynamic ticktokLink;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.userId,
    required this.facebookLink,
    this.youtubeLink,
    this.instagramLink,
    this.twitterLink,
    this.ticktokLink,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    facebookLink: json["facebook_link"],
    youtubeLink: json["youtube_link"],
    instagramLink: json["instagram_link"],
    twitterLink: json["twitter_link"],
    ticktokLink: json["ticktok_link"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "facebook_link": facebookLink,
    "youtube_link": youtubeLink,
    "instagram_link": instagramLink,
    "twitter_link": twitterLink,
    "ticktok_link": ticktokLink,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
