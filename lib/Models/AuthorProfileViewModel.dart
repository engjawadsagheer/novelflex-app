// To parse this JSON data, do
//
//     final authorProfileViewModel = authorProfileViewModelFromJson(jsonString);

import 'dart:convert';

AuthorProfileViewModel authorProfileViewModelFromJson(String str) => AuthorProfileViewModel.fromJson(json.decode(str));

String authorProfileViewModelToJson(AuthorProfileViewModel data) => json.encode(data.toJson());

class AuthorProfileViewModel {
  int status;
  Data data;

  AuthorProfileViewModel({
    required this.status,
    required this.data,
  });

  factory AuthorProfileViewModel.fromJson(Map<String, dynamic> json) => AuthorProfileViewModel(
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
  String username;
  dynamic description;
  dynamic profilePhoto;
  dynamic backgroundImage;
  String type;
  int followers;
  bool isSubscription;
  UserType userType;
  String profilePath;
  String backgroundPath;
  List<Book> book;
  List<SocialLink> socialLink;
  List<Advertisment> advertisment;

  Data({
    required this.id,
    required this.username,
    this.description,
    required this.profilePhoto,
    required this.backgroundImage,
    required this.type,
    required this.followers,
    required this.isSubscription,
    required this.userType,
    required this.profilePath,
    required this.backgroundPath,
    required this.book,
    required this.socialLink,
    required this.advertisment,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    description: json["description"],
    profilePhoto: json["profile_photo"],
    backgroundImage: json["background_image"],
    type: json["type"],
    followers: json["followers"],
    isSubscription: json["is_subscription"],
    userType: UserType.fromJson(json["user_type"]),
    profilePath: json["profile_path"],
    backgroundPath: json["background_path"],
    book: List<Book>.from(json["book"].map((x) => Book.fromJson(x))),
    socialLink: List<SocialLink>.from(json["social_link"].map((x) => SocialLink.fromJson(x))),
    advertisment: List<Advertisment>.from(json["advertisment"].map((x) => Advertisment.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "description": description,
    "profile_photo": profilePhoto,
    "background_image": backgroundImage,
    "type": type,
    "followers": followers,
    "is_subscription": isSubscription,
    "user_type": userType.toJson(),
    "profile_path": profilePath,
    "background_path": backgroundPath,
    "book": List<dynamic>.from(book.map((x) => x.toJson())),
    "social_link": List<dynamic>.from(socialLink.map((x) => x.toJson())),
    "advertisment": List<dynamic>.from(advertisment.map((x) => x.toJson())),
  };
}

class Advertisment {
  int id;
  int userId;
  dynamic link;
  dynamic image;
  DateTime createdAt;
  DateTime updatedAt;
  String imagePath;

  Advertisment({
    required this.id,
    required this.userId,
    required this.link,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.imagePath,
  });

  factory Advertisment.fromJson(Map<String, dynamic> json) => Advertisment(
    id: json["id"],
    userId: json["user_id"],
    link: json["link"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "link": link,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "image_path": imagePath,
  };
}

class Book {
  int id;
  dynamic title;
  dynamic description;
  int categoryId;
  int subcategoryId;
  int paymentStatus;
  int userId;
  dynamic lessonId;
  String image;
  dynamic status;
  int isActive;
  int isSeen;
  String language;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  DateTime createdAt;
  DateTime updatedAt;
  String imagePath;

  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.subcategoryId,
    required this.paymentStatus,
    required this.userId,
    this.lessonId,
    required this.image,
    this.status,
    required this.isActive,
    required this.isSeen,
    required this.language,
    this.createdBy,
    this.updatedBy,
    this.deletedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.imagePath,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    categoryId: json["category_id"],
    subcategoryId: json["subcategory_id"],
    paymentStatus: json["payment_status"],
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
    updatedAt: DateTime.parse(json["updated_at"]),
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "category_id": categoryId,
    "subcategory_id": subcategoryId,
    "payment_status": paymentStatus,
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
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "image_path": imagePath,
  };
}

class SocialLink {
  int id;
  int userId;
  dynamic facebookLink;
  dynamic youtubeLink;
  dynamic instagramLink;
  dynamic twitterLink;
  dynamic ticktokLink;
  DateTime createdAt;
  DateTime updatedAt;

  SocialLink({
    required this.id,
    required this.userId,
    required this.facebookLink,
    required this.youtubeLink,
    this.instagramLink,
    this.twitterLink,
    required this.ticktokLink,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
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

class UserType {
  String type;
  String profilePath;
  String backgroundPath;

  UserType({
    required this.type,
    required this.profilePath,
    required this.backgroundPath,
  });

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
    type: json["type"],
    profilePath: json["profile_path"],
    backgroundPath: json["background_path"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "profile_path": profilePath,
    "background_path": backgroundPath,
  };
}
