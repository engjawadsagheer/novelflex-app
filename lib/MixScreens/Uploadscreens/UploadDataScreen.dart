import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:language_picker/language_picker_cupertino.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:transitioner/transitioner.dart';

import '../../Models/DropDownCategoriesModel.dart';
import '../../Models/DropDownSubCategoriesModel.dart';
import '../../Models/PostImageOtherFieldModel.dart';
import '../../Models/UploadMultipleFileModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/loading_widgets.dart';
import '../../Widgets/reusable_button.dart';
import '../../localization/Language/languages.dart';
import 'UploadDatanextScreen.dart';
import 'package:language_picker/languages.dart' as lang;

import 'BookUploadEditTabScreen.dart';

class UploadDataScreen extends StatefulWidget {
  @override
  State<UploadDataScreen> createState() => _UploadDataScreenState();
}

class _UploadDataScreenState extends State<UploadDataScreen> {
  final _bookTitleKey = GlobalKey<FormFieldState>();
  final _descriptionKey = GlobalKey<FormFieldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController? _bookTitleController;
  TextEditingController? _descriptionController;

  String? fileName;
  var pathImage;
  String paymentStatus = "1";
  bool _isLoadingLast = false;
  bool _isPressed = false;

  Future<void> _retrievePath() async {
    final prefs = await SharedPreferences.getInstance();

    // Check where the name is saved before or not
    if (!prefs.containsKey('path_img')) {
      return;
    }

    setState(() {
      pathImage = prefs.getString('path_img');
      log("Index number is: ${pathImage.toString()}");
    });
  }

