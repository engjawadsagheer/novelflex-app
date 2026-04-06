import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:novelflex/MixScreens/ReplyCommentScreen.dart';
import 'package:novelflex/Provider/VariableProvider.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:transitioner/transitioner.dart';

import '../../Models/BookReviewModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../ad_helper.dart';
import '../../localization/Language/languages.dart';

class ShowAllReviewScreen extends StatefulWidget {
  String? bookId;
  String bookName;
  String bookImage;
  ShowAllReviewScreen(
      {required this.bookId, required this.bookName, required this.bookImage});

  @override
  State<ShowAllReviewScreen> createState() => _ShowAllReviewScreenState();
}

class _ShowAllReviewScreenState extends State<ShowAllReviewScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController? _descriptionController;
  Stream? stream;
  bool likes = false;

  @override
  void initState() {
    _descriptionController = new TextEditingController();
    _listener();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: const Color(0xffebf5f9),
        appBar: AppBar(
          toolbarHeight: _height * 0.07,
          backgroundColor: const Color(0xffebf5f9),
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: Colors.black,
            ),
          ),
          title: Text(
            widget.bookName,
            style: TextStyle(color: Colors.black54),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: stream,
            builder: (context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                  context.read<UserProvider>().UserImage == null
                                      ? ""
                                      : context
                                          .read<UserProvider>()
                                          .UserImage
                                          .toString()),
                            ),
                            Container(
                              width: _width * 0.6,
                              child: TextField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                    hintText:
                                        Languages.of(context)!.post_comment),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (_descriptionController!.text.isNotEmpty) {
                                  sendPost();
                                  _descriptionController!.clear();
                                }
                              },
                              icon: Icon(Icons.send),
                            )
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (
                                context,
                                index,
                              ) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: _height * 0.05),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: _height * _width * 0.00005,
                                            backgroundImage: NetworkImage(
                                                snapshot.data.docs[index]
                                                    ['url']),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FittedBox(
                                                  child: Text(
                                                      snapshot.data.docs[index]
                                                          ['postedby'])),
                                              SizedBox(
                                                height: _height * 0.01,
                                              ),
                                              FittedBox(
                                                  child: Text(
                                                      snapshot.data.docs[index]
                                                          ['comments'])),
                                              SizedBox(
                                                height: _height * 0.01,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Text(
                                                        parseTimeStamp(snapshot
                                                                .data
                                                                .docs[index]
                                                            ['time']),
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black26,
                                                            fontSize: 10)),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Transitioner(
                                                        context: context,
                                                        child: ReplyComment(
                                                          bookId: widget.bookId,
                                                          bookName:
                                                              widget.bookName,
                                                          bookImag:
                                                              widget.bookImage,
                                                          commentID: snapshot
                                                                  .data
                                                                  .docs[index]
                                                              ['id'],
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
                                                    child: Text(
                                                      Languages.of(context)!
                                                          .reply,
                                                      style: TextStyle(
                                                          color: Colors
                                                              .deepPurpleAccent,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              if (snapshot.data.docs[index]
                                                      ['likes'] ==
                                                  1) {
                                                setState(() {
                                                  updateLikes(
                                                      snapshot.data.docs[index]
                                                          ['id'],
                                                      0);
                                                });
                                              } else {
                                                setState(() {
                                                  updateLikes(
                                                      snapshot.data.docs[index]
                                                          ['id'],
                                                      1);
                                                });
                                              }
                                            },
                                            child: snapshot.data.docs[index]
                                                        ['likes'] ==
                                                    1
                                                ? Icon(
                                                    Icons.favorite,
                                                    color: Colors.red,
                                                    size: 30,
                                                  )
                                                : Icon(
                                                    Icons
                                                        .favorite_outline_rounded,
                                                    size: 30,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    )
                  : Center(
                      child: CupertinoActivityIndicator(),
                    );
            }));
  }

  String parseTimeStamp(int value) {
    var date = DateTime.fromMillisecondsSinceEpoch(value);
    var d12 = DateFormat('MM-dd-yyyy, hh:mm a').format(date);
    return d12;
  }

  _listener() {
    stream = _firestore
        .collection("Comments")
        .doc(widget.bookId)
        .collection("data")
        .orderBy("time", descending: true)
        .snapshots();

    stream!.listen((data) {
      print(data.size);
    });
  }

  sendPost() async {
    print(context.read<UserProvider>().UserImage.toString());
    String id = DateTime.now().microsecondsSinceEpoch.toString() +
        context.read<UserProvider>().UserID.toString();

    _firestore
        .collection("Comments")
        .doc(widget.bookId)
        .collection("data")
        .doc(id)
        .set({
      "comments": _descriptionController!.text.trim().toString(),
      "comment_id":
          context.read<UserProvider>().UserEmail!.toString() + widget.bookId!,
      "time": DateTime.now().millisecondsSinceEpoch,
      "url": context.read<UserProvider>().UserImage == null
          ? ""
          : context.read<UserProvider>().UserImage.toString(),
      "postedby": context.read<UserProvider>().UserName!.toString(),
      "likes": 0,
      "views": 0,
      "id": id,
    });
  }

  updateLikes(var post_id, int value) async {
    _firestore
        .collection("Comments")
        .doc(widget.bookId)
        .collection("data")
        .doc(post_id)
        .update({
      "likes": value,
    });
  }
}
