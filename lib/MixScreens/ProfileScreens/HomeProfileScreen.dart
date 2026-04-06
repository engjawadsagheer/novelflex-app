import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';
import 'package:ripple_wave/ripple_wave.dart';
import 'package:share_plus/share_plus.dart';
import '../../Models/AuthorProfileViewModel.dart';
import 'dart:convert';
import 'dart:io';
import 'package:novelflex/MixScreens/Uploadscreens/UploadDataScreen.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:transitioner/transitioner.dart';

import '../../Models/ReaderProfileModel.dart';
import '../../Models/StatusCheckModel.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/loading_widgets.dart';
import '../../localization/Language/languages.dart';
import '../BooksScreens/AuthorViewByUserScreen.dart';
import '../BooksScreens/BookDetail.dart';
import '../BooksScreens/BookDetailsAuthor.dart';
import '../Uploadscreens/upload_history_screen.dart';

class HomeProfileScreen extends StatefulWidget {
  const HomeProfileScreen({Key? key}) : super(key: key);

  @override
  State<HomeProfileScreen> createState() => _HomeProfileScreenState();
}

class _HomeProfileScreenState extends State<HomeProfileScreen> {
  AuthorProfileViewModel? _authorProfileViewModel;
  ReaderProfileModel? _readerProfileModel;
  StatusCheckModel? _statusCheckModel;

