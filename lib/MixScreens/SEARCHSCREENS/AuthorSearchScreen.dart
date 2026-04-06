import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:novelflex/localization/Language/languages.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:transitioner/transitioner.dart';
import '../../Models/SearchAuthorbyCategoriesIdModel.dart';
import '../../Models/SearchCategoriesModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/loading_widgets.dart';
import '../BooksScreens/AuthorViewByUserScreen.dart';

class AuthorSearchScreen extends StatefulWidget {
  SearchCategoriesModel searchCategoriesModel;
  AuthorSearchScreen({Key? key, required this.searchCategoriesModel})
      : super(key: key);

  @override
  State<AuthorSearchScreen> createState() => _AuthorSearchScreenState();
}

class _AuthorSearchScreenState extends State<AuthorSearchScreen> {
  int? _value = 0;
  SearchAuthorbyCategoriesIdModel? _searchAuthorbyCategoriesIdModel;
  bool _isLoading = false;
  bool _isInternetConnected = true;
  bool? FollowOrUnfollow;

  @override
  void initState() {
    _checkInternetConnection("1");
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
              size: _height * _width * 0.00005,
            )),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: _height * 0.02),
            child: Text(
              Languages.of(context)!.author,
              style: const TextStyle(
                  color: const Color(0xff2a2a2a),
                  fontWeight: FontWeight.w700,
                  fontFamily: "Alexandria",
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0),
            ),
          ),
          SizedBox(
            width: _width * 0.03,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                Wrap(
                  direction: Axis.horizontal,
                  children: List.generate(
                    widget.searchCategoriesModel.data!.length,
                    (int index) {
                      // choice chip allow us to
                      // set its properties.
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ChoiceChip(
                          backgroundColor: Colors.black38,
                          padding: EdgeInsets.all(_width * 0.04),
                          label: Text(
                            context.read<UserProvider>().SelectedLanguage ==
                                    'English'
                                ? widget
                                    .searchCategoriesModel.data![index]!.title
                                    .toString()
                                : widget
                                    .searchCategoriesModel.data![index]!.titleAr
                                    .toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Alexandria",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                          ),
                          // color of selected chip
                          selectedColor: const Color(0xff3a6c83),
                          selected: _value == index,
                          onSelected: (bool selected) {
                            setState(() {
                              _value = selected ? index : null;
                              _value == 0
                                  ? _checkInternetConnection('1')
                                  : _checkInternetConnection("${_value! + 1}");
                            });
                          },
                        ),
                      );
                    },
                  ).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 8,
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
                    : _searchAuthorbyCategoriesIdModel!.data!.length == 0
                        ? Center(
                            child: Text(
                              Languages.of(context)!.nouploadhistory,
                              style: const TextStyle(
                                  color: const Color(0xff3a6c83),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Lato",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                            ),
                          )
                        : GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            mainAxisSpacing: _height * 0.02,
                            crossAxisSpacing: _width * 0.01,
                            children: List.generate(
                                _searchAuthorbyCategoriesIdModel!.data!.length,
                                (index) {
                              return Container(
                                margin: EdgeInsets.only(left: 8.0, right: 8.0),
                                width: _width * 0.3,
                                height: _height * 0.4,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color(0x12000000),
                                          offset: Offset(0, 13),
                                          blurRadius: 24,
                                          spreadRadius: 0)
                                    ],
                                    color: const Color(0xffffffff)),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: _width * 0.02,
                                          bottom: _height * 0.01),
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            child: CircleAvatar(
                                              backgroundColor: Colors.black38,
                                              child: CachedNetworkImage(
                                                filterQuality:
                                                    FilterQuality.high,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    // borderRadius:
                                                    // BorderRadius.circular(
                                                    //     10),
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                imageUrl:
                                                    _searchAuthorbyCategoriesIdModel!
                                                        .data![index]!.userimage
                                                        .toString(),
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CupertinoActivityIndicator(
                                                  color: Color(0xFF256D85),
                                                )),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    const Center(
                                                        child: Icon(Icons
                                                            .error_outline)),
                                              ),

                                              // NetworkImage(
                                              //     _searchAuthorbyCategoriesIdModel!
                                              //         .data![index]!.userimage
                                              //         .toString()),
                                              radius:
                                                  _height * _width * 0.000095,
                                            ),
                                          ),
                                          Positioned(
                                              top: _height * 0.068,
                                              left: _width * 0.015,
                                              child: Container(
                                                width: _width * 0.12,
                                                height: _height * 0.023,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    border: Border.all(
                                                        color: const Color(
                                                            0xffffffff),
                                                        width: 1),
                                                  gradient: LinearGradient(
                                                      begin: Alignment(-0.01018629550933838,
                                                          -0.01894212305545807),
                                                      end: Alignment(1.6960868120193481,
                                                          1.3281718730926514),
                                                      colors: [
                                                        Color(0xff246897),
                                                        Color(0xff1b4a6b),
                                                      ]),),
                                                child: Center(
                                                  child: Text(
                                                      "${Languages.of(context)!.level + " " + _searchAuthorbyCategoriesIdModel!.data![index]!.level.toString()}",
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xffffffff),
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily:
                                                              "Alexandria",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 10.0),
                                                      textAlign:
                                                          TextAlign.right),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    Text(
                                        _searchAuthorbyCategoriesIdModel!
                                            .data![index]!.authorName
                                            .toString(),
                                        style: const TextStyle(
                                            color: const Color(0xff202124),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Neckar",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                        textAlign: TextAlign.center),
                                    Opacity(
                                      opacity: 0.20000000298023224,
                                      child: Container(
                                          width: 145.4141845703125,
                                          height: 1,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff707070))),
                                    ),
                                    Text("#Manga",
                                        style: const TextStyle(
                                            color: const Color(0xff3a6c83),
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Lato",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 10.0),
                                        textAlign: TextAlign.left),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                Languages.of(context)!
                                                    .followers,
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff202124),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Alexandria",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 10.0),
                                                textAlign: TextAlign.right),
                                            SizedBox(
                                              height: _height * 0.01,
                                            ),
                                            Text(
                                                _searchAuthorbyCategoriesIdModel!
                                                    .data![index]!.subscription
                                                    .toString(),
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff202124),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Alexandria",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 10.0),
                                                textAlign: TextAlign.right)
                                          ],
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                Languages.of(context)!
                                                    .published,
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff202124),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Alexandria",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 10.0),
                                                textAlign: TextAlign.right),
                                            SizedBox(
                                              height: _height * 0.01,
                                            ),
                                            Text(
                                                _searchAuthorbyCategoriesIdModel!
                                                    .data![index]!.publication
                                                    .toString(),
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff202124),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Alexandria",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 10.0),
                                                textAlign: TextAlign.right)
                                          ],
                                        )
                                      ],
                                    ),
                                    Opacity(
                                      opacity: 0.20000000298023224,
                                      child: Container(
                                          width: 145.4141845703125,
                                          height: 1,
                                          decoration: BoxDecoration(
                                              color: const Color(0xff707070))),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Transitioner(
                                          context: context,
                                          child: AuthorViewByUserScreen(
                                            user_id:
                                                _searchAuthorbyCategoriesIdModel!
                                                    .data![index]!.userId
                                                    .toString(),
                                          ),
                                          animation: AnimationType.fadeIn,
                                          duration:
                                              Duration(milliseconds: 1000),
                                          replacement: false,
                                          curveType: CurveType.decelerate,
                                        );
                                      },
                                      child: Container(
                                        width: 144,
                                        height: 34,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(17)),
                                          gradient: LinearGradient(
                                              begin: Alignment(-0.01018629550933838,
                                                  -0.01894212305545807),
                                              end: Alignment(1.6960868120193481,
                                                  1.3281718730926514),
                                              colors: [
                                                Color(0xff246897),
                                                Color(0xff1b4a6b),
                                              ]),
                                           ),
                                        child: Center(
                                          child: Text(
                                              Languages.of(context)!.profile,
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xffffffff),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Alexandria",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 11.0),
                                              textAlign: TextAlign.left),
                                        ),
                                      ),
                                    ),
                                    SizedBox()
                                  ],
                                ),
                              );
                            }),
                          )
                : Center(
                    child: Constants.InternetNotConnected(_height * 0.03),
                  ),
          ),
        ],
      ),
    );
  }

  Future SearchCategoriesApiCall(var _id) async {
    setState(() {
      _isLoading = true;
    });
    var map = Map<String, dynamic>();
    map['category_id'] = _id.toString();

    final response = await http.post(
      Uri.parse(ApiUtils.SEARCH_AUTHOR_BY_CATEGORIES_ID_API),
      headers: {
        'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
      },
      body: map,
    );

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _searchAuthorbyCategoriesIdModel =
            searchAuthorbyCategoriesIdModelFromJson(jsonData);
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

  Future _checkInternetConnection(var id) async {
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
      SearchCategoriesApiCall(id);
    }
  }
}