  Future<void> _savePath(var _pathFine) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('path_img', _pathFine);
    });
  }

  Future<void> _clearPath() async {
    final prefs = await SharedPreferences.getInstance();
    // Check where the name is saved before or not
    if (!prefs.containsKey('path_img')) {
      return;
    }

    await prefs.remove('path_img');
    setState(() {
      pathImage = null;
    });
  }

  List<DropDownCategoriesModel>? _dropDownCategoriesModelList;
  DropDownCategoriesModel? _dropDownCategoriesModel;

  List<DropDownSubCategoriesModel>? _dropDownSubCategoriesModelList;
  DropDownSubCategoriesModel? _dropDownSubCategoriesModel;

  PostImageOtherFieldModel? _postImageOtherFieldModel;

  UploadMultipleFileModel? _uploadMultipleFileModel;
  List<UploadMultipleFileModel>? _uploadMultipleFileModelList;

  bool _isLoading = false;
  bool _isInternetConnected = true;
  List categoryItemList = [];
  var dropDownId;
  var dropDownSub2Id;
  List<File>? DocumentFilesList;
  int fileLength = 0;
  File? imageFile;
  var documentFile;
  bool docUploader = false;
  bool subCategoriesStatus = false;
  lang.Language _selectedDialogLanguage = lang.Languages.arabic;

  @override
  void initState() {
    super.initState();
    _bookTitleController = new TextEditingController();
    _descriptionController = new TextEditingController();
    _callDropDownCategoriesAPI();
  }

  @override
  void dispose() {
    _bookTitleController = TextEditingController();
    _descriptionController = TextEditingController();
    super.dispose();
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
      _callDropDownCategoriesAPI();
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      appBar: AppBar(
        toolbarHeight: height * 0.07,
        elevation: 0.0,
        backgroundColor: const Color(0xffebf5f9),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.black54,
          ),
        ),
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
                      height: height * 0.019,
                    ),
                    InkWell(
                      child: Container(
                        width: width * 0.40,
                        height: height * 0.058,
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
              : SafeArea(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: 15.0,
                                  bottom: 15.0,
                                  left: width * 0.05,
                                  right: width * 0.05),
                              child: Text(
                                Languages.of(context)!.publishPorF,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: Constants.fontfamily,
                                    fontSize: 15.0),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _openLanguagePickerDialog;
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: height * 0.04,
                                    left: width * 0.02,
                                    right: width * 0.02),
                                height: height * 0.07,
                                width: width * 0.9,
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.black),
                                  ),
                                  title: Text(_selectedDialogLanguage
                                          .name.isEmpty
                                      ? Languages.of(context)!.selectLanguage
                                      : _selectedDialogLanguage.name),
                                  trailing:
                                      Icon(Icons.arrow_drop_down_outlined),
                                  onTap: _openLanguagePickerDialog,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: height * 0.04,
                                  left: width * 0.02,
                                  right: width * 0.02),
                              height: height * 0.07,
                              width: width * 0.9,
                              child: TextFormField(
                                key: _bookTitleKey,
                                controller: _bookTitleController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                cursorColor: Colors.black,
                                validator: validateBookTitle,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xffebf5f9),
                                  // labelText: widget.labelText,
                                  hintText:
                                      Languages.of(context)!.enterBookTitle,
                                  hintStyle: const TextStyle(
                                    fontFamily: Constants.fontfamily,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.only(
                                    top: height * 0.05,
                                    left: width * 0.02,
                                    right: width * 0.02),
                                height: height * 0.06,
                                width: width * 0.9,
                                child: _dropDownCategoriesWidget()),
                            _isLoadingLast
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: const Align(
                                        alignment: Alignment.center,
                                        child: const Center(
                                          child: CupertinoActivityIndicator(),
                                        )),
                                  )
                                : subCategoriesStatus
                                    ? Container(
                                        margin: EdgeInsets.only(
                                            top: height * 0.07,
                                            left: width * 0.02,
                                            right: width * 0.02),
                                        height: height * 0.07,
                                        width: width * 0.9,
                                        child:
                                            _dropDownCategoriesWidgetSubCategories2())
                                    : Container(),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: height * 0.05,
                                  bottom: 15.0,
                                  left: width * 0.02,
                                  right: width * 0.02),
                              child: Text(
                                  Languages.of(context)!.writetheDescription,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: Constants.fontfamily,
                                      fontSize: 15.0)),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: height * 0.015,
                                  left: width * 0.02,
                                  right: width * 0.02),
                              height: height * 0.35,
                              width: width * 0.9,
                              child: TextFormField(
                                key: _descriptionKey,
                                controller: _descriptionController,
                                keyboardType: TextInputType.multiline,
                                maxLines: 10,
                                textInputAction: TextInputAction.next,
                                cursorColor: Colors.black,
                                validator: validateDescription,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xffebf5f9),
                                  // labelText: widget.labelText,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.black),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                _getFromGallery();
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    left: width * 0.02, right: width * 0.02),
                                height: height * 0.35,
                                width: width * 0.7,
                                child: Center(
                                  child: pathImage == null
                                      ? Container(
                                          margin: EdgeInsets.only(
                                              left: width * 0.02),
                                          height: height * 0.35,
                                          width: width * 0.7,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              color: Colors.black12),
                                          child: Center(
                                            child: Text(
                                              Languages.of(context)!
                                                  .taptoUploadCoverImage,
                                              style: const TextStyle(
                                                fontFamily:
                                                    Constants.fontfamily,
                                              ),
                                            ),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.file(
                                            File(pathImage!),
                                            fit: BoxFit.cover,
                                            colorBlendMode:
                                                BlendMode.saturation,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                    color: Colors.black12),
                                                child: Center(
                                                  child: Text(
                                                    Languages.of(context)!
                                                        .taptoUploadCoverImage,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          Constants.fontfamily,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            Visibility(
                                visible: docUploader == true,
                                child: const Center(
                                  child: CupertinoActivityIndicator(),
                                )),
                            SizedBox(
                              height: height * 0.06,
                            ),
                          ],
                        ),
                      ),
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
            if (_isPressed==true) {
              print("Already Press wait...");
              ToastConstant.showToast(context, "Please Wait...");
            } else {
              _AutomaticCallApiMethod();
              setState(() {
                _isPressed = true;
              });
            }
          },
          buttonname: Languages.of(context)!.next,
        ),
      ),
    );
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
        _savePath(localImage.path);
        _retrievePath();
      });
    }
  }

  _AutomaticCallApiMethod() {
    if (_bookTitleController!.text.isNotEmpty &&
        dropDownId != null &&
        _descriptionController!.text.isNotEmpty &&
        imageFile != null) {
      _checkInternetConnectionStatus();
    } else {
      Constants.showToastBlack(
          context, "Please fill all the fields Correctly!");
    }
  }

  Widget _dropDownCategoriesWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      child: DropdownButton<DropDownCategoriesModel>(
        hint: Text(
          Languages.of(context)!.selectGenerals,
          style: const TextStyle(
            fontFamily: Constants.fontfamily,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        items: _dropDownCategoriesModelList!
            .map((DropDownCategoriesModel newItem) {
          return DropdownMenuItem<DropDownCategoriesModel>(
            value: newItem,
            child: Text(
              context.read<UserProvider>().SelectedLanguage == "English"
                  ? newItem.title!
                  : newItem.titleAr!,
              style: const TextStyle(
                  fontFamily: Constants.fontfamily,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (DropDownCategoriesModel? newItem) {
          setState(() {
            _dropDownCategoriesModel = newItem;
            dropDownId = newItem!.categoryId;
          });
          _callDropDownCategoriesAPISubCategories2(newItem!.categoryId);
        },
        value: _dropDownCategoriesModel,
        isExpanded: true,
        underline: Container(color: Colors.transparent),
      ),
    );
  }

  Future _callDropDownCategoriesAPI() async {
    setState(() {
      _isLoading = true;
      _isInternetConnected = true;
    });

    final response = await http
        .get(Uri.parse(ApiUtils.MAIN_CATEGORIES_DROPDOWN_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('dropDownApiResponse under 200 ${response.body}');
      var jsonData = response.body;
      _dropDownCategoriesModelList = dropDownCategoriesModelFromJson(jsonData)
          ?.cast<DropDownCategoriesModel>();
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _dropDownCategoriesWidgetSubCategories2() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.5, style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      child: DropdownButton<DropDownSubCategoriesModel>(
        hint: Text(
          Languages.of(context)!.selectSubCategories,
          style: const TextStyle(
            fontFamily: Constants.fontfamily,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
        ),
        items: _dropDownSubCategoriesModelList!
            .map((DropDownSubCategoriesModel newItem) {
          return DropdownMenuItem<DropDownSubCategoriesModel>(
            value: newItem,
            child: Text(
              context.read<UserProvider>().SelectedLanguage == "English"
                  ? newItem.subTitle!
                  : newItem.subTitleAr!,
              style: const TextStyle(
                  fontFamily: Constants.fontfamily,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (DropDownSubCategoriesModel? newItem) {
          setState(() {
            _dropDownSubCategoriesModel = newItem;
            dropDownSub2Id = newItem!.id;
          });
        },
        value: _dropDownSubCategoriesModel,
        isExpanded: true,
        underline: Container(color: Colors.transparent),
      ),
    );
  }

  Future _callDropDownCategoriesAPISubCategories2(var id) async {
    setState(() {
      _isLoadingLast = true;
    });
    var map = Map<String, dynamic>();
    map['category_id'] = id.toString();

    final response = await http.post(
        Uri.parse(ApiUtils.DROPDOWN_SUB_CATEGORIES_API),
        body: map,
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        });

    if (response.statusCode == 200) {
      print('dropDownApiResponse_SubCategories_2 under 200 ${response.body}');
      var jsonData = response.body;
      _dropDownSubCategoriesModelList =
          dropDownSubCategoriesModelFromJson(jsonData)
              ?.cast<DropDownSubCategoriesModel>();

      setState(() {
        _isLoadingLast = false;
        subCategoriesStatus = true;
      });
    }
  }

  String? validateBookTitle(String? value) {
    if (value!.isEmpty)
      return 'Enter Book Title';
    else
      return null;
  }

  String? validateDescription(String? value) {
    if (value!.isEmpty)
      return 'Enter Description';
    else
      return null;
  }

  _navigateAndRemove() {
    Transitioner(
      context: context,
      child: BookUploadEditTabScreen(
        bookId: _postImageOtherFieldModel!.data!.id.toString(),
        route: 0,
      ),
      animation: AnimationType.slideLeft, // Optional value
      duration: Duration(milliseconds: 1000), // Optional value
      replacement: true, // Optional value
      curveType: CurveType.decelerate, // Optional value
    );
  }

  Future _checkInternetConnectionStatus() async {
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
      UploadBookImageAndOtherFieldApi();
    }
  }

  Future<void> UploadBookImageAndOtherFieldApi() async {
    Map<String, String> headers = {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    };
    var jsonResponse;

    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiUtils.ADD_IMAGE_WITH_FILED_API));
    request.fields['title'] = _bookTitleController!.text.trim();
    request.fields['category_id'] = dropDownId.toString();
    request.fields['subcategory_id'] = dropDownSub2Id.toString();
    request.fields['description'] =
        _descriptionController!.text.trim().toString();
    request.fields['payment_status'] = paymentStatus;
    request.fields['language'] = _selectedDialogLanguage.name.trim().toString();
    request.files.add(new http.MultipartFile.fromBytes(
      "image",
      File(imageFile!.path)
          .readAsBytesSync(), //UserFile is my JSON key,use your own and "image" is the pic im getting from my gallary
      filename: "Image.jpg",
      contentType: MediaType('image', 'jpg'),
    ));

    request.headers.addAll(headers);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          if (jsonData['status'] == 200) {
            print('response_image_upload ' + response.body);
            _postImageOtherFieldModel =
                postImageOtherFieldModelFromJson(response.body);
            setState(() {
              docUploader = false;
            });
            _navigateAndRemove();
          } else {
            ToastConstant.showToast(context, jsonData['message']);
            setState(() {
              docUploader = false;
            });
          }
        } else {
          ToastConstant.showToast(context, "Internet Server error");
          setState(() {
            docUploader = false;
          });
        }
      });
    });
  }

  void _openLanguagePickerDialog() => showDialog(
      context: context,
      builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: LanguagePickerDialog(
              titlePadding: EdgeInsets.all(8.0),
              searchCursorColor: Colors.pinkAccent,
              searchInputDecoration: InputDecoration(hintText: 'Search...'),
              isSearchable: true,
              title: Text('Select your language'),
              onValuePicked: (lang.Language language) => setState(() {
                    _selectedDialogLanguage = language;
                    print(_selectedDialogLanguage.name);
                    print(_selectedDialogLanguage.isoCode);
                  }),
              itemBuilder: _buildDialogItem)));

  Widget _buildDialogItem(lang.Language language) => Row(
        children: <Widget>[
          Text(language.name),
          SizedBox(width: 8.0),
          Flexible(child: Text("(${language.isoCode})"))
        ],
      );
}
