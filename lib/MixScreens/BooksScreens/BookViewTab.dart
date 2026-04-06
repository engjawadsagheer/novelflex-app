import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:connectivity/connectivity.dart';
import 'package:fade_scroll_app_bar/fade_scroll_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import '../../Models/BoolAllPdfViewModelClass.dart';
import '../../Models/GetAudioBookModel.dart';
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
import '../../localization/Language/languages.dart';
import '../InAppPurchase/paywall.dart';
import '../InAppPurchase/singletons_data.dart';
import '../PdfScreens/pdf_main.dart';
import '../StripePayment/StripePayment.dart';
import '../pdfViewerScreen.dart';

class BookViewTab extends StatefulWidget {
  String bookId;
  String bookName;
  String readerId;
  String PaymentStatus;
  String cover_url;
  BookViewTab(
      {Key? key,
      required this.bookId,
      required this.bookName,
      required this.readerId,
      required this.PaymentStatus,
      required this.cover_url})
      : super(key: key);

  @override
  State<BookViewTab> createState() => _BookViewTabState();
}

class _BookViewTabState extends State<BookViewTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      body: FadeScrollAppBar(
        scrollController: _scrollController,
        elevation: 0.0,
        backgroundColor: Color(0xffebf5f9),
        // elevation: 0.0,
        appBarLeading: Platform.isIOS
            ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black54,
                ))
            : Container(),
        expandedHeight: _height * 0.162,
        appBarShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        fadeWidget: Container(),
        bottomWidgetHeight: 10,
        bottomWidget: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TabBar(
                controller: _tabController,
                indicatorColor: Color(0xff1b4a6b),
                tabs: [
                  Tab(
                    child: Text(
                      'PDF',
                      style: const TextStyle(
                          color: Color(0xff1b4a6b),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Neckar",
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0),
                    ),
                    icon: Icon(
                      Icons.menu_book,
                      color: Color(0xff1b4a6b),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Audio',
                      style: const TextStyle(
                          color: Color(0xff1b4a6b),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Neckar",
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0),
                    ),
                    icon: Icon(
                      Icons.audiotrack_outlined,
                      color: Color(0xff1b4a6b),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Text',
                      style: const TextStyle(
                          color: Color(0xff1b4a6b),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Neckar",
                          fontStyle: FontStyle.normal,
                          fontSize: 15.0),
                    ),
                    icon: Icon(
                      Icons.text_fields_outlined,
                      color: Color(0xff1b4a6b),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: [
            PdfTab(
              image_url: widget.cover_url,
              bookId: widget.bookId,
              bookName: widget.bookName,
              readerId: widget.readerId,
              PaymentStatus: widget.PaymentStatus,
            ),
            AudioTab(
              image_url: widget.cover_url,
              bookId: widget.bookId,
            ),
            TextTab(
              bookId: widget.bookId,
            ),
          ],
        ),
      ),
    );
  }
}

class PdfTab extends StatefulWidget {
  String bookId;
  String bookName;
  String readerId;
  String PaymentStatus;
  String image_url;
  PdfTab(
      {Key? key,
      required this.bookId,
      required this.bookName,
      required this.readerId,
      required this.PaymentStatus,
      required this.image_url})
      : super(key: key);

  @override
  State<PdfTab> createState() => _PdfTabState();
}

class _PdfTabState extends State<PdfTab> {
  BoolAllPdfViewModelClass? _boolAllPdfViewModelClass;

  bool _isLoading = false;

  bool _isInternetConnected = true;

  SubscriptionModelClass? _subscriptionModelClass;

  Offerings? offerings;

