// To parse this JSON data, do
//
//     final searchAuthorModel = searchAuthorModelFromJson(jsonString);

import 'dart:convert';

SearchAuthorModel searchAuthorModelFromJson(String str) => SearchAuthorModel.fromJson(json.decode(str));

String searchAuthorModelToJson(SearchAuthorModel data) => json.encode(data.toJson());

class SearchAuthorModel {
  SearchAuthorModel({
    required this.status,
    required this.data,
  });

  int status;
  List<Datum> data;

  factory SearchAuthorModel.fromJson(Map<String, dynamic> json) => SearchAuthorModel(
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
    required this.username,
    required this.profilePath,
    required this.backgroundPath,
  });

  int id;
  String username;
  String profilePath;
  String backgroundPath;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
