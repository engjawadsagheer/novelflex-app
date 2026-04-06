import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';

import '../Models/NotificationsModel.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../Widgets/loading_widgets.dart';
import '../localization/Language/languages.dart';
import 'BooksScreens/BookDetail.dart';
import 'BooksScreens/BookDetailsAuthor.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationsModel? _notificationsModel;
  bool _isLoading = false;
  bool _isInternetConnected = true;

  @override
  void initState() {
    _checkInternetConnection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xffebf5f9),
        appBar: AppBar(
          backgroundColor: const Color(0xffebf5f9),
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black54,
              )),
        ),
        body: SafeArea(
          child: _isInternetConnected
              ? _isLoading
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
                  : SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: _height * 0.02,
                        ),
                        child: _notificationsModel!.data.length == 0
                            ? Padding(
                                padding: EdgeInsets.only(top: _height * 0.4),
                                child: Center(
                                  child: Text(
                                    Languages.of(context)!.nodata,
                                    style: const TextStyle(
                                        color: const Color(0xff3a6c83),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Lato",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 12.0),
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(bottom: _height * 0.05),
                                child: ListView.builder(
                                    itemCount: _notificationsModel!.data.length,
                                    shrinkWrap: true,
                                    physics: BouncingScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext buildContext, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Transitioner(
                                            context: context,
                                            child: BookDetail(
                                              bookID: _notificationsModel!
                                                  .data[index].bookId
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
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: _height * 0.02,
                                                  bottom: _height * 0.03),
                                              child: Opacity(
                                                opacity: 0.5,
                                                child: Container(
                                                    width: _width,
                                                    height: 1,
                                                    decoration: BoxDecoration(
                                                        color: const Color(
                                                            0xffbcbcbc))),
                                              ),
                                            ),
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Container(
                                                    height: _height * 0.1,
                                                    width: _width * 0.15,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: _notificationsModel!
                                                                        .data[
                                                                            index]
                                                                        .userImage ==
                                                                    " "
                                                                ? AssetImage(
                                                                    "assets/Novelflex_main.png")
                                                                : NetworkImage(_notificationsModel!
                                                                        .data[index]
                                                                        .userImage
                                                                        .toString())
                                                                    as ImageProvider,
                                                            fit: BoxFit.cover)),
                                                  ),
                                                  Container(
                                                    width: _width * 0.4,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "${_notificationsModel!.data[index].bookTitle}",
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff2a2a2a),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              fontFamily:
                                                                  "Neckar",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 14.0),
                                                          textAlign:
                                                              TextAlign.left,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              _height * 0.01,
                                                        ),
                                                        Text(
                                                          _notificationsModel!
                                                              .data[index]
                                                              .bodyEn,
                                                          style: const TextStyle(
                                                              color: const Color(
                                                                  0xff2a2a2a),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontFamily:
                                                                  "Neckar",
                                                              fontStyle:
                                                                  FontStyle
                                                                      .normal,
                                                              fontSize: 12.0),
                                                          textAlign:
                                                              TextAlign.left,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: _height * 0.09,
                                                    width: _width * 0.2,
                                                    decoration: BoxDecoration(
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                _notificationsModel!
                                                                    .data[index]
                                                                    .bookImage
                                                                    .toString()),
                                                            fit: BoxFit.cover)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Padding(
                                            //   padding: EdgeInsets.only(
                                            //       top: _height * 0.01,
                                            //       bottom: _height * 0.01),
                                            //   child: Opacity(
                                            //     opacity: 0.5,
                                            //     child: Container(
                                            //         width: _width,
                                            //         height: 1,
                                            //         decoration: BoxDecoration(
                                            //             color:
                                            //                 const Color(0xffbcbcbc))),
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                      ),
                    )
              : Center(
                  child: Text("No Internet Connection!"),
                ),
        ));
  }

  Future Notifications() async {
    print(
        "notifications count2 = ${context.read<UserProvider>().getNotificationCount}");
    final response =
        await http.get(Uri.parse(ApiUtils.ALL_NOTIFICATIONS), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _notificationsModel = notificationsModelFromJson(jsonData);
        setState(() {
          _isLoading = false;
        });
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future NotificationsSeen() async {
    final response =
        await http.get(Uri.parse(ApiUtils.SEEN_NOTIFICATIONS_COUNT), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('seen_notification_call_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        print("done_notification set to zero");
      } else {}
    }
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
      Notifications();
      NotificationsSeen();
    }
  }
}