  @override
  void initState() {
    _checkInternetConnection();
    BookViewApi();
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Color(0xffebf5f9),
        body: _isInternetConnected
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
                : _boolAllPdfViewModelClass!.data.length == 0
                    ? Center(
                        child: Text(
                          Languages.of(context)!.nodata,
                          style: const TextStyle(
                              fontFamily: Constants.fontfamily,
                              color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(
                          top: _height * 0.02,
                        ),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: _height * 0.1),
                                child: ClipRRect(
                                  child: Container(
                                    width: _width * 0.35,
                                    height: _height * 0.2,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(0)),
                                        color: const Color(0xffebf5f9),
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                widget.image_url))),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(_height * 0.05),
                                child: Center(
                                  child: Text(
                                    "${widget.bookName.toString()} ${Languages.of(context)!.episodes}",
                                    style: const TextStyle(
                                        color: const Color(0xff2a2a2a),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Neckar",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15.0),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount:
                                    _boolAllPdfViewModelClass!.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      switch (_boolAllPdfViewModelClass!
                                          .data[index].pdfStatus) {
                                        case 1:
                                          //All chapters Api for free books
                                          Transitioner(
                                            context: context,
                                            child: PinchPage(
                                              url: _boolAllPdfViewModelClass!
                                                  .data[index].lessonPath,
                                              name: _boolAllPdfViewModelClass!
                                                  .data[index].lesson
                                                  .toString(),
                                            ),
                                            animation: AnimationType
                                                .slideLeft, // Optional value
                                            duration: Duration(
                                                milliseconds:
                                                    1000), // Optional value
                                            replacement:
                                                false, // Optional value
                                            curveType: CurveType
                                                .decelerate, // Optional value
                                          );
                                          break;
                                        case 2:
                                          if (widget.readerId ==
                                              context
                                                  .read<UserProvider>()
                                                  .UserID
                                                  .toString()) {
                                            //paid book but this is the author of this book
                                            Transitioner(
                                              context: context,
                                              child: PinchPage(
                                                url: _boolAllPdfViewModelClass!
                                                    .data[index].lessonPath,
                                                name: _boolAllPdfViewModelClass!
                                                    .data[index].lesson
                                                    .toString(),
                                              ),
                                              animation: AnimationType
                                                  .slideLeft, // Optional value
                                              duration: Duration(
                                                  milliseconds:
                                                      1000), // Optional value
                                              replacement:
                                                  false, // Optional value
                                              curveType: CurveType
                                                  .decelerate, // Optional value
                                            );
                                          } else {
                                            if (_subscriptionModelClass!
                                                    .success ==
                                                true) {
                                              //Reader or Author Already Subscribe
                                              Transitioner(
                                                context: context,
                                                child: PinchPage(
                                                  url:
                                                      _boolAllPdfViewModelClass!
                                                          .data[index]
                                                          .lessonPath,
                                                  name:
                                                      _boolAllPdfViewModelClass!
                                                          .data[index].lesson
                                                          .toString(),
                                                ),
                                                animation: AnimationType
                                                    .slideLeft, // Optional value
                                                duration: Duration(
                                                    milliseconds:
                                                        1000), // Optional value
                                                replacement:
                                                    false, // Optional value
                                                curveType: CurveType
                                                    .decelerate, // Optional value
                                              );
                                            } else {
                                              if (Platform.isIOS) {
                                                SubscribeFunction(
                                                    _boolAllPdfViewModelClass!
                                                        .data[index].lessonPath,
                                                    _boolAllPdfViewModelClass!
                                                        .data[index].lesson
                                                        .toString());
                                              } else {
                                                Transitioner(
                                                  context: context,
                                                  child: StripePayment(
                                                    bookId: widget.bookId,
                                                  ),
                                                  animation: AnimationType
                                                      .slideLeft, // Optional value
                                                  duration: Duration(
                                                      milliseconds:
                                                          1000), // Optional value
                                                  replacement:
                                                      false, // Optional value
                                                  curveType: CurveType
                                                      .decelerate, // Optional value
                                                );
                                              }
                                            }
                                          }
                                          break;
                                        default:
                                          Constants.showToastBlack(context,
                                              "server busy please try again");
                                          break;
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.all(_height * 0.008),
                                      child: Column(
                                        children: [
                                          Opacity(
                                            opacity: 0.20000000298023224,
                                            child: Container(
                                                width: 368,
                                                height: 0.5,
                                                decoration: BoxDecoration(
                                                    color: const Color(
                                                        0xff3a6c83))),
                                          ),
                                          ListTile(
                                            title: _boolAllPdfViewModelClass!
                                                        .data[index].lesson ==
                                                    null
                                                ? Text(
                                                    "${index + 1}. ${widget.bookName}",
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff2a2a2a),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "Alexandria",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16.0),
                                                  )
                                                : Text(
                                                    "${index + 1}. ${_boolAllPdfViewModelClass!.data[index].lesson.toString()}",
                                                    style: const TextStyle(
                                                        color: const Color(
                                                            0xff2a2a2a),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            "Alexandria",
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        fontSize: 16.0),
                                                  ),
                                            subtitle: Text(
                                              DateFormat.yMd('en-IN').format(
                                                  _boolAllPdfViewModelClass!
                                                      .data[index].createdAt),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            trailing: _boolAllPdfViewModelClass!
                                                        .data[index]
                                                        .pdfStatus ==
                                                    1
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .label_important_outlined,
                                                          color: Colors.red),
                                                      Text(
                                                        Languages.of(context)!
                                                            .free1,
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      )
                                                    ],
                                                  )
                                                : _subscriptionModelClass!
                                                            .success ==
                                                        true
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .label_important_outline,
                                                            color: Colors.red,
                                                          ),
                                                          Text(
                                                            Languages.of(
                                                                    context)!
                                                                .premium1,
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          )
                                                        ],
                                                      )
                                                    : Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Icon(
                                                            Icons.lock_outline,
                                                            color: Colors.red,
                                                          ),
                                                          Text(
                                                            Languages.of(
                                                                    context)!
                                                                .premium1,
                                                            style: TextStyle(
                                                                fontSize: 12),
                                                          )
                                                        ],
                                                      ),
                                          ),
                                          Opacity(
                                            opacity: 0.20000000298023224,
                                            child: Container(
                                                width: 368,
                                                height: 0.5,
                                                decoration: BoxDecoration(
                                                    color: const Color(
                                                        0xff3a6c83))),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
            : Center(
                child: Text("No Internet Connection!"),
              ));
    ;
  }

  Future AllChaptersApiCall() async {
    var map = Map<String, dynamic>();
    map['bookId'] = widget.bookId.toString();
    final response = await http.post(Uri.parse(ApiUtils.ALL_CHAPTERS_API),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        },
        body: map);

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        _boolAllPdfViewModelClass = boolAllPdfViewModelClassFromJson(jsonData);
        CHECK_SUBSCRIPTION();
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future BookViewApi() async {
    var map = Map<String, dynamic>();
    map['book_id'] = widget.bookId.toString();
    map['reader_id'] = context.read<UserProvider>().UserID.toString();
    final response = await http.post(Uri.parse(ApiUtils.BOOK_VIEW_API),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        },
        body: map);

    if (response.statusCode == 200) {
      print('recent_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        print("This user already view this book");
      } else {
        print("book_view_by_user");
      }
    }
  }

  Future CHECK_SUBSCRIPTION() async {
    final response = await http
        .get(Uri.parse(ApiUtils.USER_CHECK_SUBSCRIPTION_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    });

    if (response.statusCode == 200) {
      print('subscription_status_response${response.body}');
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 200) {
        _subscriptionModelClass = SubscriptionModelClass.fromJson(jsonData);
        setState(() {
          _isLoading = false;
        });
      } else {
        ToastConstant.showToast(context, jsonData['message'].toString());
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
      AllChaptersApiCall();
      BookViewApi();
    }
  }

  Future<void> initPlatformState() async {
    // Enable debug logs before calling `configure`.
    // await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration configuration;
    if (StoreConfig.isForAmazonAppstore()) {
      configuration = AmazonConfiguration(StoreConfig.instance.apiKey!)
        ..appUserID = null
        ..observerMode = false;
    } else {
      configuration = PurchasesConfiguration(StoreConfig.instance.apiKey!)
        ..appUserID = null
        ..observerMode = false;
    }
    await Purchases.configure(configuration);

    appData.appUserID = await Purchases.appUserID;

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      appData.appUserID = await Purchases.appUserID;

      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      (customerInfo.entitlements.all[entitlementID] != null &&
              customerInfo.entitlements.all[entitlementID]!.isActive)
          ? appData.entitlementIsActive = true
          : appData.entitlementIsActive = false;
      // print("Ios subscribtion status ${ customerInfo.entitlements.all[entitlementID]!.isActive}");
      // setState(() {});
    });
  }

  void SubscribeFunction(var lessonPath, var lessonName) async {
    setState(() {
      _isLoading = true;
    });

    // CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    // //check purchase done or not
    // // if("user_already_paid_and_offer_time is not end"==true){
    // //   //Call pdf Api
    // //   print("purchase_already_done");
    // // }
    //
    // if (customerInfo.entitlements.all[entitlementID] != null &&
    //     customerInfo.entitlements.all[entitlementID]!.isActive == true) {
    //   // appData.currentData = WeatherData.generateData();
    //   //check purchase done or not
    //   //Call pdf Api
    //   print("purchase_already_done");
    //
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
    if (_subscriptionModelClass!.success == true) {
      //call book pdf api

      Transitioner(
        context: context,
        child: PinchPage(
          url: lessonPath,
          name: lessonName,
        ),
        animation: AnimationType
            .slideLeft, // Optional value
        duration: Duration(
            milliseconds:
            1000), // Optional value
        replacement:
        false, // Optional value
        curveType: CurveType
            .decelerate, // Optional value
      );
    } else {
      try {
        offerings = await Purchases.getOfferings();
        print("offers_revenue cat ${offerings?.all.toString()}");
      } on PlatformException catch (e) {
        await showDialog(
            context: context,
            builder: (BuildContext context) => ShowDialogToDismiss(
                title: "Error Try Again",
                content: e.message.toString(),
                buttonText: 'OK'));
      }

      setState(() {
        _isLoading = false;
      });

      if (offerings!.current == null) {
        // offerings are empty, show a message to your user
        Constants.showToastBlack(context, "Nothing to Pay");
      } else {
        // current offering is available, show paywall
        await showModalBottomSheet(
          useRootNavigator: true,
          isDismissible: true,
          isScrollControlled: true,
          backgroundColor: Colors.black,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
              return Paywall(
                offering: offerings!.current!,
              );
            });
          },
        );
      }
    }
  }
}

