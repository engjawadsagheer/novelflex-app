import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';

import '../../Models/GeneralCategoriesNameModel.dart';
import '../../Models/SubCategoriesModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../localization/Language/languages.dart';
import '../BooksScreens/BookDetail.dart';
import '../BooksScreens/BookDetailsAuthor.dart';

class GeneralCategoriesScreen extends StatefulWidget {
  String categories_id;
  GeneralCategoriesScreen({Key? key, required this.categories_id})
      : super(key: key);

  @override
  State<GeneralCategoriesScreen> createState() =>
      _GeneralCategoriesScreenState();
}

class _GeneralCategoriesScreenState extends State<GeneralCategoriesScreen> {
  int? _value = 0;
  GeneralCategoriesNameModel? _generalCategoriesNameModel;
  SubCategoriesModel? _subCategoriesModel;
  bool _isLoading = false;
  bool _isMainLoading = false;
  bool _isInternetConnected = true;

  @override
  void initState() {
    _checkInternetConnection(widget.categories_id);
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
            child: _isInternetConnected
                ? _isMainLoading
                    ? Container()
                    : Text(
                        _generalCategoriesNameModel!.data![0]!.title.toString(),
                        style: const TextStyle(
                            color: const Color(0xff2a2a2a),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Alexandria",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                      )
                : Center(
                    child: Constants.InternetNotConnected(_height * 0.03),
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
            child: _isInternetConnected
                ? _isMainLoading
                    ? const Align(
                        alignment: Alignment.center,
                        child: CupertinoActivityIndicator(
                          color: Color(0xff1b4a6b)
                        ),
                      )
                    : ListView(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: [
                          Wrap(
                            direction: Axis.horizontal,
                            children: List.generate(
                              _generalCategoriesNameModel!
                                  .data![0]!.productSubCategories!.length,
                              (int index) {
                                // choice chip allow us to
                                // set its properties.
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ChoiceChip(
                                    backgroundColor: Colors.black38,
                                    padding: EdgeInsets.all(_width * 0.04),
                                    label: Text(
                                      context
                                                  .read<UserProvider>()
                                                  .SelectedLanguage ==
                                              'English'
                                          ? _generalCategoriesNameModel!
                                              .data![0]!
                                              .productSubCategories![index]!
                                              .subTitle
                                              .toString()
                                          : _generalCategoriesNameModel!
                                              .data![0]!
                                              .productSubCategories![index]!
                                              .subTitleAr
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
                                    shadowColor:Color(0xff1b4a6b),
                                    surfaceTintColor: Color(0xff6499bc),
                                    selected: _value == index,
                                    onSelected: (bool selected) {
                                      setState(() {
                                        _value = selected ? index : null;
                                        // index== 0 ? _checkInternetConnectionSubCategories("1") : _checkInternetConnectionSubCategories("${_value!+1}");
                                        _checkInternetConnectionSubCategories(_generalCategoriesNameModel!
                                            .data![0]!
                                            .productSubCategories![index]!
                                            .id
                                            .toString());

                                      });
                                    },
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ],
                      )
                : Center(
                    child: Constants.InternetNotConnected(_height * 0.03),
                  ),
          ),

          Expanded(
            flex: 8,
            child: _isInternetConnected
                ? _isMainLoading ?  Container() : _isLoading
                ? const Align(
              alignment: Alignment.center,
              child: CupertinoActivityIndicator(
                color:Color(0xff1b4a6b)
              ),
            )
                : _subCategoriesModel!.data!.length == 0
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
              crossAxisCount: 3,
              childAspectRatio: 0.78,
              mainAxisSpacing: _height * 0.01,
              children: List.generate(_subCategoriesModel!.data!.length, (index) {
                return Container(
                  margin: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (){
                      Transitioner(
                        context: context,
                        child: BookDetail(
                          bookID: _subCategoriesModel!.data![index]!.id.toString(),
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
                      mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: _width * 0.25,
                            height: _height * 0.13,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                // image: DecorationImage(
                                //     image: NetworkImage(
                                //         _subCategoriesModel!.data![index]!.imagePath.toString()),
                                //     fit: BoxFit.cover),
                                color: Colors.green),
                        child: CachedNetworkImage(
                          filterQuality:
                          FilterQuality.high,
                          imageBuilder:
                              (context, imageProvider) =>
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover),
                                ),
                              ),
                          imageUrl:  _subCategoriesModel!.data![index]!.imagePath.toString(),
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
                        ),),
                        SizedBox(
                          height: _height * 0.01,
                        ),
                        Expanded(
                          child: Center(
                            child: Text(_subCategoriesModel!.data![index]!.title.toString(),
                                style: const TextStyle(
                                    color: const Color(0xff2a2a2a),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Alexandria",
                                    fontStyle: FontStyle.normal,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.left),
                          ),
                        ),
                        // Expanded(
                        //     child: Text(_subCategoriesModel!.data![index]!.user![0]!.authorName.toString(),
                        //         style: const TextStyle(
                        //             color: const Color(0xff676767),
                        //             fontWeight: FontWeight.w400,
                        //             fontFamily: "Lato",
                        //             fontStyle: FontStyle.normal,
                        //             fontSize: 12.0),
                        //         textAlign: TextAlign.left)),
                      ],
                    ),
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
    var map = Map<String, dynamic>();
    map['category_id'] = _id.toString();

    final response = await http.post(
      Uri.parse(ApiUtils.GENERAL_CATEGORIES_NAME_API),
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
        _generalCategoriesNameModel =
            generalCategoriesNameModelFromJson(jsonData);
        setState(() {
          _isMainLoading = false;
        });

        switch (_generalCategoriesNameModel!.data![0]!.title) {
          case 'Manga':
            _checkInternetConnectionSubCategories("1");
            break;

          case 'Novels':
            _checkInternetConnectionSubCategories("14");
            break;

          case 'Manhwa':
            _checkInternetConnectionSubCategories("6");
            break;

          case 'Comics':
            _checkInternetConnectionSubCategories("10");
            break;

          case 'Disney Classic':
            _checkInternetConnectionSubCategories("18");
            break;
          case 'Maravel':
            _checkInternetConnectionSubCategories("22");
            break;

          case 'Bandes dessinees':
            _checkInternetConnectionSubCategories("26");
            break;

          default:
            _checkInternetConnectionSubCategories("1");
        }



      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isMainLoading = false;
        });
      }
    }
  }

  Future _checkInternetConnection(var id) async {
    if (this.mounted) {
      setState(() {
        _isMainLoading = true;
      });
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      Constants.showToastBlack(context, "Internet not connected");
      if (this.mounted) {
        setState(() {
          _isMainLoading = false;
          _isInternetConnected = false;
        });
      }
    } else {
      SearchCategoriesApiCall(id);
    }
  }

  Future SearchSubCategoriesApiCall(var _id) async {

    var map = Map<String, dynamic>();
    map['subcategory_id'] = _id.toString();

    final response = await http.post(
      Uri.parse(ApiUtils.SEARCH_SUB_CATEGORIES_API),
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
        _subCategoriesModel =
            subCategoriesModelFromJson(jsonData);
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

  Future _checkInternetConnectionSubCategories(var id) async {
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
      SearchSubCategoriesApiCall(id);
    }
  }
}
