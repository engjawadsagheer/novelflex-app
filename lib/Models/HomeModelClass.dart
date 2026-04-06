// To parse this JSON data, do
//
//     final homeApiResponse = homeApiResponseFromJson(jsonString);

import 'dart:convert';

HomeApiResponse homeApiResponseFromJson(String str) => HomeApiResponse.fromJson(json.decode(str));

String homeApiResponseToJson(HomeApiResponse data) => json.encode(data.toJson());

class HomeApiResponse {
  int status;
  Data data;

  HomeApiResponse({
    required this.status,
    required this.data,
  });

  factory HomeApiResponse.fromJson(Map<String, dynamic> json) => HomeApiResponse(
    status: json["status"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data.toJson(),
  };
}

class Data {
  List<RecentlyPublishBook> slider;
  List<RecentlyPublishBook> recentlyPublishBooks;
  List<CategoryBook> categoryBooks;

  Data({
    required this.slider,
    required this.recentlyPublishBooks,
    required this.categoryBooks,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    slider: List<RecentlyPublishBook>.from(json["slider"].map((x) => RecentlyPublishBook.fromJson(x))),
    recentlyPublishBooks: List<RecentlyPublishBook>.from(json["recentlyPublishBooks"].map((x) => RecentlyPublishBook.fromJson(x))),
    categoryBooks: List<CategoryBook>.from(json["categoryBooks"].map((x) => CategoryBook.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "slider": List<dynamic>.from(slider.map((x) => x.toJson())),
    "recentlyPublishBooks": List<dynamic>.from(recentlyPublishBooks.map((x) => x.toJson())),
    "categoryBooks": List<dynamic>.from(categoryBooks.map((x) => x.toJson())),
  };
}

class CategoryBook {
  int id;
  String title;
  String titleAr;
  int isActive;
  String image;
  DateTime createdAt;
  String updatedAt;
  int createdBy;
  dynamic updatedBy;
  dynamic deletedBy;
  List<Book> books;

  CategoryBook({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.isActive,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    this.updatedBy,
    this.deletedBy,
    required this.books,
  });

  factory CategoryBook.fromJson(Map<String, dynamic> json) => CategoryBook(
    id: json["id"],
    title: json["title"],
    titleAr: json["titleAr"],
    isActive: json["is_active"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
    deletedBy: json["deleted_by"],
    books: List<Book>.from(json["books"].map((x) => Book.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "titleAr": titleAr,
    "is_active": isActive,
    "image": image,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
    "deleted_by": deletedBy,
    "books": List<dynamic>.from(books.map((x) => x.toJson())),
  };
}

class Book {
  int id;
  String bookTitle;
  String description;
  int paymentStatus;
  String image;
  String authorName;

  Book({
    required this.id,
    required this.bookTitle,
    required this.description,
    required this.paymentStatus,
    required this.image,
    required this.authorName,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json["id"],
    bookTitle: json["bookTitle"],
    description: json["description"],
    paymentStatus: json["payment_status"],
    image: json["image"],
    authorName: json["author_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bookTitle": bookTitle,
    "description": description,
    "payment_status": paymentStatus,
    "image": image,
    "author_name": authorName,
  };
}

class RecentlyPublishBook {
  int id;
  String title;
  String description;
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
  List<Category> categories;
  List<User>? user;

  RecentlyPublishBook({
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
    required this.categories,
    this.user,
  });

  factory RecentlyPublishBook.fromJson(Map<String, dynamic> json) => RecentlyPublishBook(
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
    categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
    user: json["user"] == null ? [] : List<User>.from(json["user"]!.map((x) => User.fromJson(x))),
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
    "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
    "user": user == null ? [] : List<dynamic>.from(user!.map((x) => x.toJson())),
  };
}

class Category {
  int id;
  String title;
  String imagePath;

  Category({
    required this.id,
    required this.title,
    required this.imagePath,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: json["title"],
    imagePath: json["image_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image_path": imagePath,
  };
}

class User {
  int id;
  String username;
  String profilePath;
  String backgroundPath;

  User({
    required this.id,
    required this.username,
    required this.profilePath,
    required this.backgroundPath,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
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
