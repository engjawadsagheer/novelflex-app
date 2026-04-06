import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transitioner/transitioner.dart';
import '../../Models/BookEditModel.dart';
import '../../Models/UploadBooksModel.dart';
import '../../Models/UserUploadHistoryModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/loading_widgets.dart';
import '../../localization/Language/languages.dart';
import '../BooksScreens/BookDetail.dart';
import '../BooksScreens/BookDetailsAuthor.dart';
import '../BookEditScreens/BookDetailEditScreen.dart';
import 'BookUploadEditTabScreen.dart';
import 'UploadDataScreen.dart';

class UploadHistoryscreen extends StatefulWidget {
  int route;
   UploadHistoryscreen({Key? key,required this.route}) : super(key: key);

  @override
  State<UploadHistoryscreen> createState() => _UploadHistoryscreenState();
}

class _UploadHistoryscreenState extends State<UploadHistoryscreen> {
  UploadBooksModel? _userUploadHistoryModel;

  bool _isLoading = false;
  String? token;
  bool _isInternetConnected = true;
  bool _apiLoader=false;

  List<File>? DocumentFilesList;
  int fileLength = 0;
  bool docUploader= false;
  BookEditModel? _bookEditModel;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();

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
                          offset:
                          const Offset(0, 3), // changes position of shadow
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
            ?  Align(
          alignment: Alignment.center,
          child:   CustomCard(gif: MoreLoadingGif(type: MoreLoadingGifType.eclipse,
            size: _height*_width*0.0002,), text: 'Loading',),



        ) : _userUploadHistoryModel!.data.length==0
            ? Center(
          child: Text(
            Languages.of(context)!.nouploadhistory,
            style: const TextStyle(
                fontFamily: Constants.fontfamily,
                color: Colors.black54),
          ),
        )
            :Stack(
              children: [
                Positioned(
                  child: ListView.builder(
                  itemCount:_userUploadHistoryModel!.data.length,
                  itemBuilder: (BuildContext context, index){
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    BookDetail(
                                      bookID:
                                      '${_userUploadHistoryModel!.data[index].id}',
                                    )));
                      },
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 1,
                        shadowColor: Colors.white,
                        child: Container(
                          height: _height*0.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [

                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        height: _height*0.15,
                                        width: _width*0.25,
                                        decoration: BoxDecoration(
                                          color: Colors.black12,
                                          image: DecorationImage(
                                              image: NetworkImage(_userUploadHistoryModel!.data![index]!.imagePath.toString(),
                                              ),
                                              fit: BoxFit.cover
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: widget.route==0,
                                      child: GestureDetector(
                                        onTap: (){
                                          showDialog(_userUploadHistoryModel!.data[index].id.toString());
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5.0),
                                              color: Color(0xFF256D85),
                                            ),
                                            height: _height*0.04,
                                            width: _width*0.25,
                                            child: Center(child: Padding(
                                              padding: const EdgeInsets.only(left: 15),
                                              child: Center(child: Text(Languages.of(context)!.deleteb,style: TextStyle(fontFamily: Constants.fontfamily,color: Colors.white),)),
                                            ))),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  // margin: EdgeInsets.only(bottom: _height*0.02),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // SizedBox(height: _height*0.05,),
                                      // SizedBox(height: 10.0,),
                                      Text(_userUploadHistoryModel!.data[index].title.toString(),style: const TextStyle(
                                        fontSize: 15,fontWeight: FontWeight.w700,
                                        fontFamily: Constants.fontfamily,

                                      ),),
                                      // SizedBox(height: _height*0.07,),
                                      // Text('Modified Date: ${_userUploadHistoryModel!.data![index].modifiedDate.toString()}',),
                                      Text('Published Date: ${ DateFormat('dd-MM-yyyy').format(_userUploadHistoryModel!.data![index]!.createdAt!.toUtc())}',overflow: TextOverflow.clip,style: TextStyle(fontFamily: Constants.fontfamily,color: Colors.black),),
                                      const SizedBox(height: 1.0,),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){

                                  widget.route==0 ? Transitioner(
                                    context: context,
                                    child: BookDetailEditScreen(
                                      BookID:
                                      '${_userUploadHistoryModel!.data[index].id}',
                                    ),
                                    animation: AnimationType.slideLeft,
                                    // Optional value
                                    duration: Duration(milliseconds: 1000),
                                    // Optional value
                                    replacement: false,
                                    // Optional value
                                    curveType: CurveType.decelerate, // Optional value
                                  ) : _callBookDetailsEditAPI(_userUploadHistoryModel!.data[index].id);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: Color(0xFF256D85),
                                  ),
                                  height: _height*0.04,
                                  width: widget.route==0 ? _width*0.25 : _width*0.3,

                                  margin: EdgeInsets.only(top: _height*0.22,right: _width*0.1,left: _width*0.03),
                                  child: Center(
                                    child: Text(  widget.route==0 ? Languages.of(context)!.editT :Languages.of(context)!.addEpisodes ,textAlign: TextAlign.end,
                                      style: const TextStyle(fontSize: 15,color: Colors.white,fontFamily: Constants.fontfamily,),),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );

                  }),
                ),
                Visibility(
                  visible: _apiLoader,
                  child: Positioned(
                    top: _height*0.4,
                      left: _width*0.4,
                      child: Align(
                    alignment: Alignment.center,
                    child:   CustomCard(gif: MoreLoadingGif(type: MoreLoadingGifType.eclipse,
                      size: _height*_width*0.0002,), text: 'Loading',),



                  ) ),
                )
              ],
            )
    );
}



  Future RecentApiCall() async {
    final response =
    await http.get(Uri.parse(ApiUtils.UPLOAD_BOOKS_HISTORY), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('upload_history_books_response${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _userUploadHistoryModel = uploadBooksModelFromJson(jsonData);
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

  Future DELETE_BOOK_API(var id) async {
    setState(() {
      _isLoading = true;
    });
    var map = Map<String, dynamic>();
    map['bookId'] = id;

    final response = await http.post(
      Uri.parse(ApiUtils.DELETE_BOOK_API),
      body: map,
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        }
    );

    var jsonData;

    if (response.statusCode == 200) {
      //Success

      jsonData = json.decode(response.body);
      print('loginSuccess_data: $jsonData');
      if (jsonData['status'] == 200) {
        
        ToastConstant.showToast(context, "Book Delete successfully");

        setState(() {
          _isLoading = false;
        });
        _checkInternetConnection();
      } else {
        ToastConstant.showToast(context, jsonData['message']);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ToastConstant.showToast(context, "Internet Server Error!");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showDialog(var id) {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            Languages.of(context)!.deleteb,
            style: TextStyle(fontFamily: Constants.fontfamily),
          ),
          content: Text(
           "",
            style: TextStyle(fontFamily: Constants.fontfamily),
          ),
          actions: [
            CupertinoDialogAction(
                child: Text(
                  Languages.of(context)!.yes,
                  style: TextStyle(fontFamily: Constants.fontfamily),
                ),
                onPressed: () {

                  DELETE_BOOK_API(id);
                  Navigator.pop(context);
                }),
            CupertinoDialogAction(
              child: Text(
                Languages.of(context)!.no,
                style: TextStyle(fontFamily: Constants.fontfamily),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  Future _callBookDetailsEditAPI(var BookId) async {

    setState(() {
      _apiLoader=true;
    });

    var map = Map<String, dynamic>();
    map['bookId'] = BookId.toString();

    final response = await http
        .post(Uri.parse(ApiUtils.EDIT_BOOKS_API), body: map, headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('EditBook_response under 200 ${response.body}');
      var jsonData = json.decode(response.body);
      _bookEditModel = BookEditModel.fromJson(jsonData);
      Transitioner(
        context: context,
        child: BookUploadEditTabScreen(
            bookId: _bookEditModel!.data!.id.toString(),
            route: 1,
            Chapters: _bookEditModel!.data!.chapter?.toList()
        ),
        animation: AnimationType.slideLeft, // Optional value
        duration: Duration(milliseconds: 1000), // Optional value
        replacement: true, // Optional value
        curveType: CurveType.decelerate, // Optional value
      );
      setState(() {
        _apiLoader=false;
      });

    } else {
      Constants.showToastBlack(context, "Slow Connection");
      setState(() {
        _apiLoader=false;
      });
    }
  }


}
