import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';
import '../Models/SeeAllModel.dar.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../localization/Language/languages.dart';
import 'BooksScreens/BookDetail.dart';
import 'BooksScreens/BookDetailsAuthor.dart';

class SeeAllBookScreen extends StatefulWidget {
  String? categoriesId;
  SeeAllBookScreen({required this.categoriesId});

  @override
  State<SeeAllBookScreen> createState() => _SeeAllBookScreenState();
}

class _SeeAllBookScreenState extends State<SeeAllBookScreen> {
  SeeAllBooksModelClass? _seeAllBooksModelClass;
  bool _isLoading = false;
  bool _isInternetConnected = true;

  @override
  void initState() {
    super.initState();
    print("seeAllCategories_id= ${widget.categoriesId}");
    _checkInternetConnection();
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
      ALLBOOKSApiCall();
    }
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
        toolbarHeight: _height * 0.05,
      ),
      body: _isInternetConnected == false
          ? SafeArea(
              child: Center(
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
                              offset: const Offset(
                                  0, 3), // changes position of shadow
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
              ),
            )
          : _isLoading
              ? const Align(
                  alignment: Alignment.center,
                  child: const Align(
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(),
                  ))
              : _seeAllBooksModelClass!.data.length == 0
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
                      ))
                  : Padding(
                      padding: EdgeInsets.only(top: _height * 0.02),
                      child: Column(
                        children: [
                          Expanded(
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
                                    _seeAllBooksModelClass!.data.length,
                                    (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Transitioner(
                                        context: context,
                                        child: BookDetail(
                                          bookID: _seeAllBooksModelClass!
                                              .data[index].id
                                              .toString(),
                                        ),
                                        animation: AnimationType
                                            .slideTop, // Optional value
                                        duration: Duration(
                                            milliseconds:
                                                1000), // Optional value
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
                                                borderRadius:
                                                    BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        _seeAllBooksModelClass!
                                                            .data[index]
                                                            .imagePath
                                                            .toString()),
                                                    fit: BoxFit.cover),
                                                color: Colors.green)),
                                        SizedBox(
                                          height: _height * 0.01,
                                        ),
                                        Expanded(
                                          child: Text(
                                              _seeAllBooksModelClass!
                                                  .data[index].title
                                                  .toString(),
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff2a2a2a),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Alexandria",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 12.0),
                                              textAlign: TextAlign.left),
                                        ),
                                        Expanded(
                                            child: Text(
                                                "${_seeAllBooksModelClass!
                                                    .data[index]
                                                    .user[0]
                                                    .username.toString()}",
                                                style: const TextStyle(
                                                    color:
                                                        const Color(0xff676767),
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: "Lato",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 12.0),
                                                textAlign: TextAlign.left)),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          )
                        ],
                      )),
    );
  }

  Future ALLBOOKSApiCall() async {
    var map = Map<String, dynamic>();
    map['category_id'] = widget.categoriesId.toString();

    final response = await http.post(
      Uri.parse(ApiUtils.ALL_BOOKS_CATEGORIES_API),
      headers: {
        // 'Content-Type': 'application/json',
        // 'Accept': 'application/json',
        'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
      },
      body: map,
    );

    if (response.statusCode == 200) {
      print('see_all_books_categories_wise_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _seeAllBooksModelClass = seeAllBooksModelClassFromJson(jsonData);
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
}
