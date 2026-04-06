import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:ripple_wave/ripple_wave.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:transitioner/transitioner.dart';
import '../../Chat_Screens/ChatScreen.dart';
import '../../Models/BookEditModel.dart';
import '../../Models/BoolAllPdfViewModelClass.dart';
import '../../Models/PdfUploadModel.dart';
import '../../Models/subscriptionModelClass.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/AudioCommon.dart';
import '../../Utils/Constants.dart';
import '../../Utils/constant.dart';
import '../../Utils/native_dialog.dart';
import '../../Utils/store_config.dart';
import '../../Utils/toast.dart';
import '../../Widgets/loading_widgets.dart';
import '../../Widgets/reusable_button.dart';
import '../../localization/Language/languages.dart';
import '../../tab_screen.dart';
import '../InAppPurchase/paywall.dart';
import '../InAppPurchase/singletons_data.dart';
import '../StripePayment/StripePayment.dart';
import '../pdfViewerScreen.dart';
import 'UploadDataScreen.dart';

class BookUploadEditTabScreen extends StatefulWidget {
  final bookId;
  final route;
  final Chapters;

  BookUploadEditTabScreen(
      {Key? key, required this.bookId, required this.route, this.Chapters})
      : super(key: key);

  @override
  State<BookUploadEditTabScreen> createState() =>
      _BookUploadEditTabScreenState();
}

