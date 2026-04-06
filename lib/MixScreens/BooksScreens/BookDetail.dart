import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:novelflex/MixScreens/StripePayment/StripePayment.dart';
import 'package:novelflex/Models/LikeDislikeModel.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/models/offerings_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:transitioner/transitioner.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Models/BookDetailsModel.dart';
import '../../Models/subscriptionModelClass.dart';
import '../../Provider/UserProvider.dart';
import '../../Provider/VariableProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/constant.dart';
import '../../Utils/native_dialog.dart';
import '../../Utils/store_config.dart';
import '../../Utils/toast.dart';
import '../../Widgets/loading_widgets.dart';
import '../../ad_helper.dart';
import '../../localization/Language/languages.dart';
import 'BookViewTab.dart';
import 'AuthorViewByUserScreen.dart';
import 'dart:io';
import '../InAppPurchase/inAppPurchaseSubscription.dart';
import '../InAppPurchase/paywall.dart';
import '../InAppPurchase/singletons_data.dart';
import 'BookReviewScreen.dart';

class BookDetail extends StatefulWidget {
  String bookID;
  BookDetail({required this.bookID});

  @override
  State<BookDetail> createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  bool _isLoading = false;
  bool _isInternetConnected = true;
  BookDetailsModel? _bookDetailsModel;
  LikeDislikeModel? _likeDislikeModel;
  var token;
  bool? _isLike;
  bool? _isDisLike;
  bool _isSaved = false;
  Offerings? offerings;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream? stream;
  dynamic chatCount;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();

  }

  _listener() {
    stream = _firestore
        .collection("Comments")
        .doc(
        _bookDetailsModel!.data.bookId.toString())
        .collection("data")
        .snapshots();

    stream!.listen((data) {
      print(data.size);
     setState(() {
       chatCount= data.size;
     });

    });
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    VariableProvider userProvider =
        Provider.of<VariableProvider>(context, listen: false);
    return Scaffold(
        backgroundColor: const Color(0xffebf5f9),
        body: _isInternetConnected == false
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "INTERNET NOT CONNECTED",
                      style: TextStyle(
                        fontFamily: Constants.fontfamily,
                        color: Color(0xFF256D85),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: _height * 0.019,
                    ),
                    InkWell(
                      child: Container(
                        width: _width * 0.40,
                        height: _height * 0.058,
                        decoration: BoxDecoration(
                          color: const Color(0xFF256D85),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              40.0,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            "No Internet Connected",
                            style: TextStyle(
                              fontFamily: Constants.fontfamily,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        _checkInternetConnection();
                      },
                    ),
                  ],
                ),
              )
            : _isLoading
                ? Align(
                    alignment: Alignment.center,
                    child: CustomCard(
                      gif: MoreLoadingGif(
                        type: MoreLoadingGifType.eclipse,
                        size: _height * _width * 0.0002,
                      ),
                      text: 'Loading',
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: _height * 0.4,
                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            Positioned(
                              child: Container(
                                height: _height * 0.3,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: <Color>[
                                        Color(0xff2b5876),
                                        Color(0xff4e4376)
                                      ]),
                                ),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.08,
                              left: _width * 0.25,
                              right: _width * 0.25,
                              child: InkWell(
                                onTap: () {
                                  Transitioner(
                                    context: context,
                                    child: BookViewTab(
                                      bookId: _bookDetailsModel!.data.bookId
                                          .toString(),
                                      bookName: _bookDetailsModel!
                                          .data.bookTitle
                                          .toString(),
                                      readerId: _bookDetailsModel!.data.userId
                                          .toString(),
                                      PaymentStatus: _bookDetailsModel!
                                          .data.paymentStatus
                                          .toString(),
                                      cover_url: _bookDetailsModel!
                                          .data.imagePath
                                          .toString(),
                                    ),
                                    animation: AnimationType
                                        .slideTop, // Optional value
                                    duration: Duration(
                                        milliseconds: 1000), // Optional value
                                    replacement: false, // Optional value
                                    curveType:
                                        CurveType.decelerate, // Optional value
                                  );
                                },
                                child: SizedBox(
                                  height: _height * 0.33,
                                  width: _width,
                                  child: Container(
                                    height: _height * 0.33,
                                    width: _width * 0.3,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: <Color>[
                                            Color(0xffaa076b),
                                            Color(0xff61045f)
                                          ]),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(_bookDetailsModel!
                                              .data.imagePath
                                              .toString())),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: _height * 0.39,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            paidWidget(),
                            SizedBox(
                              height: _height * 0.02,
                            ),
                            Text(_bookDetailsModel!.data.bookTitle),
                            SizedBox(
                              height: _height * 0.02,
                            ),
                            GestureDetector(
                              onTap: () {
                                Transitioner(
                                  context: context,
                                  child: AuthorViewByUserScreen(
                                    user_id: _bookDetailsModel!.data.userId
                                        .toString(),
                                  ),
                                  animation:
                                      AnimationType.slideTop, // Optional value
                                  duration: Duration(
                                      milliseconds: 1000), // Optional value
                                  replacement: false, // Optional value
                                  curveType:
                                      CurveType.decelerate, // Optional value
                                );
                              },
                              child: buildRow(
                                  _width,
                                  _bookDetailsModel!.data.authorName.toString(),
                                  _bookDetailsModel!.data.userimage.toString()),
                            ),
                            SizedBox(
                              height: _height * 0.02,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          _bookDetailsModel!.data.subscription
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          Languages.of(context)!.followers,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          _bookDetailsModel!.data.publication
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          Languages.of(context)!.published,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          _bookDetailsModel!.data.gifts
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          Languages.of(context)!.gift,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: _height * 0.04,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(
                                          Icons.remove_red_eye,
                                          color: Colors.black54,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          _bookDetailsModel!.data!.bookView!
                                              .toString(),
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (_isLike!) {
                                                _LikesDisLikesAPI("0");
                                                userProvider.setLikes(
                                                    userProvider.getLikes - 1);
                                                print("0");
                                              } else {
                                                _LikesDisLikesAPI("1");
                                                userProvider.setLikes(
                                                    userProvider.getLikes + 1);
                                                print("1");
                                              }

                                              _isLike = !_isLike!;
                                            });
                                          },
                                          child: Icon(
                                              _isLike!
                                                  ? Icons
                                                      .thumb_up_off_alt_rounded
                                                  : Icons.thumb_up_alt_outlined,
                                              color: _isLike!
                                                  ? Color(0xff00bb23)
                                                  : Colors.black38),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          context
                                              .read<VariableProvider>()
                                              .getLikes
                                              .toString(),
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Transitioner(
                                              context: context,
                                              child: ShowAllReviewScreen(
                                                bookId: _bookDetailsModel!
                                                    .data.bookId
                                                    .toString(),
                                                bookName: _bookDetailsModel!
                                                    .data.bookTitle
                                                    .toString(),
                                                bookImage: _bookDetailsModel!
                                                    .data.userimage
                                                    .toString(),
                                              ),
                                              animation: AnimationType
                                                  .slideTop, // Optional value
                                              duration: Duration(
                                                  milliseconds:
                                                      1000), // Optional value
                                              replacement:
                                                  false, // Optional value
                                              curveType: CurveType
                                                  .decelerate, // Optional value
                                            );
                                          },
                                          child: Icon(
                                            Icons.insert_comment,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          chatCount.toString(),
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            GestureDetector(
                                onTap: () {
                                  Transitioner(
                                    context: context,
                                    child: BookViewTab(
                                      bookId: _bookDetailsModel!.data.bookId
                                          .toString(),
                                      bookName: _bookDetailsModel!
                                          .data.bookTitle
                                          .toString(),
                                      readerId: _bookDetailsModel!.data.userId
                                          .toString(),
                                      PaymentStatus: _bookDetailsModel!
                                          .data.paymentStatus
                                          .toString(),
                                      cover_url: _bookDetailsModel!
                                          .data.imagePath
                                          .toString(),
                                    ),
                                    animation: AnimationType
                                        .slideTop, // Optional value
                                    duration: Duration(
                                        milliseconds: 1000), // Optional value
                                    replacement: false, // Optional value
                                    curveType:
                                        CurveType.decelerate, // Optional value
                                  );
                                },
                                child: readWidget(_width, _height))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: _width * 0.3,
                            height: 1,
                            color: Colors.black12,
                          ),
                          Text(Languages.of(context)!.advertisement),
                          Container(
                            width: _width * 0.3,
                            height: 1,
                            color: Colors.black12,
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_bookDetailsModel!
                                  .data.advertismentLinks.length ==
                              0) {
                            print("No Ads");
                          } else {
                            _launchProfileUrls(_bookDetailsModel!
                                .data.advertismentLinks[0].link
                                .toString());
                          }
                        },
                        child: Stack(
                          children: [
                            Positioned(
                              child: Container(
                                margin: EdgeInsets.all(16.0),
                                height: _height * 0.14,
                                width: _width * 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(1),
                                  color: Colors.white,
                                  image: DecorationImage(
                                      image: NetworkImage(_bookDetailsModel!
                                                  .data
                                                  .advertismentLinks
                                                  .length ==
                                              0
                                          ? ""
                                          : _bookDetailsModel!.data
                                              .advertismentLinks[0].imagePath
                                              .toString()),
                                      fit: BoxFit.cover),
                                ),
                                child: Container(),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.022,
                              left: _width * 0.046,
                              child: Container(
                                height: _height * 0.03,
                                width: _width * 0.075,
                                decoration: BoxDecoration(color: Colors.red),
                                child: Center(
                                  child: Text(
                                    "Ad",
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Alexandria",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 16.0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ));
  }

  Future _checkInternetConnection() async {
    if (this.mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      Constants.showToastBlack(context, "Internet not connected");
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          _isInternetConnected = false;
        });
      }
    } else {
      _callBookDetailsAPI();
    }
  }

  Future _callBookDetailsAPI() async {
    setState(() {
      _isInternetConnected = true;
    });

    var map = Map<String, dynamic>();
    map['bookId'] = widget.bookID.toString();
    final response = await http.post(
      Uri.parse(
        ApiUtils.BOOK_DETAIL_API,
      ),
      headers: {
        'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
      },
      body: map,
    );
    print(
        "Authorization_bearer_token':  ${context.read<UserProvider>().UserToken}");

    if (response.statusCode == 200) {
      print('BookDetail_response under 200 ${response.body}');
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 200) {
        _bookDetailsModel = BookDetailsModel.fromJson(jsonData);
        print("status_likes${_bookDetailsModel!.data.status.status}");

        _isSaved = _bookDetailsModel!.data.bookSaved;
        VariableProvider userProvider =
            Provider.of<VariableProvider>(context, listen: false);

        userProvider.setLikes(_bookDetailsModel!.data.bookLike);

        if (_bookDetailsModel!.data.status.status == 1) {
          _isLike = true;
        } else {
          _isLike = false;
        }
        _listener();
        print(
            "likes_provider${context.read<VariableProvider>().getLikes.toString()}");
        setState(() {
          _isLoading = false;
        });
      } else {
        // Constants.showToastBlack(context, "Some things went wrong");
        Constants.warning(context);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      // Constants.showToastBlack(context, "Some things went wrong");
      Constants.warning(context);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _LikesDisLikesAPI(String status) async {
    var map = Map<String, dynamic>();
    map['book_id'] = widget.bookID.toString();
    // map['book_id'] = "9";
    map['reader_id'] = "${context.read<UserProvider>().UserID}";
    map['status'] = status.toString();
    final response = await http.post(
      Uri.parse(
        ApiUtils.LIKES_AND_DISLIKES_API,
      ),
      headers: {
        'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
      },
      body: map,
    );

    if (response.statusCode == 200) {
      print('likesDislikes under 200 ${response.body}');
      var jsonData = json.decode(response.body);
      _likeDislikeModel = LikeDislikeModel.fromJson(jsonData);
    } else {
      Constants.showToastBlack(context, "Some things went wrong");
    }
  }

  Future _SaveBookAPI() async {
    var map = Map<String, dynamic>();
    map['book_id'] = widget.bookID.toString();
    final response = await http.post(
      Uri.parse(
        ApiUtils.SAVE_BOOK_API,
      ),
      headers: {
        'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
      },
      body: map,
    );

    if (response.statusCode == 200) {
      print('likesDislikes under 200 ${response.body}');
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 200) {
        Constants.showToastBlack(context, jsonData['success']);
      }
    } else {
      Constants.showToastBlack(context, "Some things went wrong");
    }
  }

  Widget paidWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _bookDetailsModel!.data!.paymentStatus.toString() == 2
            ? Icon(
                Icons.paid_outlined,
                color: Colors.red,
              )
            : Icon(
                Icons.free_breakfast_outlined,
                color: _bookDetailsModel!.data!.paymentStatus.toString() == 2
                    ? Colors.red
                    : Color(0xff00bb23),
              ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: _bookDetailsModel!.data!.paymentStatus.toString() == 2
              ? Text(Languages.of(context)!.paidStory)
              : Text(Languages.of(context)!.freeStory),
        )
      ],
    );
  }

  Widget readWidget(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: width * 0.7,
          height: height * 0.05,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                  color: const Color(0x24000000),
                  offset: Offset(0, 7),
                  blurRadius: 14,
                  spreadRadius: 0)
            ],
            gradient: LinearGradient(
                begin: Alignment(-0.01018629550933838, -0.01894212305545807),
                end: Alignment(1.6960868120193481, 1.3281718730926514),
                colors: [
                  Color(0xff246897),
                  Color(0xff1b4a6b),
                ]),
          ),
          child: Center(
            child: Text(Languages.of(context)!.read,
                style: const TextStyle(
                    color: const Color(0xffffffff),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Lato",
                    fontStyle: FontStyle.normal,
                    fontSize: 14.0),
                textAlign: TextAlign.center),

            // Text(
            //     _bookDetailsModel!.data!.paymentStatus
            //                     .toString() ==
            //                 "1" ||
            //             _bookDetailsModel!.data!.userId
            //                     .toString() ==
            //                 context
            //                     .read<UserProvider>()
            //                     .UserID
            //                     .toString()
            //         ? Languages.of(context)!.read
            //         : _subscriptionModelClass!.success == true
            //             ? Languages.of(context)!.read
            //             : Languages.of(context)!.subscribeTxt,
            //     style: const TextStyle(
            //         color: const Color(0xffffffff),
            //         fontWeight: FontWeight.w700,
            //         fontFamily: "Lato",
            //         fontStyle: FontStyle.normal,
            //         fontSize: 14.0),
            //     textAlign: TextAlign.center),
          ),
        ),
        SizedBox(
          width: width * 0.05,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _isSaved = !_isSaved;
              _SaveBookAPI();
            });
          },
          child: Container(
            width: width * 0.13,
            height: height * 0.12,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xff3a6c83), width: 1),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x12000000),
                      offset: Offset(0, 7),
                      blurRadius: 14,
                      spreadRadius: 0),
                ],
                color: _isSaved ? Color(0xff3a6c83) : Color(0xfffafcfd)),
            child: _isSaved
                ? Icon(
                    Icons.bookmark_border_outlined,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.bookmark_border_outlined,
                    color: Colors.black,
                  ),
          ),
        ),
      ],
    );
  }

  Widget buildRow(double width, String name, String path) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(path),
        ),
        SizedBox(
          width: width * 0.03,
        ),
        Text(name)
      ],
    );
  }

  _launchProfileUrls(var link) async {
    var url = Uri.parse(link.toString());
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