class AudioTab extends StatefulWidget {
  String image_url;
  String bookId;
  AudioTab({Key? key, required this.image_url, required this.bookId})
      : super(key: key);

  @override
  State<AudioTab> createState() => _AudioTabState();
}

class _AudioTabState extends State<AudioTab> with WidgetsBindingObserver {
  final _player = AudioPlayer();
  bool loading = true;
  bool _isInternetConnected = true;
  GetAudioBookModel? _getAudioBookModel;
  String? text = "";

  @override
  void initState() {
    super.initState();
    _checkInternetConnection();
    ambiguate(WidgetsBinding.instance)!.addObserver(this);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
  }

  Future<void> _init(var url) async {
    // https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    try {
      await _player.setAudioSource(AudioSource.uri(Uri.parse(url)));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  @override
  void dispose() {
    ambiguate(WidgetsBinding.instance)!.removeObserver(this);
    _player.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _player.stop();
    }
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      body: SafeArea(
        child: _isInternetConnected
            ? loading
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
                : text!.isEmpty
                    ? Center(
                        child: Text(
                          Languages.of(context)!.nodata,
                          style: const TextStyle(
                              color: const Color(0xff3a6c83),
                              fontWeight: FontWeight.w700,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            child: Container(
                              width: _width * 0.35,
                              height: _height * 0.2,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: const Color(0xffebf5f9),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(widget.image_url))),
                            ),
                          ),
                          // Display seek bar. Using StreamBuilder, this widget rebuilds
                          // each time the position, buffered position or duration changes.
                          StreamBuilder<PositionData>(
                            stream: _positionDataStream,
                            builder: (context, snapshot) {
                              final positionData = snapshot.data;
                              return SeekBar(
                                duration:
                                    positionData?.duration ?? Duration.zero,
                                position:
                                    positionData?.position ?? Duration.zero,
                                bufferedPosition:
                                    positionData?.bufferedPosition ??
                                        Duration.zero,
                                onChangeEnd: _player.seek,
                              );
                            },
                          ),
                          // Display play/pause button and volume/speed sliders.
                          loading
                              ? Center(
                                  child: CupertinoActivityIndicator(),
                                )
                              : ControlButtons(_player),
                        ],
                      )
            : Center(
                child: Text("No Internet Connection!"),
              ),
      ),
    );
  }

  Future AUDIO_LINK() async {
    var map = Map<String, dynamic>();
    map['bookId'] = widget.bookId.toString();
    final response = await http.post(Uri.parse(ApiUtils.GET_AUDIO_BOOK),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        },
        body: map);

    if (response.statusCode == 200) {
      print('AudioLink${response.body}');
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 200) {
        _getAudioBookModel = GetAudioBookModel.fromJson(jsonData);
        print(
          "Audio_link ${_getAudioBookModel!.data.audio.toString()}",
        );
        _init(_getAudioBookModel!.data.audio.toString());
        setState(() {
          text = "NoNull";
          loading = false;
        });
      } else if (jsonData['status'] == 401) {
        setState(() {
          text = "";
          loading = false;
        });
      } else {
        ToastConstant.showToast(context, "Audio does not Exits for this book");
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future _checkInternetConnection() async {
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
        AUDIO_LINK();
      }
    }
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Opens volume slider dialog
        IconButton(
          icon: Icon(
            Icons.volume_up,
            color: Color(0xff1b4a6b),
            size: _height * _width * 0.00012,
          ),
          onPressed: () {
            showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              value: player.volume,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),

        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: const CupertinoActivityIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: _height * _width * 0.00015,
                color: Color(0xff1b4a6b),
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: _height * _width * 0.00015,
                onPressed: player.pause,
                color: Color(0xff1b4a6b),
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: _height * _width * 0.00015,
                color: Color(0xff1b4a6b),
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
        // Opens speed slider dialog
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff1b4a6b),
                    fontSize: 15)),
            onPressed: () {
              showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                value: player.speed,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class TextTab extends StatefulWidget {
  final bookId;
  TextTab({Key? key, required this.bookId}) : super(key: key);

  @override
  State<TextTab> createState() => _TextTabState();
}

class _TextTabState extends State<TextTab> {
  bool loading = true;
  bool _isInternetConnected = true;
  String? text = "notNull";

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
      backgroundColor: Color(0xffebf5f9),
      body: loading
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
          : text!.isEmpty
              ? Center(
                  child: Text(
                    Languages.of(context)!.nodata,
                    style: const TextStyle(
                        color: const Color(0xff3a6c83),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Lato",
                        fontStyle: FontStyle.normal,
                        fontSize: 12.0),
                  ),
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.all(_height * 0.01),
                    child: ListView(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      children: [
                        Text(
                          text
                              .toString()
                              .replaceAll("</p>", "")
                              .replaceAll("<p>", ""),
                          style: const TextStyle(
                            // color: const Color(0xff002333),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                            fontFamily: "Lato",
                            height: 2,
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ),
    );
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
          if (jsonData['data'].toString() == "[]") {
            text = "";
          } else {
            text = jsonData['data'][0];
          }

          loading = false;
        });
      } else {
        ToastConstant.showToast(context, jsonData['message'].toString());
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future _checkInternetConnection() async {
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
}