class _BookUploadEditTabScreenState extends State<BookUploadEditTabScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  _navigateAndRemove() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => TabScreen()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      appBar: AppBar(
        leading: Container(),
        backgroundColor: const Color(0xffebf5f9),
        toolbarHeight: height * 0.13,
        centerTitle: true,
        elevation: 0.0,
        actions: [
          GestureDetector(
            onTap: () {
              _navigateAndRemove();
            },
            child: Padding(
              padding: EdgeInsets.all(height * 0.03),
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          tabs: [
            Tab(
              child: Text(
                'PDF',
                style: const TextStyle(
                    color: const Color(0xff2a2a2a),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Neckar",
                    fontStyle: FontStyle.normal,
                    fontSize: 15.0),
              ),
            ),
            Tab(
              child: Text(
                'Audio',
                style: const TextStyle(
                    color: const Color(0xff2a2a2a),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Neckar",
                    fontStyle: FontStyle.normal,
                    fontSize: 15.0),
              ),
            ),
            Tab(
              child: Text(
                'Text',
                style: const TextStyle(
                    color: const Color(0xff2a2a2a),
                    fontWeight: FontWeight.bold,
                    fontFamily: "Neckar",
                    fontStyle: FontStyle.normal,
                    fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
      body: Navigator(
        key: _navKey,
        onGenerateRoute: (_) => MaterialPageRoute(
          builder: (_) => TabBarView(
            controller: _tabController,
            children: [
              UploadPdfScreen(
                bookId: widget.bookId,
                route: widget.route,
                Chapters: widget.Chapters,
              ),
              AudioTab(
                bookId: widget.bookId,
                route: widget.route,
              ),
              TextTab(
                router: widget.route,
                bookId: widget.bookId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class UploadPdfScreen extends StatefulWidget {
  final bookId;
  final route;
  final Chapters;
  UploadPdfScreen(
      {Key? key, required this.bookId, required this.route, this.Chapters})
      : super(key: key);

  @override
  State<UploadPdfScreen> createState() => _UploadPdfScreenState();
}



class _UploadPdfScreenState extends State<UploadPdfScreen>
    with SingleTickerProviderStateMixin {
  var dropDownChapterId;
  bool _isLoading = false;
  File? DocumentFile;
  int fileLength = 0;
  String fileName = "";
  var documentFile;
  bool docUploader = false;
  bool _isInternetConnected = true;
  PdfUploadModel? _pdfUploadModel;
  bool checkUpload = false;
  final _chapterKey = GlobalKey<FormFieldState>();
  TextEditingController? _chapterController;
  String paymentStatus = "1";
  File? imageFile;

  bool _isDeleteLoading = false;
  BookEditModel? _bookEditModel;

  @override
  void initState() {
    _chapterController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _chapterController!.dispose();
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
                      title: Text(
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
                      title: Text(
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
                padding:
                    EdgeInsets.only(left: width * 0.02, right: width * 0.02),
                child: Container(
                  margin: EdgeInsets.only(
                      top: height * 0.04,
                      left: width * 0.02,
                      right: width * 0.02),
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
                      // hintText: Languages.of(context)!.episodes,
                      hintStyle: const TextStyle(
                        fontFamily: Constants.fontfamily,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Color(0xFF256D85)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Color(0xFF256D85)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixText: '${Languages.of(context)!.episodes} No ',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.02,
                    right: width * 0.02,
                    bottom: height * 0.03),
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
                      left: width * 0.02,
                      right: width * 0.02,
                      top: height * 0.05),
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
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
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
                                  '$fileName',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
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
                padding: EdgeInsets.only(top: height * 0.05),
                child: Visibility(
                    visible: docUploader == true,
                    child: const Center(
                      child: CupertinoActivityIndicator(),
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
                                gradient: LinearGradient(
                                    begin: Alignment(-0.01018629550933838,
                                        -0.01894212305545807),
                                    end: Alignment(
                                        1.6960868120193481, 1.3281718730926514),
                                    colors: [
                                      Color(0xff246897),
                                      Color(0xff1b4a6b),
                                    ]),
                              ),
                              width: width * 0.9,
                              height: height * 0.08,
                              margin: EdgeInsets.only(
                                  left: width * 0.02,
                                  right: width * 0.02,
                                  top: height * 0.05),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _pdfUploadModel!.data[index].pdfStatus == 2
                                      ? IconButton(
                                          onPressed: () async {},
                                          icon: const Icon(
                                            Icons.lock_open_outlined,
                                            color: Colors.white,
                                          ))
                                      : Container(),
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
                                                fontFamily:
                                                    Constants.fontfamily,
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
              widget.route == 1
                  ? Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Color(0xffebf5f9),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: widget.Chapters.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => PdfScreen(
                                        //           url: _bookEditModel!
                                        //               .data!.chapter![index]!.url,
                                        //           name: _bookEditModel!
                                        //               .data!.title,
                                        //         )));
                                        // PdfScreen()));
                                      },
                                      child: Container(
                                        decoration: const ShapeDecoration(
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 0.5,
                                                style: BorderStyle.solid),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5.0)),
                                          ),
                                          gradient: LinearGradient(
                                              begin: Alignment(
                                                  -0.01018629550933838,
                                                  -0.01894212305545807),
                                              end: Alignment(1.6960868120193481,
                                                  1.3281718730926514),
                                              colors: [
                                                Color(0xff246897),
                                                Color(0xff1b4a6b),
                                              ]),
                                        ),
                                        width: width * 0.9,
                                        height: height * 0.08,
                                        margin: EdgeInsets.only(
                                            left: width * 0.02,
                                            right: width * 0.02,
                                            top: height * 0.03),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  _callDeleteBookAPI(widget
                                                      .Chapters![index]!.id
                                                      .toString());
                                                  setState(() {
                                                    widget.Chapters.removeWhere(
                                                        (item) =>
                                                            item!.id ==
                                                            widget
                                                                .Chapters![
                                                                    index]!
                                                                .id);
                                                  });
                                                },
                                                icon: Icon(
                                                  Icons.cancel_presentation,
                                                  color: Colors.white,
                                                  size:
                                                      height * width * 0.00012,
                                                )),
                                            widget.Chapters.length == 0
                                                ? const Expanded(
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0),
                                                      child: Text(
                                                          'No PDF Found',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontFamily:
                                                                Constants
                                                                    .fontfamily,
                                                          )),
                                                    ),
                                                  )
                                                : Expanded(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0),
                                                      child: Text(
                                                        widget.Chapters
                                                                    .length ==
                                                                1
                                                            ? '${widget.Chapters![index]!.lesson}'
                                                            : '${widget.Chapters![index]!.lesson} ${widget.Chapters![index]!.lesson}',
                                                        // '${_bookDetailsModel!.data!.chapters![index].name!.replaceAll(".pdf", "")}',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontFamily: Constants
                                                              .fontfamily,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                            // SizedBox(
                                            //   width: _width * 0.35,
                                            // ),
                                            IconButton(
                                                onPressed: () async {
                                                  // _pdf = await PDFDocument.fromURL(_bookDetailsModel!.data!.chapters![index].url.toString());
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>PdfViewScreen()));
                                                  // setState(() {
                                                  //   _isLoadingPdf = false;
                                                  // });
                                                },
                                                icon: const Icon(
                                                  Icons.picture_as_pdf,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                        Container(
                          height: height * 0.1,
                          color: Color(0xffebf5f9),
                        ),
                      ],
                    )
                  : Container()
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
            if (_chapterController!.text.isNotEmpty &&
                DocumentFile!.path.isNotEmpty) {
              _checkInternetConnectionUpload();
            } else {
              Constants.showToastBlack(
                  context, "Please fill all the fields  Correctly!");
            }
          },
          buttonname: widget.route == 0
              ? Languages.of(context)!.Publish
              : Languages.of(context)!.update,
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
        fileName = result.files.single.name.toString();
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
    request.fields['lesson'] = "${Languages.of(context)!.episodes}  ${_chapterController!.text.trim()}";
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
            if (widget.route == 1) {
              widget.Chapters.clear();
            }

            setState(() {
              docUploader = false;
              checkUpload = true;
            });
            ToastConstant.showToast(context, "Books Published Successfully");
            _showSimpleDialog();
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

  Future _callDeleteBookAPI(String id) async {
    setState(() {
      _isDeleteLoading = true;
    });
    var map = Map<String, dynamic>();
    map['chapterId'] = id;

    final response = await http
        .post(Uri.parse(ApiUtils.DELETE_PDF_API), body: map, headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    var jsonData;

    if (response.statusCode == 200) {
      //Success

      jsonData = json.decode(response.body);
      print('delete_chapter_data: $jsonData');
      if (jsonData['status'] == 200) {
        setState(() {
          _isDeleteLoading = false;
          widget.Chapters!.removeWhere((item) => item!.id == id);
        });
      } else {
        ToastConstant.showToast(context, jsonData['message']);
        setState(() {
          _isDeleteLoading = false;
        });
      }
    } else {
      ToastConstant.showToast(context, "Internet Server Error!");
      setState(() {
        _isDeleteLoading = false;
      });
    }
  }

  Future<void> _showSimpleDialog() async {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    await showDialog<void>(
        context: context,
        builder: (BuildContext ctx) {
          return SimpleDialog(
            // <-- SEE HERE
            contentPadding: EdgeInsets.all(width * 0.1),
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.add_link_outlined,
                      color: Color(0xff3a6c83),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text(Languages.of(context)!.addEpisodes),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  Transitioner(
                    context: ctx,
                    child: UploadDataScreen(),
                    animation: AnimationType.slideLeft,
                    // Optional value
                    duration: Duration(milliseconds: 1000),
                    // Optional value
                    replacement: true,
                    // Optional value
                    curveType: CurveType.decelerate, // Optional value
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.menu_book_sharp,
                      color: Color(0xff3a6c83),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Transitioner(
                          context: ctx,
                          child: UploadDataScreen(),
                          animation: AnimationType.slideLeft,
                          // Optional value
                          duration: Duration(milliseconds: 1000),
                          // Optional value
                          replacement: true,
                          // Optional value
                          curveType: CurveType.decelerate, // Optional value
                        );
                      },
                      child: Text(Languages.of(context)!.publishNewNovel),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  Transitioner(
                    context: ctx,
                    child: TabScreen(),
                    animation: AnimationType.slideLeft,
                    // Optional value
                    duration: Duration(milliseconds: 1000),
                    // Optional value
                    replacement: true,
                    // Optional value
                    curveType: CurveType.decelerate, // Optional value
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.home,
                      color: Color(0xff3a6c83),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Transitioner(
                          context: ctx,
                          child: TabScreen(),
                          animation: AnimationType.slideLeft,
                          // Optional value
                          duration: Duration(milliseconds: 1000),
                          // Optional value
                          replacement: true,
                          // Optional value
                          curveType: CurveType.decelerate, // Optional value
                        );
                      },
                      child: Text(Languages.of(context)!.home_text),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}







class AudioTab extends StatefulWidget {
  final bookId;
  final route;
  AudioTab({Key? key, required this.bookId, required this.route})
      : super(key: key);

  @override
  State<AudioTab> createState() => _AudioTabState();
}

class _AudioTabState extends State<AudioTab> {
  bool _isLoading = false;
  File? DocumentFile;
  int fileLength = 0;
  String AudioName = "";
  var documentFile;
  bool docUploader = false;
  bool _isInternetConnected = true;
  bool checkUpload = false;
  String paymentStatus = "1";
  File? imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
              SizedBox(
                height: height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: width * 0.02,
                    right: width * 0.02,
                    bottom: height * 0.03),
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
                      left: width * 0.02,
                      right: width * 0.02,
                      top: height * 0.05),
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
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0),
                                child: Text(Languages.of(context)!.SelectAudio,
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
                                  '$AudioName',
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
                padding: EdgeInsets.only(top: height * 0.1),
                child: Visibility(
                    visible: docUploader == true,
                    child: const Center(
                      child: CupertinoActivityIndicator(),
                    )),
              ),
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
            _checkInternetConnectionUpload();
          },
          buttonname: widget.route == 0
              ? Languages.of(context)!.Publish
              : Languages.of(context)!.update,
        ),
      ),
    );
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
      widget.route == 0 ?  UploadaudioBook() : UpdateAudioBook();
    }
  }

  Future getPdfAndUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
      // allowedExtensions: ['pdf'],
    );
    DocumentFile = File(result!.files.single.path.toString());
    setState(() {
      fileLength = 1;
      AudioName = result.files.single.name.toString();
    });
  }

  Future<void> UploadaudioBook() async {
    setState(() {
      docUploader = true;
    });
    Map<String, String> headers = {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    };

    var request =
        http.MultipartRequest('POST', Uri.parse(ApiUtils.UPLOAD_AUDIO_API));

    request.fields['book_id'] = widget.bookId.toString();
    http.MultipartFile document = await http.MultipartFile.fromPath(
      'audio', DocumentFile!.path,
      // contentType: MediaType('application', 'pdf')
      // contentType: MediaType('application', 'pdf'),
    );

    request.files.add(document);
    request.headers.addAll(headers);
    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          if (jsonData['status'] == 200) {
            print("multiple  books Uploaded! ");
            print('response_book_upload ' + response.body);
            // _pdfUploadModel = pdfUploadModelFromJson(response.body);
            setState(() {
              docUploader = false;
              checkUpload = true;
            });
            ToastConstant.showToast(context, "Audio Uploaded Successfully");
            setState(() {
              docUploader = false;
              checkUpload = true;
            });
          } else {
            ToastConstant.showToast(context, jsonData['success']);
            setState(() {
              docUploader = false;
              checkUpload = true;
            });
          }
        }
      });
    });
  }

  Future<void> UpdateAudioBook() async {
    setState(() {
      docUploader = true;
    });
    Map<String, String> headers = {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    };

    var request =
    http.MultipartRequest('POST', Uri.parse(ApiUtils.UPDATE_AUDIO_BOOK));

    request.fields['bookId'] = widget.bookId.toString();
    http.MultipartFile document = await http.MultipartFile.fromPath(
      'audio', DocumentFile!.path,
      // contentType: MediaType('application', 'pdf')
      // contentType: MediaType('application', 'pdf'),
    );

    request.files.add(document);
    request.headers.addAll(headers);
    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          if (jsonData['status'] == 200) {
            print('audio Updated' + response.body);
            // _pdfUploadModel = pdfUploadModelFromJson(response.body);
            setState(() {
              docUploader = false;
              checkUpload = true;
            });
            ToastConstant.showToast(context, "Audio Updated Successfully");
            setState(() {
              docUploader = false;
              checkUpload = true;
            });
          } else {
            ToastConstant.showToast(context, jsonData['success']);
            setState(() {
              docUploader = false;
              checkUpload = true;
            });
          }
        }
      });
    });
  }
}




