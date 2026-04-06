import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novelflex/MixScreens/pdfViewerScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:path/path.dart' as path;
import 'package:transitioner/transitioner.dart';

import '../../Models/BookEditModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button.dart';
import '../../localization/Language/languages.dart';
import '../Uploadscreens/UploadDatanextScreen.dart';
import '../Uploadscreens/BookUploadEditTabScreen.dart';

class BookDetailEditScreen extends StatefulWidget {
  String? BookID;

  BookDetailEditScreen({required this.BookID});
  @override
  State<BookDetailEditScreen> createState() => _BookDetailEditScreenState();
}

class _BookDetailEditScreenState extends State<BookDetailEditScreen> {
  bool _isLoading = false;
  bool _isDeleteLoading = false;
  bool _isImageLoading = false;
  bool _isInternetConnected = true;
  BookEditModel? _bookEditModel;
  var token;
  bool subscribe = false;
  File? imageFile;

  final _bookTitleKey = GlobalKey<FormFieldState>();
  final _descriptionKey = GlobalKey<FormFieldState>();
  TextEditingController? _bookTitleController;
  TextEditingController? _descriptionController;

  File? DocumentFilesList;
  int fileLength = 0;
  bool docUploader = false;

  @override
  void dispose() {
    _bookTitleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bookTitleController = new TextEditingController();
    _descriptionController = new TextEditingController();
    token = context.read<UserProvider>().UserToken.toString();
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
      _callBookDetailsEditAPI();
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
        ),
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
                ? const Align(
                    alignment: Alignment.center,
                    child: const Center(
                      child: CupertinoActivityIndicator(),
                    ))
                : Column(
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            child: Container(
                              height: _height * 0.23,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                  image: NetworkImage(
                                    _bookEditModel!.data!.imagePath.toString(),
                                  ),
                                  // fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: _height * 0.1,
                            left: _width * 0.4,
                            right: _width * 0.4,
                            child: GestureDetector(
                              onTap: () {
                                _getFromGallery();
                              },
                              child: Container(
                                height: _height * 0.1,
                                width: _width * 0.2,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black54),
                                child: _isImageLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Center(
                                        child: Icon(
                                          Icons.image,
                                          size: _height * _width * 0.0001,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: Container(
                          height: _height * 0.9,
                          child: ListView(
                            physics: ClampingScrollPhysics(),
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: _height * 0.5,
                                    width: _width,
                                    decoration: const BoxDecoration(
                                      color:  Color(0xffebf5f9),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(0),
                                          topRight: Radius.circular(0)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: _height * 0.04,
                                              left: _width * 0.02,
                                              right: _width * 0.02),
                                          height: _height * 0.07,
                                          width: _width * 0.95,
                                          child: TextFormField(
                                            key: _bookTitleKey,
                                            controller: _bookTitleController,
                                            keyboardType: TextInputType.text,
                                            textInputAction:
                                                TextInputAction.next,
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              // labelText: widget.labelText,
                                              hintText: Languages.of(context)!
                                                  .enterBookTitle,
                                              hintStyle: const TextStyle(
                                                fontFamily:
                                                    Constants.fontfamily,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF256D85)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF256D85)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: _height * 0.015,
                                              left: _width * 0.02,
                                              right: _width * 0.02),
                                          height: _height * 0.25,
                                          width: _width * 0.95,
                                          child: TextFormField(
                                            key: _descriptionKey,
                                            controller: _descriptionController,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: 10,
                                            textInputAction:
                                                TextInputAction.next,
                                            cursorColor: Colors.black,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.white,
                                              // labelText: widget.labelText,
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF256D85)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    width: 2,
                                                    color: Color(0xFF256D85)),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Visibility(
                                          visible: _isDeleteLoading,
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                top: _height * 0.02),
                                            child: const Center(
                                              child:
                                                  CupertinoActivityIndicator(),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [

                                      Container(
                                        margin: EdgeInsets.only(
                                            top: _height * 0.04,
                                            left: _width * 0.02,
                                            right: _width * 0.02),
                                        alignment: Alignment.center,
                                        height: _height * 0.05,
                                        width: _width * 0.95,
                                        child: ResuableMaterialButton(
                                          onpress: () {
                                            _callEditDescriptionAPI();
                                          },
                                          buttonname:
                                              Languages.of(context)!.next,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: _height * 0.1,
                                    color:  Color(0xffebf5f9),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ));
  }

  // show the dialog

  Future _callBookDetailsEditAPI() async {
    setState(() {
      _isLoading = true;
      _isInternetConnected = true;
    });

    var map = Map<String, dynamic>();
    map['bookId'] = widget.BookID;

    final response = await http
        .post(Uri.parse(ApiUtils.EDIT_BOOKS_API), body: map, headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('EditBook_response under 200 ${response.body}');
      var jsonData = json.decode(response.body);
      _bookEditModel = BookEditModel.fromJson(jsonData);
      _descriptionController!.text =
          _bookEditModel!.data!.description.toString();
      _bookTitleController!.text = _bookEditModel!.data!.title.toString();
      setState(() {
        _isLoading = false;
      });
    } else {
      Constants.showToastBlack(context, "Some things went wrong");
      setState(() {
        _isLoading = false;
      });
    }
  }

  _getFromGallery() async {
    final PickedFile? image =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (image != null) {
      imageFile = File(image.path);
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      final fileName = path.basename(imageFile!.path);
      final File localImage = await imageFile!.copy('$appDocPath/$fileName');

      // prefs!.setString("image", localImage.path);

      setState(() {
        imageFile = File(image.path);
      });
      UploadCoverImageApi();
    }
  }

  Future _callEditDescriptionAPI() async {
    setState(() {
      _isDeleteLoading = true;
    });
    var map = Map<String, dynamic>();
    map['title'] = _bookTitleController!.text.toString().trim();
    map['category_id'] = _bookEditModel!.data!.categoryId.toString();
    map['subcategory_id'] = _bookEditModel!.data!.subcategoryId.toString();
    map['description'] = _descriptionController!.text.toString().trim();
    map['bookId'] = _bookEditModel!.data!.id.toString();

    final response = await http
        .post(Uri.parse(ApiUtils.UPDATE_FIELDS_BOOK_API), body: map, headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    var jsonData;

    if (response.statusCode == 200) {
      //Success

      jsonData = json.decode(response.body);
      print('update_title_description_data: $jsonData');
      if (jsonData['status'] == 200) {
        setState(() {
          _isDeleteLoading = false;
        });
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
      } else {
        ToastConstant.showToast(context, jsonData['message']);
        setState(() {
          _isDeleteLoading = false;
        });
      }
    } else {
      ToastConstant.showToast(context, "Updates Successfully!");
      setState(() {
        _isDeleteLoading = false;
      });
    }
  }

  Future<void> UploadCoverImageApi() async {
    setState(() {
      _isImageLoading = true;
    });
    Map<String, String> headers = {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(ApiUtils.UPLOAD_BOOK_IMAGE));

    request.files.add(http.MultipartFile.fromBytes(
      "image",
      File(imageFile!.path)
          .readAsBytesSync(), //UserFile is my JSON key,use your own and "image" is the pic im getting from my gallary
      filename: "Image.jpg",
      contentType: MediaType('image', 'jpg'),
    ));
    request.fields['bookId'] = _bookEditModel!.data!.id.toString();
    request.headers.addAll(headers);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          print("Cover Image Update Successfully! ");
          print('book_cover_image_upload ' + response.body);
          Constants.showToastBlack(context, "Cover Image Update Successfully!");
          setState(() {
            _isImageLoading = false;
          });
          _callBookDetailsEditAPI();
        } else {
          setState(() {
            _isImageLoading = false;
          });
          Constants.showToastBlack(context, "sorry try again!");
        }
      });
    });
  }
}
