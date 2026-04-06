import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:transitioner/transitioner.dart';
import '../Models/AllRecentModel.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../Widgets/loading_widgets.dart';
import 'BooksScreens/BookDetail.dart';
import 'BooksScreens/BookDetailsAuthor.dart';
import '../localization/Language/languages.dart' as lang;

class RecentNovelsScreen extends StatefulWidget {
  const RecentNovelsScreen({Key? key}) : super(key: key);

  @override
  State<RecentNovelsScreen> createState() => _RecentNovelsScreenState();
}

class _RecentNovelsScreenState extends State<RecentNovelsScreen> {
  AllRecentModel? _allrecentModel;
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
          title: Text(
            lang.Languages.of(context)!.recentlyPublish,
            style: const TextStyle(
                color: const Color(0xff2a2a2a),
                fontWeight: FontWeight.w700,
                fontFamily: "Alexandria",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
          ),
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
                  : Column(
                      children: [
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: _height * 0.02,
                                left: _width * 0.03,
                                right: _width * 0.01),
                            child: GridView.count(
                              physics: BouncingScrollPhysics(),
                              crossAxisCount: 3,
                              childAspectRatio: 0.78,
                              mainAxisSpacing: _height * 0.01,
                              children: List.generate(
                                  _allrecentModel!.data.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    Transitioner(
                                      context: context,
                                      child: BookDetail(
                                        bookID: _allrecentModel!.data[index].id
                                            .toString(),
                                      ),
                                      animation: AnimationType
                                          .slideTop, // Optional value
                                      duration: Duration(
                                          milliseconds: 1000), // Optional value
                                      replacement: false, // Optional value
                                      curveType: CurveType
                                          .decelerate, // Optional value
                                    );
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: _width * 0.25,
                                          height: _height * 0.13,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      _allrecentModel!
                                                          .data[index].imagePath
                                                          .toString()),
                                                  fit: BoxFit.cover),
                                              color: Colors.green)),
                                      SizedBox(
                                        height: _height * 0.01,
                                      ),
                                      Expanded(
                                        child: Text(
                                            _allrecentModel!.data[index].title
                                                .toString(),
                                            style: const TextStyle(
                                                color: const Color(0xff2a2a2a),
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Alexandria",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.left),
                                      ),
                                      // Expanded(
                                      //     child: Text(_allrecentModel!.data[index].user[1].username.toString(),
                                      //         style: const TextStyle(
                                      //             color: const Color(0xff676767),
                                      //             fontWeight: FontWeight.w400,
                                      //             fontFamily: "Lato",
                                      //             fontStyle: FontStyle.normal,
                                      //             fontSize: 12.0),
                                      //         textAlign: TextAlign.left)),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        )
                      ],
                    )
              : Center(
                  child: Text("No Internet Connection!"),
                ),
        ));
  }

  Future RecentApiCall() async {
    final response =
        await http.get(Uri.parse(ApiUtils.ALL_RECENT_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _allrecentModel = allRecentModelFromJson(jsonData);
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
      RecentApiCall();
    }
  }
}
