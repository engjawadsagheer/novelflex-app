import 'dart:convert';
import 'package:flutter_animated_icons/lottiefiles.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/MixScreens/FaqScreen.dart';
import 'package:novelflex/MixScreens/ProfileScreens/HomeProfileScreen.dart';
import 'package:novelflex/TabScreens/SearchScreen.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:transitioner/transitioner.dart';
import 'MixScreens/Uploadscreens/UploadDataScreen.dart';
import 'MixScreens/Uploadscreens/upload_history_screen.dart';
import 'Models/StatusCheckModel.dart';
import 'Provider/UserProvider.dart';
import 'TabScreens/Menu_screen.dart';
import 'TabScreens/MyCorner.dart';
import 'TabScreens/home_screen.dart';
import 'Utils/ApiUtils.dart';
import 'Utils/Colors.dart';
import 'package:http/http.dart' as http;

import 'Utils/Constants.dart';
import 'Utils/toast.dart';
import 'localization/Language/languages.dart';

class TabScreen extends StatefulWidget {
  const TabScreen({Key? key}) : super(key: key);

  @override
  State<TabScreen> createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> with TickerProviderStateMixin {
  int pageIndex = 2;
  StatusCheckModel? _statusCheckModel;
  bool _isLoading = false;
  late AnimationController _addController;
  StatusCheckModel? _statusCheckModelType;
  final Screen = [
    SearchScreen(),
    MyCorner(),
    HomeScreen(
      route: 'tab',
    ),
    MenuScreen(),
  ];

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  @override
  void initState() {
    // CHECK_STATUSType();
    _addController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _addController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: AppColors.primaryColor,
      body: Screen[pageIndex],
      // drawer: DrawerCode(),
      bottomNavigationBar: buildMyNavBar(context),
    );
  }

  Container buildMyNavBar(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.08,
      color: const Color(0xfffffffa),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                pageIndex = 0;
              });
            },
            child: Container(
              height: height * 0.031,
              width: width * 0.07,
              child: pageIndex == 0
                  ? Image.asset(
                      "assets/quotes_data/icon_search_ziplink.png",
                      color: AppColors.activeColor,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      "assets/quotes_data/icon_search_ziplink.png",
                      color: AppColors.inactive,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                pageIndex = 1;
              });
            },
            child: Container(
              height: height * 0.03,
              width: width * 0.07,
              child: pageIndex == 1
                  ? Image.asset(
                      "assets/quotes_data/feather_new3x.png",
                      color: AppColors.activeColor,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      "assets/quotes_data/feather_new3x.png",
                      color: AppColors.inactive,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _isLoading = true;
              });
              CHECK_STATUS();
            },
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: AppColors.inactive, width: 2)),
                child: _isLoading
                    ? Lottie.asset(LottieFiles.$71721_loading_icon_for_website,
                        controller: _addController,
                        height: height * width * 0.0002,
                        width: height * width * 0.0002,
                        fit: BoxFit.cover)
                    : Icon(
                        // _statusCheckModel!.data.type == "Writer" ?
                        Icons.add,
                        // : Icons.person,
                        size: height * width * 0.0001,
                        color: AppColors.inactive,
                      )),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                pageIndex = 2;
              });
            },
            child: Container(
              height: height * 0.03,
              width: width * 0.07,
              child: pageIndex == 2
                  ? Image.asset(
                      "assets/quotes_data/icon_home_ziplin.png",
                      color: AppColors.activeColor,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      "assets/quotes_data/icon_home_ziplin.png",
                      color: AppColors.inactive,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                pageIndex = 3;
              });
            },
            child: Container(
              height: height * 0.03,
              width: width * 0.07,
              child: pageIndex == 3
                  ? Image.asset(
                      "assets/quotes_data/icon_menu_ziplin.png",
                      color: AppColors.activeColor,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(
                      "assets/quotes_data/icon_menu_ziplin.png",
                      color: AppColors.inactive,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        ],
      ),
    );
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
        CHECK_STATUSType();
      } else {}
    }
  }

  Future CHECK_STATUSType() async {
    final response =
        await http.get(Uri.parse(ApiUtils.CHECK_PROFILE_STATUS_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('status_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _statusCheckModelType = statusCheckModelFromJson(jsonData);

        if (_statusCheckModel!.data.type == "Writer") {
          _statusCheckModel!.aggrement == false
              ? showTermsAndConditionAlert()
              : _showSimpleDialog();

          setState(() {
            _isLoading = false;
          });
        } else {
          warning();
          Transitioner(
            context: context,
            child: FaqScreen(),
            animation: AnimationType.slideLeft,
            // Optional value
            duration: Duration(milliseconds: 1000),
            // Optional value
            replacement: false,
            // Optional value
            curveType: CurveType.decelerate, // Optional value
          );
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void warning() {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.warning,
      animType: QuickAlertAnimType.slideInUp,
      text: "${Languages.of(context)!.dialogTitle} ${context.read<UserProvider>().UserName} ${Languages.of(context)!.dialogTitleN}",
      confirmBtnColor: Color(0xFF256D85),
      confirmBtnText: Languages.of(context)!.okText
    );

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
                  Transitioner(
                    context: ctx,
                    child: UploadHistoryscreen(
                      route: 1,
                    ),
                    animation: AnimationType.slideLeft, // Optional value
                    duration: Duration(milliseconds: 1000), // Optional value
                    replacement: false, // Optional value
                    curveType: CurveType.decelerate, // Optional value
                  );
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
                        Transitioner(
                          context: ctx,
                          child: UploadHistoryscreen(
                            route: 1,
                          ),
                          animation: AnimationType.slideLeft, // Optional value
                          duration:
                              Duration(milliseconds: 1000), // Optional value
                          replacement: false, // Optional value
                          curveType: CurveType.decelerate, // Optional value
                        );
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
                    replacement: false,
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
                          replacement: false,
                          // Optional value
                          curveType: CurveType.decelerate, // Optional value
                        );
                      },
                      child: Text(Languages.of(context)!.publishNovel),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),
            ],
          );
        });
  }
}