class TextTab extends StatefulWidget {
  final router;
  final bookId;
  const TextTab({Key? key, required this.router, required this.bookId}) : super(key: key);

  @override
  State<TextTab> createState() => _TextTabState();
}

class _TextTabState extends State<TextTab> {
  bool _isLoading = false;
  String text= "";
  String result = '';
  bool done = false;
  bool _isInternetConnected = true;
  final _descriptionKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController? _descriptionController;

  @override
  void initState() {
   if(widget.router==1){
     _checkInternetConnection2();
   }
   _descriptionController= TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
            body: _isLoading
                ? Align(
                    alignment: Alignment.center,
                    child: CustomCard(
                      gif: MoreLoadingGif(
                        type: MoreLoadingGifType.eclipse,
                        size: height * width * 0.0002,
                      ),
                      text: 'Loading',
                    ),
                  )
                : SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: height * 0.015,
                          left: width * 0.02,
                          right: width * 0.02),
                      // height: height * 0.35,
                      width: width * 0.95,
                      child: TextFormField(
                        key: _descriptionKey,
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 1000000,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xffebf5f9),
                          hintText: Languages.of(context)!.writeBook

                        ),
                      ),
                    ),
                  ),
            bottomNavigationBar: Container(
              margin: EdgeInsets.only(
                  left: 10.0, right: 10.0, bottom: height * 0.03),
              alignment: Alignment.center,
              height: height * 0.06,
              width: width * 0.95,
              child: ResuableMaterialButton(
                onpress: (){
                  _checkInternetConnection();
                },
                buttonname: widget.router == 0
                    ? Languages.of(context)!.Publish
                    : Languages.of(context)!.update,
              ),
            ),
          );
  }



  Future _UploadTextBook(var text) async {
    setState(() {
      _isLoading = true;
    });
    var map = Map<String, dynamic>();
    map['book_id'] = widget.bookId;
    map['description'] = text;

    final response = await http.post(
        Uri.parse(
          ApiUtils.UPLOAD_TEXT_BOOK,
        ),
        body: map,
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        });

    var jsonData;

    if (response.statusCode == 200) {
      //Success

      jsonData = json.decode(response.body);
      print('login_user_success_data_shown: $jsonData');
      if (jsonData['status'] == 200) {
        ToastConstant.showToast(
            context, "Your Text Book Uploaded Successfully");
        setState(() {
          _isLoading = false;
          done = true;
        });
      } else {
        ToastConstant.showToast(
            context, "Book Upload Already you can Edit it in your Profile");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ToastConstant.showToast(
          context, "Book Upload Already you can Edit it in your Profile");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (!(connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi)) {
      Fluttertoast.showToast(
        msg: "Internet Not Connected",
        toastLength: Toast.LENGTH_SHORT,
        textColor: Colors.white,
        backgroundColor: Colors.black,
        fontSize: 14,
      );
    } else {
      widget.router == 0 ?  _UploadTextBook(_descriptionController!.text.trim().toString()) :
      _UpdateTextBook(_descriptionController!.text.trim().toString());
    }
  }

  Future TEXT_LINK() async {
    var map = Map<String, dynamic>();
    map['bookId'] = widget.bookId.toString();
    final response = await http.post(Uri.parse(ApiUtils.GET_TEXT_BOOK),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        },
        body: map);

    if (response.statusCode == 200) {
      print('Text_book${response.body}');
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 200) {

        setState(() {
          if(jsonData['data'].toString()=="[]"){
            text = "";
          }else{
            _descriptionController?.text = jsonData['data'][0];
          }
          _isLoading= false;

        });
      } else {
        ToastConstant.showToast(context, jsonData['message'].toString());
        setState(() {
          _isLoading= false;
        });
      }
    }
  }

  Future _checkInternetConnection2() async {

    setState(() {
      _isLoading= true;
    });
    if (this.mounted) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (!(connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi)) {
        Constants.showToastBlack(context, "Internet not connected");
        if (this.mounted) {
          setState(() {
            _isInternetConnected = false;
          });
        }
      } else {
        TEXT_LINK();
      }
    }
  }

  Future _UpdateTextBook(var text) async {
    setState(() {
      _isLoading = true;
    });
    var map = Map<String, dynamic>();
    map['bookId'] = widget.bookId;
    map['description'] = _descriptionController!.text.trim().toString();

    final response = await http.post(
        Uri.parse(
          ApiUtils.UPDATE_TEXT_BOOK,
        ),
        body: map,
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        });

    var jsonData;

    if (response.statusCode == 200) {
      //Success

      jsonData = json.decode(response.body);
      print('updated text response: $jsonData');
      if (jsonData['status'] == 200) {
        ToastConstant.showToast(
            context, "Your Text Book updated Successfully");
        setState(() {
          _isLoading = false;
        });
      } else {
        ToastConstant.showToast(
            context, "Book Upload Already you can Edit it in your Profile");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ToastConstant.showToast(
          context, "Book Upload Already you can Edit it in your Profile");
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  
}


