// To parse this JSON data, do
//
//     final getSocailLinksModel = getSocailLinksModelFromJson(jsonString);

import 'dart:convert';

GetSocailLinksModel getSocailLinksModelFromJson(String str) => GetSocailLinksModel.fromJson(json.decode(str));

String getSocailLinksModelToJson(GetSocailLinksModel data) => json.encode(data.toJson());

class GetSocailLinksModel {
  int status;
  Data data;

  GetSocailLinksModel({
    required this.status,
    required this.data,
  });

  factory GetSocailLinksModel.fromJson(Map<String, dynamic> json) => GetSocailLinksModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
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

  Data({
    required this.id,
    required this.userId,
    required this.facebookLink,
    this.youtubeLink,
    this.instagramLink,
    this.twitterLink,
    this.ticktokLink,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    userId: json["user_id"],
    facebookLink: json["facebook_link"],
    youtubeLink: json["youtube_link"],
    instagramLink: json["instagram_link"],
    twitterLink: json["twitter_link"],
    ticktokLink: json["ticktok_link"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "facebook_link": facebookLink,
    "youtube_link": youtubeLink,
    "instagram_link": instagramLink,
    "twitter_link": twitterLink,
    "ticktok_link": ticktokLink,
  };
}
