// To parse this JSON data, do
//
//     final getAudioBookModel = getAudioBookModelFromJson(jsonString);

import 'dart:convert';

GetAudioBookModel getAudioBookModelFromJson(String str) => GetAudioBookModel.fromJson(json.decode(str));

String getAudioBookModelToJson(GetAudioBookModel data) => json.encode(data.toJson());

class GetAudioBookModel {
  int status;
  String success;
  Data data;

  GetAudioBookModel({
    required this.status,
    required this.success,
    required this.data,
  });

  factory GetAudioBookModel.fromJson(Map<String, dynamic> json) => GetAudioBookModel(
    status: json["status"],
    success: json["success"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "success": success,
    "data": data.toJson(),
  };
}

class Data {
  String audio;
  String audioPath;

  Data({
    required this.audio,
    required this.audioPath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    audio: json["audio"],
    audioPath: json["audio_path"],
  );

  Map<String, dynamic> toJson() => {
    "audio": audio,
    "audio_path": audioPath,
  };
}