  bool _isLoading = false;
  bool _isInternetConnected = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _linkKey = GlobalKey<FormFieldState>();
  TextEditingController? _linkController = TextEditingController();
  bool _isImageLoading = false;
  File? _cover_imageFile;
  File? _Ads_imageFile;
  bool _status = false;
  String _AdsName = "";
  bool docUploader = false;

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      body: SafeArea(
        child: Container(
          height: double.infinity,
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
                  : _statusCheckModel!.data.type == "Reader"
                      ? Stack(
                          children: [
                            Positioned(
                                child: Container(
                              height: _height * 0.9,
                              color: const Color(0xffebf5f9),
                            )),
                            Positioned(
                              child: Container(
                                height: _height * 0.13,
                                width: _width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                  color: Colors.black12,
                                ),
                              ),
                            ),
                            Positioned(
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
                              top: _height * 0.05,
                              child: Column(
                                children: [
                                  RippleWave(
                                    color: Colors.white12,
                                    // childTween: Tween(begin: 0.2, end: 1.0),
                                    repeat: true,
                                    duration: const Duration(seconds: 2),
                                    child: Container(
                                      height: _height * 0.15,
                                      width: _width * 0.5,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            width: 1,
                                            color: Colors.black,
                                          ),
                                          image: DecorationImage(
                                              image: _readerProfileModel!
                                                          .data.profilePhoto ==
                                                      ""
                                                  ? AssetImage(
                                                      "assets/profile_pic.png",
                                                    )
                                                  : NetworkImage(
                                                          _readerProfileModel!
                                                              .data.profilePath
                                                              .toString())
                                                      as ImageProvider,
                                              fit: BoxFit.cover)),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: _height * 0.02),
                                    child: Text(
                                      _readerProfileModel!.data.username,
                                      style: const TextStyle(
                                          color: const Color(0xff2a2a2a),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Neckar",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 14.0),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: _height * 0.01),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/quotes_data/extra_pngs/glasses.png",
                                          color: const Color(0xff002333),
                                          height: _height * 0.03,
                                          width: _width * 0.03,
                                        ),
                                        SizedBox(
                                          width: _width * 0.03,
                                        ),
                                        Text(Languages.of(context)!.reader,
                                            style: const TextStyle(
                                                color: const Color(0xff3a6c83),
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Lato",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            textAlign: TextAlign.left),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                              top: _height * 0.35,
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
                              child: Container(
                                height: _height * 0.3,
                                width: _width,
                                child: Text(
                                  Languages.of(context)!.following,
                                  style: const TextStyle(
                                      color: const Color(0xff2a2a2a),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Alexandria",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.4,
                              child: _readerProfileModel
                                          ?.data.following.length ==
                                      0
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          top: _height * 0.1,
                                          left: _width * 0.45,
                                          right: _width * 0.45),
                                      child: Center(
                                        child: Text(
                                          Languages.of(context)!.nodata,
                                          style: const TextStyle(
                                              fontFamily: Constants.fontfamily,
                                              color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: _height * 0.3,
                                      width: _width,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: _readerProfileModel!
                                            .data.following.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Transitioner(
                                                context: context,
                                                child: AuthorViewByUserScreen(
                                                  user_id: _readerProfileModel!
                                                      .data.following[index].id
                                                      .toString(),
                                                ),
                                                animation: AnimationType.fadeIn,
                                                // Optional value
                                                duration: Duration(
                                                    milliseconds: 1000),
                                                // Optional value
                                                replacement: false,
                                                // Optional value
                                                curveType: CurveType
                                                    .decelerate, // Optional value
                                              );
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: _width * 0.05,
                                                  right: _width * 0.05),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    width: _width * 0.22,
                                                    height: _height * 0.12,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              _readerProfileModel!
                                                                  .data
                                                                  .following[
                                                                      index]
                                                                  .profilePath
                                                                  .toString())),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: _height * 0.01,
                                                  ),
                                                  Text(
                                                    _readerProfileModel!
                                                        .data
                                                        .following[index]
                                                        .username
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontFamily: 'Lato',
                                                      color: Color(0xff313131),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                            ),
                            Positioned(
                              top: _height * 0.32,
                              left: _width * 0.1,
                              right: _width * 0.1,
                              child: Opacity(
                                opacity: 0.20000000298023224,
                                child: Container(
                                    width: 368,
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff3a6c83))),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.64,
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
                              child: Container(
                                height: _height * 0.3,
                                width: _width,
                                child: Text(
                                  Languages.of(context)!.continueReading,
                                  style: const TextStyle(
                                      color: const Color(0xff2a2a2a),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Alexandria",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.67,
                              child: _readerProfileModel!.data.books.length == 0
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          top: _height * 0.15,
                                          left: _width * 0.45,
                                          right: _width * 0.45),
                                      child: Center(
                                        child: Text(
                                          Languages.of(context)!.nodata,
                                          style: const TextStyle(
                                              fontFamily: Constants.fontfamily,
                                              color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: _height * 0.3,
                                      width: _width,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: _readerProfileModel!
                                            .data.books.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Transitioner(
                                                context: context,
                                                child: BookDetail(
                                                  bookID: _readerProfileModel!
                                                      .data.books[index].id
                                                      .toString(),
                                                ),
                                                animation: AnimationType.fadeIn,
                                                // Optional value
                                                duration: Duration(
                                                    milliseconds: 1000),
                                                // Optional value
                                                replacement: false,
                                                // Optional value
                                                curveType: CurveType
                                                    .decelerate, // Optional value
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Positioned(
                                                      child: Container(
                                                        width: _width * 0.22,
                                                        height: _height * 0.12,
                                                        margin: EdgeInsets.all(
                                                            _width * 0.05),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: Colors.black,
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  _readerProfileModel!
                                                                      .data
                                                                      .books[
                                                                          index]
                                                                      .bookImage
                                                                      .toString())),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        top: _height * 0.12,
                                                        left: _width * 0.07,
                                                        child: Icon(
                                                          Icons.remove_red_eye,
                                                          color: Colors.white,
                                                          size: _height *
                                                              _width *
                                                              0.00005,
                                                        )),
                                                  ],
                                                ),
                                                Text(
                                                  _readerProfileModel!
                                                      .data.books[index].title
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontFamily: 'Lato',
                                                    color: Color(0xff313131),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )),
                            ),
                            Positioned(
                                top: _height * 0.01,
                                left: _width * 0.01,
                                child: Container(
                                  height: _height * 0.05,
                                  width: _width * 0.1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.black.withOpacity(0.3)),
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: Color(0xffebf5f9),
                                      )),
                                )),
                          ],
                        )
                      : Stack(
                          children: [
                            Positioned(
                                child: Container(
                              height: double.infinity,
                              color: const Color(0xffebf5f9),
                            )),
                            Positioned(
                              child: Container(
                                height: _height * 0.25,
                                width: _width,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    alignment: Alignment.topCenter,
                                    image: NetworkImage(
                                      _authorProfileViewModel!
                                          .data.backgroundPath,
                                    ),
                                    // fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                child: InkWell(
                              onTap: () {
                                _getFromGallery();
                              },
                              child: Container(
                                height: _height * 0.25,
                                width: _width,
                                child: Container(
                                  height: _height * 0.05,
                                  width: _width * 0.05,
                                  margin: EdgeInsets.only(
                                      bottom: _height * 0.02,
                                      top: _height * 0.02),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black12,
                                  ),
                                  child: _isImageLoading
                                      ? const Center(
                                          child: CupertinoActivityIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.image,
                                            size: _height * _width * 0.00008,
                                            color: Colors.black26,
                                          ),
                                        ),
                                ),
                              ),
                            )),
                            Positioned(
                              left: _width * 0.02,
                              top: _height * 0.21,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: _height * 0.12,
                                    width: _width * 0.23,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: Colors.black,
                                        ),
                                        image: DecorationImage(
                                            image: _authorProfileViewModel!
                                                        .data.profilePhoto ==
                                                    ""
                                                ? AssetImage(
                                                    "assets/profile_pic.png")
                                                : NetworkImage(
                                                        _authorProfileViewModel!
                                                            .data.profilePath
                                                            .toString())
                                                    as ImageProvider,
                                            fit: BoxFit.cover)),
                                    // child:  Icon(
                                    //   Icons.person_pin,
                                    //   size: _height * _width * 0.0003,
                                    //   color: Colors.black54,
                                    // ),
                                  ),
                                  SizedBox(
                                    width: _width * 0.02,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: _height * 0.06),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: _width * 0.3,
                                          child: Text(
                                            _authorProfileViewModel!
                                                .data.username,
                                            style: const TextStyle(
                                                color: const Color(0xff2a2a2a),
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Neckar",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 11.0),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        SizedBox(
                                          height: _height * 0.01,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              Languages.of(context)!.followers,
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff3a6c83),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Lato",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 10.0),
                                            ),
                                            SizedBox(
                                              width: _width * 0.01,
                                            ),
                                            Text(
                                              _authorProfileViewModel!
                                                  .data.followers
                                                  .toString(),
                                              style: const TextStyle(
                                                  color:
                                                      const Color(0xff3a6c83),
                                                  fontWeight: FontWeight.w400,
                                                  fontFamily: "Lato",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: 10.0),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: _height * 0.05,
                                          left: context
                                                      .read<UserProvider>()
                                                      .SelectedLanguage ==
                                                  'English'
                                              ? _width * 0.15
                                              : 0.0,
                                          right: context
                                                      .read<UserProvider>()
                                                      .SelectedLanguage ==
                                                  'Arabic'
                                              ? _width * 0.15
                                              : 0.0,
                                        ),
                                        child: GestureDetector(
                                            onTap: () {
                                              if (_statusCheckModel!
                                                      .aggrement ==
                                                  false) {
                                                showTermsAndConditionAlert();
                                              } else {
                                                Transitioner(
                                                  context: context,
                                                  child: UploadDataScreen(),
                                                  animation:
                                                      AnimationType.slideLeft,
                                                  // Optional value
                                                  duration: Duration(
                                                      milliseconds: 1000),
                                                  // Optional value
                                                  replacement: false,
                                                  // Optional value
                                                  curveType: CurveType
                                                      .decelerate, // Optional value
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: _width * 0.25,
                                              height: _height * 0.04,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xff3a6c83),
                                                      width: 1),
                                                  color:
                                                      const Color(0xffebf5f9)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color:
                                                        const Color(0xff3a6c83),
                                                  ),
                                                  Text(
                                                      Languages.of(
                                                              context)!
                                                          .publishButton,
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff3a6c83),
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontFamily: "Lato",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 10.0),
                                                      textAlign: TextAlign.left)
                                                ],
                                              ),
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: _height * 0.01,
                                          left: context
                                                      .read<UserProvider>()
                                                      .SelectedLanguage ==
                                                  'English'
                                              ? _width * 0.15
                                              : 0.0,
                                          right: context
                                                      .read<UserProvider>()
                                                      .SelectedLanguage ==
                                                  'Arabic'
                                              ? _width * 0.15
                                              : 0.0,
                                        ),
                                        child: GestureDetector(
                                            onTap: () {
                                              Platform.isIOS
                                                  ? Share.share(
                                                      'https://apps.apple.com/ae/app/novelflex/id1661629198')
                                                  : Share.share(
                                                      'https://play.google.com/store/apps/details?id=com.appcom.estisharati.novel.flex');
                                            },
                                            child: Container(
                                              width: _width * 0.25,
                                              height: _height * 0.04,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all(
                                                      color: const Color(
                                                          0xff3a6c83),
                                                      width: 1),
                                                  color:
                                                      const Color(0xffebf5f9)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Icon(
                                                    Icons.share,
                                                    color:
                                                        const Color(0xff3a6c83),
                                                    size: _width *
                                                        _height *
                                                        0.00006,
                                                  ),
                                                  Text(
                                                      Languages.of(context)!
                                                          .profile,
                                                      style: const TextStyle(
                                                          color: const Color(
                                                              0xff3a6c83),
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontFamily: "Lato",
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          fontSize: 10.0),
                                                      textAlign: TextAlign.left)
                                                ],
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: _height * 0.36,
                              left: _width * 0.1,
                              right: _width * 0.1,
                              child: Opacity(
                                opacity: 0.20000000298023224,
                                child: Container(
                                    width: 368,
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: const Color(0xff3a6c83))),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.36,
                              child: GestureDetector(
                                onTap: () {
                                  _showPrivateAdvertisingPopup();
                                },
                                child: Container(
                                  margin: EdgeInsets.all(16.0),
                                  height: _height * 0.12,
                                  width: _width * 0.9,
                                  decoration: BoxDecoration(
                                      border: RDottedLineBorder.all(
                                          width: 1, color: Colors.black54),
                                      color: Colors.transparent),
                                  child: Padding(
                                    padding: EdgeInsets.only(
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
                                        top: _height * 0.02),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        docUploader ?
                                        CupertinoActivityIndicator(
                                           color: Colors.black,
                                        ) :RichText(
                                          text: new TextSpan(
                                            style: const TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w300,
                                                fontFamily: "Alexandria",
                                                fontStyle: FontStyle.normal,
                                                fontSize: 12.0),
                                            children: <TextSpan>[
                                              new TextSpan(
                                                  text: Languages.of(context)!
                                                          .ads_link +
                                                      " "),
                                              new TextSpan(
                                                  text: Languages.of(context)!
                                                      .ads_link_2,
                                                  style: new TextStyle(
                                                      color: Color(0xff3a6c83),
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.5,
                              child: Container(
                                margin: EdgeInsets.all(16.0),
                                height: _height * 0.2,
                                width: _width * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white),
                                child: Padding(
                                  padding: EdgeInsets.only(
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
                                      top: _height * 0.02),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(Languages.of(context)!.aboutAuthor,
                                          style: const TextStyle(
                                              color: const Color(0xff2a2a2a),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Alexandria",
                                              fontStyle: FontStyle.normal,
                                              fontSize: 16.0),
                                          textAlign: TextAlign.left),
                                      SizedBox(
                                        height: _height * 0.01,
                                      ),
                                      Text(
                                        _authorProfileViewModel!
                                            .data.description
                                            .toString(),
                                        style: const TextStyle(
                                            color: const Color(0xff676767),
                                            fontWeight: FontWeight.w400,
                                            fontFamily: "Lato",
                                            fontStyle: FontStyle.normal,
                                            fontSize: 14.0),
                                        overflow: TextOverflow.fade,
                                        maxLines: 6,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.75,
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
                              child: Container(
                                height: _height * 0.3,
                                width: _width,
                                child: Text(
                                  Languages.of(context)!.novels,
                                  style: const TextStyle(
                                      color: const Color(0xff2a2a2a),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Alexandria",
                                      fontStyle: FontStyle.normal,
                                      fontSize: 16.0),
                                ),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.75,
                              left: userProvider.SelectedLanguage == "English"
                                  ? _width * 0.8
                                  : 0.0,
                              right: userProvider.SelectedLanguage == "English"
                                  ? 0.0
                                  : _width * 0.8,
                              child: GestureDetector(
                                onTap: () {
                                  Transitioner(
                                    context: context,
                                    child: UploadHistoryscreen(
                                      route: 0,
                                    ),
                                    animation: AnimationType
                                        .slideTop, // Optional value
                                    duration: Duration(
                                        milliseconds: 1000), // Optional value
                                    replacement: false, // Optional value
                                    curveType:
                                        CurveType.decelerate, // Optional value
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      Languages.of(context)!.editT,
                                      style: const TextStyle(
                                          color: const Color(0xff3a6c83),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Lato",
                                          fontStyle: FontStyle.normal,
                                          fontSize: 12.0),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Color(
                                        0xff002333,
                                      ),
                                      size: _width * 0.04,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: _height * 0.77,
                              child: _authorProfileViewModel!
                                          .data.book.length ==
                                      0
                                  ? Padding(
                                      padding: EdgeInsets.all(
                                          _height * _width * 0.0004),
                                      child: Center(
                                        child: Text(
                                          Languages.of(context)!
                                              .nouploadhistory,
                                          style: const TextStyle(
                                              fontFamily: Constants.fontfamily,
                                              color: Colors.black54),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: _height * 0.3,
                                      width: _width,
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        itemCount: _authorProfileViewModel!
                                            .data.book.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Transitioner(
                                                context: context,
                                                child: BookDetail(
                                                  bookID:
                                                      _authorProfileViewModel!
                                                          .data.book[index].id
                                                          .toString(),
                                                ),
                                                animation: AnimationType.fadeIn,
                                                // Optional value
                                                duration: Duration(
                                                    milliseconds: 1000),
                                                // Optional value
                                                replacement: false,
                                                // Optional value
                                                curveType: CurveType
                                                    .decelerate, // Optional value
                                              );
                                            },
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: _width * 0.22,
                                                      height: _height * 0.12,
                                                      margin: EdgeInsets.all(
                                                          _width * 0.05),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        color: Colors.black,
                                                        image: DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: _authorProfileViewModel!
                                                                        .data
                                                                        .book[
                                                                            index]
                                                                        .imagePath
                                                                        .toString() ==
                                                                    ""
                                                                ? const AssetImage(
                                                                    "assets/quotes_data/manga image.png")
                                                                : NetworkImage(_authorProfileViewModel!
                                                                        .data
                                                                        .book[index]
                                                                        .imagePath
                                                                        .toString())
                                                                    as ImageProvider),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        top: _height * 0.12,
                                                        left: _width * 0.07,
                                                        child: Icon(
                                                          Icons.remove_red_eye,
                                                          color: Colors.white,
                                                          size: _height *
                                                              _width *
                                                              0.00005,
                                                        )),
                                                  ],
                                                ),
                                                Text(
                                                  _authorProfileViewModel!
                                                      .data.book[index].title
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontFamily: 'Lato',
                                                    color: Color(0xff313131),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.normal,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )),
                            ),
                            Positioned(
                                top: _height * 0.01,
                                left: _width * 0.01,
                                child: Container(
                                  height: _height * 0.05,
                                  width: _width * 0.1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.black.withOpacity(0.3)),
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        Icons.arrow_back_ios,
                                        color: Color(0xffebf5f9),
                                      )),
                                )),
                          ],
                        )
              : Center(
                  child: Constants.InternetNotConnected(_height * 0.03),
                ),
        ),
      ),
    );
  }

  Future AUTHOR_PROFILE() async {
    var map = Map<String, dynamic>();
    map['user_id'] = _statusCheckModel!.data.id.toString();

    final response =
        await http.post(Uri.parse(ApiUtils.AUTHOR_BOOKS_DETAILS_API),
            headers: {
              'Authorization':
                  "Bearer ${context.read<UserProvider>().UserToken}",
            },
            body: map);

    if (response.statusCode == 200) {
      print("author_executed");
      print('author_profile${response.body}');
      var jsonData = response.body;
      //var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _authorProfileViewModel = authorProfileViewModelFromJson(jsonData);
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

  Future READER_PROFILE() async {
    final response =
        await http.get(Uri.parse(ApiUtils.READER_PROFILE_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('reader_profile_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _readerProfileModel = readerProfileModelFromJson(jsonData);

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
      CHECK_STATUS();
    }
  }

  Future<void> UploadCoverImageApi() async {
    setState(() {
      _isImageLoading = true;
    });
    Map<String, String> headers = {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}"
    };

    var jsonResponse;

    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiUtils.UPLOAD_BACKGROUND_IMAGE_API));
    request.files.add(http.MultipartFile.fromBytes(
      "background_image",
      File(_cover_imageFile!.path)
          .readAsBytesSync(), //UserFile is my JSON key,use your own and "image" is the pic im getting from my gallary
      filename: "Image.jpg",
      contentType: MediaType('image', 'jpg'),
    ));

    request.headers.addAll(headers);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          print("Cover Image Uploaded! ");
          print('COVER_image_upload ' + response.body);
          Constants.showToastBlack(
              context, "your background  image updated successfully");
          setState(() {
            _isImageLoading = false;
          });
          _checkInternetConnection();
        }
      });
    });
  }

  _getFromGallery() async {
    final PickedFile? image = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      _cover_imageFile = File(image.path);
      setState(() {
        _cover_imageFile = File(image.path);
      });
      UploadCoverImageApi();
    }
  }

  Future CHECK_STATUS() async {
    final response =
        await http.get(Uri.parse(ApiUtils.CHECK_PROFILE_STATUS_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('status_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _statusCheckModel = statusCheckModelFromJson(jsonData);
        if (_statusCheckModel!.data.type == "Reader") {
          READER_PROFILE();
        } else {
          AUTHOR_PROFILE();
        }
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  showTermsAndConditionAlert() {
    bool agree = false;
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    showDialog(
        barrierDismissible: true,
        barrierColor: Colors.black54,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Stack(
              children: [
                AlertDialog(
                  backgroundColor: Color(0xFFe4e6fb),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        20.0,
                      ),
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(
                    top: 10.0,
                  ),
                  title: Text(
                    Languages.of(context)!.terms,
                    style: const TextStyle(
                        fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                  content: Container(
                    height: 400,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              Languages.of(context)!.longTextTerms,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          Material(
                            color: Color(0xFFe4e6fb),
                            child: Checkbox(
                              value: agree,
                              onChanged: (value) {
                                setState(() {
                                  agree = value ?? false;
                                });
                              },
                            ),
                          ),
                          Text(
                            Languages.of(context)!.termsText_1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 10.0),
                          ),
                          SizedBox(
                            height: _height * 0.05,
                          ),
                          Container(
                            width: double.infinity,
                            height: 60,
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: agree ? _doSomething : null,
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFF256D85),
                                // fixedSize: Size(250, 50),
                              ),
                              child: Text(
                                Languages.of(context)!.agree,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: _height * 0.05,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: _height * 0.15,
                    left: _width * 0.87,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: _height * 0.08,
                        width: _width * 0.08,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/quotes_data/cancel_icon.png"))),
                      ),
                    ))
              ],
            );
          });
        });
  }

  void _doSomething() {
    setState(() {
      _updateTermsAndConditions();
      Navigator.pop(context);
    });
  }

  Future _updateTermsAndConditions() async {
    final response = await http.post(Uri.parse(ApiUtils.AGREEMENT_API),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}"
        });

    if (response.statusCode == 200) {
      print('update_profile_response under 200 ${response.body}');
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          _statusCheckModel!.aggrement = true;
        });
        Transitioner(
          context: context,
          child: UploadDataScreen(),
          animation: AnimationType.slideLeft,
          // Optional value
          duration: Duration(milliseconds: 1000),
          // Optional value
          replacement: false,
          // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
      } else {
        Constants.showToastBlack(context, "Some things went wrong");
      }
    }
  }

  Future<void> _showPrivateAdvertisingPopup() async {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    await showDialog<void>(
        context: context,
        builder: (BuildContext ctx) {
          return SimpleDialog(
            // <-- SEE HERE
            contentPadding: EdgeInsets.all(_width * 0.05),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            children: <Widget>[
              Center(
                  child: Text(
                Languages.of(context)!.popText_1,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    fontFamily: "Alexandria",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
              )),
              SizedBox(
                height: _height * 0.03,
              ),
              Center(
                  child: Text(
                Languages.of(context)!.popText_2,
                style: const TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w300,
                    fontFamily: "Alexandria",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
              )),
              SizedBox(
                height: _height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: _height * 0.02, horizontal: _width * 0.04),
                child: Container(
                  width: double.infinity,
                  height: _height * 0.08,
                  child: TextFormField(
                    key: _linkKey,
                    controller: _linkController,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      counterText: "",
                      filled: true,
                      suffix: Icon(
                        Icons.link,
                        color: Colors.black45,
                      ),
                      fillColor: Colors.white,
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.white12,
                        ),
                      ),
                      disabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF256D85),
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color(0xFF256D85),
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.red,
                          )),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Colors.red,
                        ),
                      ),
                      hintText: Languages.of(context)!.popText_6,
                      // labelText: Languages.of(context)!.email,
                      hintStyle: const TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Lato",
                          fontStyle: FontStyle.normal,
                          fontSize: 10.0),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _getFromGalleryAds();
                },
                child: Container(
                  margin: EdgeInsets.all(16.0),
                  height: _height * 0.15,
                  width: _width * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: RDottedLineBorder.all(
                          width: 1, color: Colors.black54),
                      color: Colors.transparent),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: context.read<UserProvider>().SelectedLanguage ==
                                'English'
                            ? _width * 0.05
                            : 0.0,
                        right: context.read<UserProvider>().SelectedLanguage ==
                                'Arabic'
                            ? _width * 0.05
                            : 0.0,
                        top: _height * 0.02),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RichText(
                          text: new TextSpan(
                            style: const TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.w300,
                                fontFamily: "Alexandria",
                                fontStyle: FontStyle.normal,
                                fontSize: 12.0),
                            children: <TextSpan>[
                              new TextSpan(
                                  text: Languages.of(context)!.popText_3,
                                  style: new TextStyle(
                                      color: Color(0xff3a6c83),
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  if(_AdsName.isNotEmpty && _linkController!.text.isNotEmpty){
                    PrivateAdApi();
                    Navigator.pop(context);
                  }else{
                    ToastConstant.showToast(context, Languages.of(context)!.link_image_text);
                  }
                },
                child: Container(
                  width: _width * 0.8,
                  height: _height * 0.05,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xff3a6c83),
                      width: 2,
                    ),
                    color: const Color(0xff3a6c83),
                  ),
                  child: Center(
                    child: Text(
                      Languages.of(context)!.popText_4,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Lato",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                },
                child: Container(
                  width: _width * 0.8,
                  height: _height * 0.05,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: const Color(0xff3a6c83),
                        width: 2,
                      )),
                  child: Center(
                    child: Text(
                      Languages.of(context)!.popText_5,
                      style: const TextStyle(
                          color: const Color(0xff3a6c83),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Lato",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _height * 0.03,
              ),
            ],
          );
        });
  }


  Future<void> PrivateAdApi() async {
    setState(() {
      docUploader = true;
    });
    Map<String, String> headers = {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    };
    var jsonResponse;

    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiUtils.ADD_PRIVATE_ADS_API));
    request.fields['link'] = _linkController!.text.trim();
    request.files.add(new http.MultipartFile.fromBytes(
      "image",
      File(_Ads_imageFile!.path)
          .readAsBytesSync(), //UserFile is my JSON key,use your own and "image" is the pic im getting from my gallary
      filename: _AdsName,
      contentType: MediaType('image', 'jpg'),
    ));

    request.headers.addAll(headers);

    request.send().then((result) async {
      http.Response.fromStream(result).then((response) {
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          if (jsonData['status'] == 200) {
            setState(() {
              docUploader = false;
            });
            loading();
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

  _getFromGalleryAds() async {
    final PickedFile? image = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      _Ads_imageFile = File(image.path);
      setState(() {
        _Ads_imageFile = File(image.path);
        _AdsName = image.path.split('/').last;
      });
    }
  }

  void loading() {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        animType: QuickAlertAnimType.slideInUp,
        confirmBtnColor: Color(0xFF256D85),
        confirmBtnText: Languages.of(context)!.view,
        onConfirmBtnTap: (){
          Transitioner(
            context: context,
            child: AuthorViewByUserScreen(
              user_id:_authorProfileViewModel!.data.id.toString(),
            ),
            animation: AnimationType.fadeIn,
            duration:
            Duration(milliseconds: 1000),
            replacement: true,
            curveType: CurveType.decelerate,
          );
    }
    );

  }
}
