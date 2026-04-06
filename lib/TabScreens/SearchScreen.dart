import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:novelflex/MixScreens/SEARCHSCREENS/AuthorSearchScreen.dart';
import 'package:novelflex/Models/SearchCategoriesModel.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';

import '../MixScreens/BooksScreens/AuthorViewByUserScreen.dart';
import '../MixScreens/BooksScreens/BookDetailsAuthor.dart';
import '../MixScreens/SEARCHSCREENS/GeneralCategoriesSearchScreen.dart';
import '../Models/SearchAuthorModel.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../Widgets/loading_widgets.dart';
import '../localization/Language/languages.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchCategoriesModel? _searchCategoriesModel;
  SearchAuthorModel? _searchAuthorModel;
  List<SearchAuthorModel>? _searchAuthorModelList;
  bool _isLoading = false;
  bool _isInternetConnected = true;
  bool _isSearch = false;

  TextEditingController editingController = TextEditingController();

  List<Searching> searchingItem = [];

  var items = <Searching>[];

  @override
  void initState() {
    _checkInternetConnection();

    super.initState();
  }

  void filterSearchResults(String query) {
    List<Searching> dummySearchList = <Searching>[];
    dummySearchList.addAll(searchingItem);
    if (query.isNotEmpty) {
      List<Searching> dummyListData = <Searching>[];
      dummySearchList.forEach((item) {
        if (item.name!.contains(query)) {
          dummyListData.add(
              Searching(name: item.name, id: item.id, imageUrl: item.imageUrl));
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(searchingItem);
      });
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
        leading: Container(),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: _height * 0.02),
            child: Text("Search",
                style: const TextStyle(
                    color: const Color(0xff2a2a2a),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Alexandria",
                    fontStyle: FontStyle.normal,
                    fontSize: 16.0),
                textAlign: TextAlign.right),
          ),
          SizedBox(
            width: _width * 0.03,
          )
        ],
      ),
      body: _isInternetConnected
          ? _isLoading
              ? Align(
                  alignment: Alignment.center,
                  child: CustomCard(
                    gif: MoreLoadingGif(
                      type: MoreLoadingGifType.ripple,
                      size: _height * _width * 0.0002,
                    ),
                    text: 'Loading',
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: _height * 0.02,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: _width * 0.03,
                          right: _width * 0.03,
                          bottom: _height * 0.05),
                      height: _height * 0.06,
                      width: _width * 0.9,
                      child: TextFormField(
                        onTap: () {
                          setState(() {
                            _isSearch = !_isSearch;
                          });
                        },
                        controller: editingController,
                        onChanged: (value) {
                          filterSearchResults(value);
                        },
                        keyboardType: TextInputType.text,
                        textAlign: TextAlign.center,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xffebf5f9),
                          hintText: Languages.of(context)!.search,
                          hintStyle: const TextStyle(
                            fontFamily: Constants.fontfamily,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: _isSearch,
                      child: Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                print("ids: ${items[index].id.toString()}");
                                Transitioner(
                                  context: context,
                                  child: AuthorViewByUserScreen(
                                    user_id: items[index].id.toString(),
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
                              child: Container(
                                margin: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color(0xffebf5f9)),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: _height * _width * 0.00005,
                                    backgroundImage: NetworkImage(
                                        items[index].imageUrl.toString()),
                                  ),
                                  title: Text('${items[index].name}'),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !_isSearch,
                      child: GestureDetector(
                        onTap: () {
                          Transitioner(
                            context: context,
                            child: AuthorSearchScreen(
                              searchCategoriesModel: _searchCategoriesModel!,
                            ),
                            animation:
                                AnimationType.slideBottom, // Optional value
                            duration:
                                Duration(milliseconds: 1000), // Optional value
                            replacement: false, // Optional value
                            curveType: CurveType.decelerate, // Optional value
                          );
                        },
                        child: Stack(
                          children: [
                            Positioned(
                              child: Opacity(
                                opacity: 0.8799999952316284,
                                child: Container(
                                  width: _width * 0.92,
                                  height: _height * 0.18,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    image: DecorationImage(
                                        image: AssetImage(
                                          "assets/quotes_data/search_authorImg.jpeg",
                                        ),
                                        colorFilter: ColorFilter.mode(
                                          Colors.white.withOpacity(0.2),
                                          BlendMode.modulate,
                                        ),
                                        fit: BoxFit.cover),
                                    gradient: LinearGradient(
                                        begin: Alignment(-0.01018629550933838,
                                            -0.01894212305545807),
                                        end: Alignment(1.6960868120193481,
                                            1.3281718730926514),
                                        colors: [
                                          Color(0xff246897),
                                          Color(0xff1b4a6b),
                                        ]),
                                    // color: const Color(0xff3a6c83)
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                top: _height * 0.08,
                                left: _width * 0.38,
                                child: Text(Languages.of(context)!.author,
                                    style: const TextStyle(
                                        color: const Color(0xffffffff),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Neckar",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20.0),
                                    textAlign: TextAlign.center))
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !_isSearch,
                      child: Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: _height * 0.03,
                              left: context
                                          .read<UserProvider>()
                                          .SelectedLanguage ==
                                      'English'
                                  ? _width * 0.03
                                  : 0.0,
                              right: _width * 0.03),
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 0.98,
                            mainAxisSpacing: _height * 0.01,
                            children: List.generate(
                                _searchCategoriesModel!.data!.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  Transitioner(
                                    context: context,
                                    child: GeneralCategoriesScreen(
                                      categories_id: _searchCategoriesModel!
                                          .data![index]!.categoryId
                                          .toString(),
                                    ),
                                    animation: AnimationType
                                        .slideLeft, // Optional value
                                    duration: Duration(
                                        milliseconds: 1000), // Optional value
                                    replacement: false, // Optional value
                                    curveType:
                                        CurveType.decelerate, // Optional value
                                  );
                                },
                                child: Stack(
                                  children: [
                                    Positioned(
                                      child: Opacity(
                                        opacity: 0.8799999952316284,
                                        child: Container(
                                          width: _width * 0.43,
                                          height: _height * 0.2,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            gradient: LinearGradient(
                                                begin: Alignment(
                                                    -0.01018629550933838,
                                                    -0.01894212305545807),
                                                end: Alignment(
                                                    1.6960868120193481,
                                                    1.3281718730926514),
                                                colors: [
                                                  Color(0xff246897),
                                                  Color(0xff1b4a6b),
                                                ]),

                                            // color: const Color(0xff3a6c83)
                                          ),
                                          child: CachedNetworkImage(
                                            filterQuality: FilterQuality.high,
                                            fit: BoxFit.cover,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                shape: BoxShape.rectangle,
                                                // borderRadius:
                                                // BorderRadius.circular(
                                                //     10),
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    colorFilter:
                                                        ColorFilter.mode(
                                                      Colors.white
                                                          .withOpacity(0.2),
                                                      BlendMode.modulate,
                                                    ),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            imageUrl: _searchCategoriesModel!
                                                .data![index]!.imagePath
                                                .toString(),
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CupertinoActivityIndicator(
                                              color: Color(0xFF256D85),
                                            )),
                                            errorWidget: (context, url,
                                                    error) =>
                                                const Center(
                                                    child: Icon(
                                                        Icons.error_outline)),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: _height * 0.08,
                                        left: context
                                                    .read<UserProvider>()
                                                    .SelectedLanguage ==
                                                'English'
                                            ? _width * 0.05
                                            : 0.0,
                                        right: context
                                                    .read<UserProvider>()
                                                    .SelectedLanguage ==
                                                'Arabic'
                                            ? _width * 0.05
                                            : 0.0,
                                        child: Center(
                                          child: Text(
                                              context
                                                          .read<UserProvider>()
                                                          .SelectedLanguage ==
                                                      'English'
                                                  ? _searchCategoriesModel!
                                                      .data![index]!.title
                                                      .toString()
                                                  : _searchCategoriesModel!
                                                      .data![index]!.titleAr
                                                      .toString(),
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xffffffff),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Neckar",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 15.0),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              textAlign: TextAlign.center),
                                        ))
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    )
                  ],
                )
          : Center(
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
                  GestureDetector(
                    child: Container(
                      width: _width * 0.2,
                      height: _height * 0.058,
                      decoration: BoxDecoration(
                          color: const Color(0xFF256D85),
                          shape: BoxShape.circle),
                      child: const Center(
                        child: Icon(
                          Icons.sync,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _checkInternetConnection();
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Future SearchCategoriesApiCall() async {
    final response =
        await http.get(Uri.parse(ApiUtils.SEARCH_CATEGORIES_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _searchCategoriesModel = searchCategoriesModelFromJson(jsonData);
        SearchAuthors();
      } else {
        // ToastConstant.showToast(context, jsonData1['message'].toString());
        Constants.warning(context);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future SearchAuthors() async {
    final response =
        await http.get(Uri.parse(ApiUtils.SEARCH_AUTHORS), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _searchAuthorModel = searchAuthorModelFromJson(jsonData);

        searchingItem = List<Searching>.generate(
            _searchAuthorModel!.data.length,
            (i) => Searching(
                name: _searchAuthorModel!.data[i].username,
                id: _searchAuthorModel!.data[i].id.toString(),
                imageUrl: _searchAuthorModel!.data[i].profilePath.toString()));

        setState(() {
          items.addAll(searchingItem);
          _isLoading = false;
        });
      } else {
        // ToastConstant.showToast(context, jsonData1['message'].toString());
        Constants.warning(context);
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
        _isInternetConnected = true;
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
      SearchCategoriesApiCall();
    }
  }
}

class Searching {
  String? name;
  String? id;
  String? imageUrl;
  Searching({required this.name, required this.id, this.imageUrl});
}
