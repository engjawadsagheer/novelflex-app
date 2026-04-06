import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:novelflex/tab_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:ripple_wave/ripple_wave.dart';
import 'package:transitioner/transitioner.dart';
import '../../Models/PdfUploadModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import 'dart:io';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button.dart';
import '../../localization/Language/languages.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_animated_icons/lottiefiles.dart';
import 'package:lottie/lottie.dart';

class UploaddataNextScreen extends StatefulWidget {
  String bookId;
  int route;
  UploaddataNextScreen({Key? key, required this.bookId,required this.route}) : super(key: key);

  @override
  State<UploaddataNextScreen> createState() => _UploaddataNextScreenState();
}

class _UploaddataNextScreenState extends State<UploaddataNextScreen> with SingleTickerProviderStateMixin{
  var dropDownChapterId;
  bool _isLoading = false;
  File? DocumentFile;
  int fileLength = 0;
  var documentFile;
  bool docUploader = false;
  bool _isInternetConnected = true;
  PdfUploadModel? _pdfUploadModel;
  bool checkUpload = false;
  final _chapterKey = GlobalKey<FormFieldState>();
  TextEditingController? _chapterController;
  String paymentStatus = "1";
  File? imageFile;
  late AnimationController _homeController;

  @override
  void initState() {
    _chapterController= TextEditingController();
    _homeController =
    AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _chapterController!.dispose();
    _homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      _navigateAndRemove();
                    },
                    child: Padding(
                      padding:  EdgeInsets.all(height*0.03),
                      child: RippleWave(
                        child: CircleAvatar(
                          minRadius: 25,
                          maxRadius: 25,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.home,
                            color: Color(0xff3a6c83),
                          ),
                        ),
                        color: Color(0xff3a6c83),
                        childTween: Tween(begin: 0.75, end: 1.0),
                        repeat: true,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 15.0,
                    bottom: 15.0,
                    left: width * 0.05,
                    right: width * 0.05),
                child: Text(
                  Languages.of(context)!.publishPorF_text,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: Constants.fontfamily,
                      fontSize: 15.0),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.05),
                child: Column(
                  children: [
                    RadioListTile(
                      activeColor: const Color(0xff3a6c83),
                      title:  Text(
                        Languages.of(context)!.paid,
                        style: TextStyle(
                          fontFamily: Constants.fontfamily,
                        ),
                      ),
                      value: "2",
                      groupValue: paymentStatus,
                      onChanged: (value) {
                        setState(() {
                          paymentStatus = value.toString();
                        });
                      },
                    ),
                    RadioListTile(
                      activeColor: const Color(0xff3a6c83),
                      title:  Text(
                        Languages.of(context)!.free,
                        style: TextStyle(
                          fontFamily: Constants.fontfamily,
                        ),
                      ),
                      value: "1",
                      groupValue: paymentStatus,
                      onChanged: (value) {
                        setState(() {
                          paymentStatus = value.toString();
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.02,right: width * 0.02),
                child: Container(
                  margin: EdgeInsets.only(
                      top: height * 0.04, left: width * 0.02, right: width * 0.02),
                  height: height * 0.07,
                  width: width * 0.9,
                  child: TextFormField(
                    key: _chapterKey,
                    controller: _chapterController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    validator: validateBookTitle,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffebf5f9),
                      // labelText: widget.labelText,
                      hintText: Languages.of(context)!.episodes,
                      hintStyle: const TextStyle(
                        fontFamily: Constants.fontfamily,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Color(0xFF256D85)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Color(0xFF256D85)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: width * 0.02,right: width * 0.02,bottom: height*0.03),
                child: Container(
                  decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 0.5, style: BorderStyle.solid),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      color: Color(0xffebf5f9)),
                  width: width * 0.9,
                  height: height * 0.08,
                  margin: EdgeInsets.only(
                      left: width * 0.02, right: width * 0.02, top: height * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // SizedBox(
                      //   width: _width * 0.04,
                      //   height: _height * 0.07,
                      // ),
                      fileLength == 0
                          ? Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Text(Languages.of(context)!.SelectBook,
                                    style: const TextStyle(
                                      color: Colors.black54,
                                      fontFamily: Constants.fontfamily,
                                    )),
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '$fileLength ${Languages.of(context)!.filesSelected}',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18,
                                    fontFamily: Constants.fontfamily,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                      // SizedBox(
                      //   width: _width * 0.35,
                      // ),
                      IconButton(
                          onPressed: () {
                            getPdfAndUpload();
                          },
                          icon: const Icon(Icons.file_upload_outlined)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.only(
                  top: height*0.1
                ),
                child: Visibility(
                    visible: docUploader == true,
                    child: const Center(
                      child: CupertinoActivityIndicator(

                      ),
                    )),
              ),
              checkUpload
                  ? Visibility(
                      visible: checkUpload,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: _pdfUploadModel!.data.length,
                          itemBuilder: (BuildContext context, index) {
                            return Container(
                              decoration: const ShapeDecoration(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 0.5, style: BorderStyle.solid),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  color: Color(0xFF256D85)),
                              width: width * 0.9,
                              height: height * 0.08,
                              margin: EdgeInsets.only(
                                  left: width * 0.02,
                                  right: width * 0.02,
                                  top: height * 0.05),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [

                                  _pdfUploadModel!.data[index].pdfStatus== 2 ? IconButton(
                                      onPressed: () async {},
                                      icon: const Icon(
                                        Icons.lock_open_outlined,
                                        color: Colors.white,
                                      )): Container(),
                                  _pdfUploadModel!.data.length == 0
                                      ? const Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 8.0),
                                            child: Text('No PDF Found',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily:
                                                      Constants.fontfamily,
                                                )),
                                          ),
                                        )
                                      : Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8.0),
                                            child: Text(
                                              '${_pdfUploadModel!.data[index].lesson.toString()}',

                                              // '${_bookDetailsModel!.data!.chapters![index].name!.replaceAll(".pdf", "")}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontFamily: Constants.fontfamily,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                  // SizedBox(
                                  //   width: _width * 0.35,
                                  // ),
                                  IconButton(
                                      onPressed: () async {},
                                      icon: const Icon(
                                        Icons.picture_as_pdf,
                                        color: Colors.white,
                                      )),
                                ],
                              ),
                            );
                          }),
                    )
                  : Container(),
              SizedBox(
                height: height * 0.1,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, bottom: height * 0.03),
        alignment: Alignment.center,
        height: height * 0.06,
        width: width * 0.95,
        child: ResuableMaterialButton(
          onpress: () {
            if (_chapterController!.text.isNotEmpty && DocumentFile!.path.isNotEmpty) {
              _checkInternetConnectionUpload();
            } else {
              Constants.showToastBlack(
                  context, "Please fill all the fields  Correctly!");
            }
          },
          buttonname: widget.route==0 ? Languages.of(context)!.Publish:Languages.of(context)!.update,
        ),
      ),
    );
  }

  String? validateBookTitle(String? value) {
    if (value!.isEmpty)
      return 'Enter Chapter';
    else
      return null;
  }

  Future _checkInternetConnectionUpload() async {
    if (this.mounted) {
      setState(() {
        docUploader = true;
      });
    }

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      Constants.showToastBlack(context, "Internet not connected");
      if (this.mounted) {
        setState(() {
          docUploader = false;
          _isInternetConnected = false;
        });
      }
    } else {
      SingleBookUploadApi();
    }
  }

  Future getPdfAndUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.first.extension == 'pdf') {
      DocumentFile = File(result.files.single.path.toString());
      setState(() {
        fileLength = 1;
      });
    } else {
      Constants.showToastBlack(context, "Please select only pdf file!");
    }
  }

  Future<void> SingleBookUploadApi() async {
    setState(() {
      docUploader = true;
    });
    Map<String, String> headers = {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    };

    var request =
        http.MultipartRequest('POST', Uri.parse(ApiUtils.PDF_UPLOAD_API));

    request.fields['book_id'] = widget.bookId.toString();
    request.fields['lesson'] = _chapterController!.text.trim();
    request.fields['pdf_status'] = paymentStatus.toString();
    http.MultipartFile document =
        await http.MultipartFile.fromPath('filename', DocumentFile!.path,
            // contentType: MediaType('application', 'pdf')
            contentType: MediaType('application', 'pdf'));

    request.files.add(document);
    request.headers.addAll(headers);
    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          if (jsonData['status'] == 200) {
            print("multiple  books Uploaded! ");
            print('response_book_upload ' + response.body);
            _pdfUploadModel = pdfUploadModelFromJson(response.body);
            setState(() {
              docUploader = false;
              checkUpload = true;
            });
            ToastConstant.showToast(context, "Books Uploaded Successfully");
            setState(() {
              docUploader = false;
              checkUpload = true;
            });
          } else {
            ToastConstant.showToast(context, jsonData['message']);
            setState(() {
              docUploader = false;
              checkUpload = true;
            });
          }
        }
      });
    });
  }


  _navigateAndRemove() {
    Transitioner(
      context: context,
      child: TabScreen(),
      animation: AnimationType.fadeIn, // Optional value
      duration: Duration(milliseconds: 1000), // Optional value
      replacement: true, // Optional value
      curveType: CurveType.decelerate, // Optional value
    );
}

}
