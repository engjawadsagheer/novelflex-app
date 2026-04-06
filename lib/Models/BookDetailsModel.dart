// To parse this JSON data, do
//
//     final bookDetailsModel = bookDetailsModelFromJson(jsonString);

import 'dart:convert';

BookDetailsModel bookDetailsModelFromJson(String str) => BookDetailsModel.fromJson(json.decode(str));

String bookDetailsModelToJson(BookDetailsModel data) => json.encode(data.toJson());

class BookDetailsModel {
  int status;
  Data data;

  BookDetailsModel({
    required this.status,
    required this.data,
  });

  factory BookDetailsModel.fromJson(Map<String, dynamic> json) => BookDetailsModel(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  int bookId;
  String bookTitle;
  dynamic image;
  String bookDescription;
  int userId;
  String authorName;
  dynamic userimage;
  int categoryId;
  String catgoryTitle;
  int paymentStatus;
  int publication;
  int subscription;
  int bookView;
  int bookLike;
  int bookDisLike;
  Status status;
  int gifts;
  List<AdvertismentLink> advertismentLinks;
  bool bookSaved;
  bool bookSubscription;
  String imagePath;

  Data({
    required this.bookId,
    required this.bookTitle,
    required this.image,
    required this.bookDescription,
    required this.userId,
    required this.authorName,
    required this.userimage,
    required this.categoryId,
    required this.catgoryTitle,
    required this.paymentStatus,
    required this.publication,
    required this.subscription,
    required this.bookView,
    required this.bookLike,
    required this.bookDisLike,
    required this.status,
    required this.gifts,
    required this.advertismentLinks,
    required this.bookSaved,
    required this.bookSubscription,
    required this.imagePath,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    bookId: json["bookId"],
    bookTitle: json["bookTitle"],
    image: json["image"],
    bookDescription: json["bookDescription"],
    userId: json["user_id"],
    authorName: json["author_name"],
    userimage: json["userimage"],
    categoryId: json["category_id"],
    catgoryTitle: json["catgoryTitle"],
    paymentStatus: json["payment_status"],
    publication: json["publication"],
    subscription: json["subscription"],
    bookView: json["BookView"],
    bookLike: json["BookLike"],
    bookDisLike: json["BookDisLike"],
    status: Status.fromJson(json["status"]),
    gifts: json["gifts"],
    advertismentLinks: List<AdvertismentLink>.from(json["advertisment_links"].map((x) => AdvertismentLink.fromJson(x))),
    bookSaved: json["book_saved"],
    bookSubscription: json["book_subscription"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "bookId": bookId,
    "bookTitle": bookTitle,
    "image": image,
    "bookDescription": bookDescription,
    "user_id": userId,
    "author_name": authorName,
    "userimage": userimage,
    "category_id": categoryId,
    "catgoryTitle": catgoryTitle,
    "payment_status": paymentStatus,
    "publication": publication,
    "subscription": subscription,
    "BookView": bookView,
    "BookLike": bookLike,
    "BookDisLike": bookDisLike,
    "status": status.toJson(),
    "gifts": gifts,
    "advertisment_links": List<dynamic>.from(advertismentLinks.map((x) => x.toJson())),
    "book_saved": bookSaved,
    "book_subscription": bookSubscription,
    "image_path": imagePath,
  };
}

class AdvertismentLink {
  int id;
  int userId;
  String link;
  String image;
  DateTime createdAt;
  String updatedAt;
  String imagePath;

  AdvertismentLink({
    required this.id,
    required this.userId,
    required this.link,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.imagePath,
  });

  factory AdvertismentLink.fromJson(Map<String, dynamic> json) => AdvertismentLink(
    id: json["id"],
    userId: json["user_id"],
    link: json["link"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "link": link,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "image_path": imagePath,
  };
}

class Status {
  int status;

  Status({
    required this.status,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
  };
}
