import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mailto/mailto.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:novelflex/MixScreens/AccountInfoScreen.dart';
import 'package:novelflex/Models/UserReferralModel.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:transitioner/transitioner.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../MixScreens/FaqScreen.dart';
import '../MixScreens/PieChartScreen.dart';
import '../MixScreens/ProfileScreens/HomeProfileScreen.dart';
import '../MixScreens/Uploadscreens/UploadDataScreen.dart';
import '../MixScreens/WalletDirectory/MyWalletScreen.dart';
import '../MixScreens/WalletDirectory/Unlock_wallet_screen_one.dart';
import '../MixScreens/author_profile_links.dart';
import '../MixScreens/disclimar_screen.dart';
import '../Models/MenuProfileModel.dart';
import '../Models/ReaderProfileModel.dart';
import '../Models/StatusCheckModel.dart';
import '../Models/language_model.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../Widgets/loading_widgets.dart';
import '../ad_helper.dart';
import '../localization/Language/languages.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animated_icons/lottiefiles.dart';
import 'package:lottie/lottie.dart';

import '../localization/locale_constants.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  StatusCheckModel? _statusCheckModel;
  UserReferralModel? _userReferralModel;
  MenuProfileModel? _menuProfileModel;
  bool _isLoading = false;
  bool _isStart = false;
  bool _isInternetConnected = true;
  bool isCheck = true;
  InterstitialAd? _interstitialAd;

  @override
  void initState() {
    _checkInternetConnection();
    _loadInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              Transitioner(
                context: context,
                child: HomeProfileScreen(),
                animation: AnimationType.slideLeft, // Optional value
                duration: Duration(milliseconds: 1000), // Optional value
                replacement: false, // Optional value
                curveType: CurveType.decelerate, // Optional value
              );
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf6f9),
      body: SafeArea(
        child: _isInternetConnected
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
                : SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Stack(
                      children: [
                        Positioned(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: _height * 0.03,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Transitioner(
                                        context: context,
                                        child: AccountScreen(),
                                        animation: AnimationType
                                            .slideBottom, // Optional value
                                        duration: Duration(
                                            milliseconds:
                                                1000), // Optional value
                                        replacement: false, // Optional value
                                        curveType: CurveType
                                            .decelerate, // Optional value
                                      );
                                    },
                                    child: RippleAnimation(
                                      color: Color(0xff1b4a6b),
                                      delay: const Duration(milliseconds: 3),
                                      repeat: true,
                                      minRadius: 40,
                                      ripplesCount: 6,
                                      child: CircleAvatar(
                                        radius: _width * _height * 0.0002,
                                        backgroundColor: Colors.black12,
                                        backgroundImage: _menuProfileModel!
                                                    .data.profilePhoto !=
                                                ""
                                            ? NetworkImage(
                                                _menuProfileModel!
                                                    .data.profilePath,
                                              )
                                            : AssetImage(
                                                    'assets/profile_pic.png')
                                                as ImageProvider,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: _height * 0.03,
                                  ),
                                  Container(
                                    color: const Color(0xffebf5f9),
                                    child: Column(
                                      children: [
                                        Text(
                                          (_menuProfileModel!.data.username),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Color(0xff1b4a6b),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Neckar",
                                              fontStyle: FontStyle.normal,
                                              fontSize:
                                                  _height * _width * 0.00005),
                                        ),
                                        SizedBox(
                                          height: 6.0,
                                        ),
                                        Text(
                                          _menuProfileModel!.data.email,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: const Color(0xff676767),
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Alexandria",
                                              fontStyle: FontStyle.normal,
                                              fontSize:
                                                  _height * _width * 0.00004),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: _height * 0.03,
                              ),
                              Opacity(
                                opacity: 0.5,
                                child: Container(
                                    width: _width * 0.7,
                                    height: 1,
                                    decoration: BoxDecoration(
                                        color: const Color(0xffbcbcbc))),
                              ),
                              SizedBox(
                                height: _height * 0.03,
                              ),
                              Visibility(
                                visible:
                                    _statusCheckModel!.data.type == "Writer",
                                child: GestureDetector(
                                  onTap: () {
                                    Transitioner(
                                      context: context,
                                      child: AddAuthorProfileLinks(),
                                      animation: AnimationType
                                          .slideLeft, // Optional value
                                      duration: Duration(
                                          milliseconds: 1000), // Optional value
                                      replacement: false, // Optional value
                                      curveType: CurveType
                                          .decelerate, // Optional value
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(_width * 0.03),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.link,
                                              size: _height * _width * 0.00009,
                                              color: Color(0xff1b4a6b),
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Text(
                                                Languages.of(context)!.addLinks,
                                                style: TextStyle(
                                                    color: Color(0xff1b4a6b),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Neckar",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: _height *
                                                        _width *
                                                        0.00005),
                                                textAlign: TextAlign.left)
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: _height * _width * 0.00007,
                                          color: Color(0xff1b4a6b),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Transitioner(
                                    context: context,
                                    child: AccountScreen(),
                                    animation: AnimationType
                                        .slideBottom, // Optional value
                                    duration: Duration(
                                        milliseconds: 1000), // Optional value
                                    replacement: false, // Optional value
                                    curveType:
                                        CurveType.decelerate, // Optional value
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(_width * 0.03),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.manage_accounts_outlined,
                                            size: _height * _width * 0.0001,
                                            color: Color(0xff1b4a6b),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(Languages.of(context)!.account,
                                              style: TextStyle(
                                                  color: Color(0xff1b4a6b),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Neckar",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: _height *
                                                      _width *
                                                      0.00005),
                                              textAlign: TextAlign.left)
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: _height * _width * 0.00007,
                                        color: Color(0xff1b4a6b),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _loadInterstitialAd();
                                  if (_interstitialAd != null) {
                                    _interstitialAd?.show();
                                  } else {
                                    Transitioner(
                                      context: context,
                                      child: HomeProfileScreen(),
                                      animation: AnimationType
                                          .slideLeft, // Optional value
                                      duration: Duration(
                                          milliseconds: 1000), // Optional value
                                      replacement: false, // Optional value
                                      curveType: CurveType
                                          .decelerate, // Optional value
                                    );
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(_width * 0.03),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.account_circle_outlined,
                                            size: _height * _width * 0.0001,
                                            color: Color(0xff1b4a6b),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(Languages.of(context)!.myProfile,
                                              style: TextStyle(
                                                  color: Color(0xff1b4a6b),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Neckar",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: _height *
                                                      _width *
                                                      0.00005),
                                              textAlign: TextAlign.left)
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: _height * _width * 0.00007,
                                        color: Color(0xff1b4a6b),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:
                                    _statusCheckModel!.data.type == "Writer",
                                child: GestureDetector(
                                  onTap: () {
                                    CHECK_STATUS_Publish();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(_width * 0.03),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.menu_book_outlined,
                                              size: _height * _width * 0.00009,
                                              color: Color(0xff1b4a6b),
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Text(
                                                Languages.of(context)!
                                                    .publishNovel,
                                                style: TextStyle(
                                                    color: Color(0xff1b4a6b),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Neckar",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: _height *
                                                        _width *
                                                        0.00005),
                                                textAlign: TextAlign.left)
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: _height * _width * 0.00007,
                                          color: Color(0xff1b4a6b),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  supportTeam();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(_width * 0.03),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.mark_email_read_outlined,
                                            size: _height * _width * 0.0001,
                                            color: Color(0xff1b4a6b),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(
                                              Languages.of(context)!
                                                  .supportTeam,
                                              style: TextStyle(
                                                  color: Color(0xff1b4a6b),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Neckar",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: _height *
                                                      _width *
                                                      0.00005),
                                              textAlign: TextAlign.left)
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: _height * _width * 0.00007,
                                        color: Color(0xff1b4a6b),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Transitioner(
                                    context: context,
                                    child: MyWalletScreen(),
                                    animation: AnimationType
                                        .slideLeft, // Optional value
                                    duration: Duration(
                                        milliseconds: 1000), // Optional value
                                    replacement: false, // Optional value
                                    curveType:
                                        CurveType.decelerate, // Optional value
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(_width * 0.03),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.card_travel,
                                            size: _height * _width * 0.0001,
                                            color: Color(0xff1b4a6b),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(Languages.of(context)!.myWallet,
                                              style: TextStyle(
                                                  color: Color(0xff1b4a6b),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Neckar",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: _height *
                                                      _width *
                                                      0.00005),
                                              textAlign: TextAlign.left)
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: _height * _width * 0.00007,
                                        color: Color(0xff1b4a6b),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _checkInternetConnectionInviteApp();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(_width * 0.03),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.share,
                                            size: _height * _width * 0.0001,
                                            color: Color(0xff1b4a6b),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(Languages.of(context)!.inviteApp,
                                              style: TextStyle(
                                                  color: Color(0xff1b4a6b),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Neckar",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: _height *
                                                      _width *
                                                      0.00005),
                                              textAlign: TextAlign.left)
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: _height * _width * 0.00007,
                                        color: Color(0xff1b4a6b),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Visibility(
                                visible:
                                    _statusCheckModel!.data.type == "Writer",
                                child: GestureDetector(
                                  onTap: () {
                                    Transitioner(
                                      context: context,
                                      child: PieChartScreen(),
                                      animation: AnimationType
                                          .slideLeft, // Optional value
                                      duration: Duration(
                                          milliseconds: 1000), // Optional value
                                      replacement: false, // Optional value
                                      curveType: CurveType
                                          .decelerate, // Optional value
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(_width * 0.03),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.bar_chart,
                                              size: _height * _width * 0.0001,
                                              color: Color(0xff1b4a6b),
                                            ),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Text(
                                                Languages.of(context)!
                                                    .Statistics,
                                                style: TextStyle(
                                                    color: Color(0xff1b4a6b),
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Neckar",
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: _height *
                                                        _width *
                                                        0.00005),
                                                textAlign: TextAlign.left)
                                          ],
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios,
                                          size: _height * _width * 0.00007,
                                          color: Color(0xff1b4a6b),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  funcOpenMailComposer();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(_width * 0.03),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.mark_email_unread_outlined,
                                            size: _height * _width * 0.0001,
                                            color: Color(0xff1b4a6b),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(Languages.of(context)!.ContactUs,
                                              style: TextStyle(
                                                  color: Color(0xff1b4a6b),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Neckar",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: _height *
                                                      _width *
                                                      0.00005),
                                              textAlign: TextAlign.left)
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: _height * _width * 0.00007,
                                        color: Color(0xff1b4a6b),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Transitioner(
                                    context: context,
                                    child: FaqScreen(),
                                    animation: AnimationType
                                        .slideLeft, // Optional value
                                    duration: Duration(
                                        milliseconds: 1000), // Optional value
                                    replacement: false, // Optional value
                                    curveType:
                                        CurveType.decelerate, // Optional value
                                  );
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(_width * 0.03),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            child: Icon(
                                              Icons.pan_tool_alt_outlined,
                                              size: _height * _width * 0.0001,
                                              color: Color(0xff1b4a6b),
                                            ),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white12),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(Languages.of(context)!.faq,
                                              style: TextStyle(
                                                  color: Color(0xff1b4a6b),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Neckar",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: _height *
                                                      _width *
                                                      0.00005),
                                              textAlign: TextAlign.left)
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: _height * _width * 0.00007,
                                        color: Color(0xff1b4a6b),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Platform.isIOS
                                      ? _launchIOSUrl()
                                      : _launchAndroidUrl();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(_width * 0.03),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star_border_rounded,
                                            size: _height * _width * 0.0001,
                                            color: Color(0xff1b4a6b),
                                          ),
                                          SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(Languages.of(context)!.rate_Us,
                                              style: TextStyle(
                                                  color: Color(0xff1b4a6b),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Neckar",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: _height *
                                                      _width *
                                                      0.00005),
                                              textAlign: TextAlign.left)
                                        ],
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: _height * _width * 0.00007,
                                        color: Color(0xff1b4a6b),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_menuProfileModel!.data.totalAmount >=
                                      5) {
                                    Transitioner(
                                      context: context,
                                      child: UnlockWalletScreenOne(),
                                      animation: AnimationType
                                          .fadeIn, // Optional value
                                      duration: Duration(
                                          milliseconds: 1000), // Optional value
                                      replacement: false, // Optional value
                                      curveType: CurveType
                                          .decelerate, // Optional value
                                    );
                                  } else {
                                    // ToastConstant.showToast(context, Languages.of(context)!.amountWithDraw);

                                    showDialogMoney();
                                  }
                                },
                                child: Container(
                                  width: _width * 0.5,
                                  height: _height * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: const Color(0x24000000),
                                          offset: Offset(0, 7),
                                          blurRadius: 14,
                                          spreadRadius: 0)
                                    ],
                                    gradient: LinearGradient(
                                        begin: Alignment(-0.03018629550933838,
                                            -0.03894212305545807),
                                        end: Alignment(1.3960868120193481,
                                            1.4281718730926514),
                                        colors: [
                                          Color(0xff246897),
                                          Color(0xff1b4a6b),
                                        ]),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.card_travel,
                                        size: _height * _width * 0.0001,
                                        color: Colors.white,
                                      ),
                                      Text(Languages.of(context)!.unlockWallet,
                                          style: TextStyle(
                                              color: const Color(0xffffffff),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Lato",
                                              fontStyle: FontStyle.normal,
                                              fontSize:
                                                  _height * _width * 0.00004),
                                          textAlign: TextAlign.center),
                                      SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: _height * 0.02,
                              ),
                              Container(
                                width: _width * 0.5,
                                height: _height * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
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
                                child: _createLanguageDropDown(context),
                              ),
                              SizedBox(
                                height: _height * 0.02,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialogA();
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout_outlined,
                                      size: _height * _width * 0.0001,
                                      color: Color(0xff1b4a6b),
                                    ),
                                    Text(Languages.of(context)!.LogOut,
                                        style: TextStyle(
                                            color: Color(0xff1b4a6b),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Alexandria",
                                            fontStyle: FontStyle.normal,
                                            fontSize:
                                                _height * _width * 0.00005),
                                        textAlign: TextAlign.right)
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: _height * 0.04,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            top: _height * 0.5,
                            width: _width * 0.99,
                            child: Visibility(
                              visible: _isStart,
                              child: CupertinoActivityIndicator(
                                color: Colors.black,
                              ),
                            ))
                      ],
                    ),
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
      ),
    );
  }

  void funcOpenMailComposer() async {
    final mailtoLink = Mailto(
      to: ['n0velflexsupp0rt@gmail.com'],
      cc: ['zahidrehman507@gmail.com', 'support@estisharati.net'],
      subject: '',
      body: '',
    );
    await launch('$mailtoLink');
  }

  void supportTeam() async {
    final mailtoLink = Mailto(
      to: ['support@novelflex.com'],
      // cc: ['mjawadsagheer@gmail.com','asaad@estisharati.net'],
      subject: '',
      body: '',
    );
    await launch('$mailtoLink');
  }

  void showDialogA() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            Languages.of(context)!.alert,
            style: TextStyle(fontFamily: Constants.fontfamily),
          ),
          content: Text(
            Languages.of(context)!.dialogAreyousure,
            style: TextStyle(fontFamily: Constants.fontfamily),
          ),
          actions: [
            CupertinoDialogAction(
                child: Text(
                  Languages.of(context)!.yes,
                  style: TextStyle(fontFamily: Constants.fontfamily),
                ),
                onPressed: () {
                  UserProvider userProvider =
                      Provider.of<UserProvider>(this.context, listen: false);

                  userProvider.setUserToken("");
                  userProvider.setUserEmail("");
                  userProvider.setUserName("");
                  Phoenix.rebirth(context);
                  Navigator.of(context).pop();
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

  void showDialogMoney() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(
            Languages.of(context)!.alert,
            style: TextStyle(fontFamily: Constants.fontfamily),
          ),
          content: Text(
            Languages.of(context)!.amountWithDraw,
            style: TextStyle(fontFamily: Constants.fontfamily),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                Languages.of(context)!.dismiss,
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

  _launchIOSUrl() async {
    var url = Uri.parse("https://apps.apple.com/ae/app/novelflex/id1661629198");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchAndroidUrl() async {
    var url = Uri.parse(
        "https://play.google.com/store/apps/details?id=com.appcom.estisharati.novel.flex");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
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
        MENU_PROFILE_API();
      } else {
        // ToastConstant.showToast(context, jsonData1['message'].toString());
        Constants.warning(context);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future MENU_PROFILE_API() async {
    final response =
        await http.get(Uri.parse(ApiUtils.MENU_PROFILE_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('menu_profile_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _menuProfileModel = menuProfileModelFromJson(jsonData);

        setState(() {
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
      CHECK_STATUS();
    }
  }

  Future<void> _createDynamicLink(var referralCode) async {
    Uri url;
    String link =
        "https://novelflexapp.page.link/?referral_code=${referralCode}";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://novelflexapp.page.link',
      link: Uri.parse(link),
      androidParameters: const AndroidParameters(
        packageName: 'com.appcom.estisharati.novel.flex',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
          bundleId: 'com.appcom.estisharati.novel.flex.novelflex',
          minimumVersion: '1.0.1',
          appStoreId: '1661629198'),
    );

    final shortLink = await dynamicLinks.buildLink(parameters);
    url = shortLink;
    await Share.share(
        'Congratulation You have been invited by ${context.read<UserProvider>().UserName} to NovelFlex $url');
    print("url_dynamic  ${url}");
  }

  Future<void> _createDynamicLinkShort2(var referralCode) async {

    String link =
        "https://novelflexa.page.link/?referral_code=${referralCode}";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://novelflexa.page.link',
      link: Uri.parse(link),
      androidParameters: const AndroidParameters(
        packageName: 'com.appcom.estisharati.novel.flex',
        minimumVersion: 21,
      ),
      iosParameters: const IOSParameters(
          bundleId: 'com.appcom.estisharati.novel.flex.novelflex',
          minimumVersion: '1.0.1',
          appStoreId: '1661629198'),
    );

    Uri url;
      final ShortDynamicLink shortLink =
      await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;

    await Share.share(
        'Congratulation You have been invited by ${context.read<UserProvider>().UserName} to NovelFlex $url');

    print("url_dynamic  ${url}");

  }

  Future GET_REFER_CODE() async {
    final response =
        await http.get(Uri.parse(ApiUtils.USER_REFERRAL_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('referralApi_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        if (jsonData1['success'] == false) {
          // _createDynamicLink("");
          _createDynamicLinkShort2("");
        } else {
          _userReferralModel = userReferralModelFromJson(jsonData);
          // _createDynamicLink(
          //     _userReferralModel!.success![0]!.referralCode.toString());

          _createDynamicLinkShort2(
              _userReferralModel!.success![0]!.referralCode.toString());

          // print(" referal_Code ${_userReferralModel!.success![0]!.referralCode.toString()}");
        }

        // if(_userReferralModel!.success![0]!.referralCode!=""||_userReferralModel!.success![0]!.referralCode!=null){
        //   _createDynamicLink(_userReferralModel!.success![0]!.referralCode.toString());
        // }else{
        //
        // }

      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
      }
    }
  }

  Future _checkInternetConnectionInviteApp() async {
    if (this.mounted) {}

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
      GET_REFER_CODE();
    }
  }

  Future CHECK_STATUS_Publish() async {
    setState(() {
      _isStart = true;
    });
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

        _statusCheckModel!.aggrement == false
            ? showTermsAndConditionAlert()
            : Transitioner(
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

        setState(() {
          _isStart = false;
        });

        setState(() {
          _isLoading = false;
        });
      } else {}
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

  _createLanguageDropDown(BuildContext context) {
    return Container(
      height: 40.0,
      child: DropdownButton<LanguageModel>(
        iconSize: 30,
        iconEnabledColor: Colors.white,
        underline: SizedBox(),
        isExpanded: true,
        hint: Text(
          Languages.of(context)!.labelSelectLanguage,
          style: TextStyle(
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w700,
              fontFamily: "Lato",
              fontStyle: FontStyle.normal,
              fontSize: 13),
        ),
        onChanged: (LanguageModel? language) {
          changeLanguage(context, language!.languageCode);
          UserProvider userProviderlng =
              Provider.of<UserProvider>(this.context, listen: false);
          userProviderlng.setLanguage(language.name);

          print("my_lang: ${userProviderlng.SelectedLanguage}");
        },
        items: LanguageModel.languageList()
            .map<DropdownMenuItem<LanguageModel>>(
              (e) => DropdownMenuItem<LanguageModel>(
                value: e,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      e.flag,
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      e.name,
                    )
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
