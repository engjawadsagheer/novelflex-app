import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:novelflex/MixScreens/BooksScreens/AuthorViewByUserScreen.dart';
import 'package:novelflex/TabScreens/home_screen.dart';
import 'package:novelflex/UserAuthScreen/SignUpScreens/SignUpScreen_Second.dart';
import 'package:novelflex/localization/Language/languages.dart';
import 'package:novelflex/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transitioner/transitioner.dart';
import 'MixScreens/BooksScreens/BookViewTab.dart';
import 'MixScreens/PdfScreens/pdf_main.dart';
import 'Provider/UserProvider.dart';
import 'Provider/VariableProvider.dart';
import 'UserAuthScreen/login_screen.dart';
import 'Utils/constant.dart';
import 'Utils/store_config.dart';
import 'firebase_options.dart';
import 'localization/locale_constants.dart';
import 'localization/localizations_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io' show Platform;
BuildContext? context1;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

// class MyHttpOverrides extends HttpOverrides{
//   @override
//   HttpClient createHttpClient(SecurityContext? context){
//     return super.createHttpClient(context)
//       ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
//   }
// }


Future<void> main() async {

  // HttpOverrides.global = new MyHttpOverrides();

  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {}
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appleStore,
      apiKey: appleApiKey,
    );
  } else if (Platform.isAndroid) {

    StoreConfig(
      store:  Store.googlePlay,
      apiKey:googleApiKey,
    );
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();



  runApp(Phoenix(child: MyApp(sharedPreferences: prefs)));


}





const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title// description
  importance: Importance.high,
);



class MyApp extends StatefulWidget {
  late SharedPreferences sharedPreferences;

  MyApp({super.key, required this.sharedPreferences});

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    var state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }
}


class _MyAppState extends State<MyApp>  {

  String? token;

  @override
  void initState() {
    super.initState();

    var initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/ic_launcher');
    const iosInitializationSetting = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid,iOS:iosInitializationSetting);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                color: Colors.blue,
                icon: "@drawable/icon_notify",
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        showDialog(
            builder: (_) {
              return AlertDialog(
                title: Text(notification.title!),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [Text(notification.body!)],
                  ),
                ),
              );
            }, context: context);
      }
    });


    setFCMToken();

  }



  setFCMToken() async {
    SharedPreferences prefts = await SharedPreferences.getInstance();
    token = Platform.isIOS ? await FirebaseMessaging.instance.getAPNSToken() : await FirebaseMessaging.instance.getToken();
    // token =  await FirebaseMessaging.instance.getToken();

    prefts.setString('fcm_token', token.toString());
    // String? tokenIOS = await FirebaseMessaging.instance.getAPNSToken();
    print(" token__ $token");
  }


  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() async {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<InternetConnectionStatus>(
      initialData: InternetConnectionStatus.connected,
      create: (_) {
        return InternetConnectionCheckerPlus().onStatusChange;
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
              create: (context) => UserProvider(widget.sharedPreferences)),
          ChangeNotifierProvider<VariableProvider>(
              create: (context) => VariableProvider()),
        ],
        child: FirebasePhoneAuthProvider(
          child: MaterialApp(
            locale: _locale,
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode &&
                    supportedLocale.countryCode == locale?.countryCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            debugShowCheckedModeBanner: false,
            home: SplashFirst(),
            routes: {
              'tab_screen': (context) => TabScreen(),
              'login_screen': (context) => LoginScreen(),
            },
          ),
        ),
      ),
    );
  }


}


class SplashFirst extends StatefulWidget  {
  const SplashFirst({Key? key}) : super(key: key);

  @override
  State<SplashFirst> createState() => _SplashFirstState();
}

class _SplashFirstState extends State<SplashFirst> with WidgetsBindingObserver {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  @override
  void initState() {
    super.initState();
    sentStatus(1);
    WidgetsBinding.instance.addObserver(this);
    retrieveDynamicLink(context);
    expireToken();
    Timer(const Duration(microseconds: 0), () {
      if (context.read<UserProvider>().UserToken == '' ||
          context.read<UserProvider>().UserToken == null
          || expireToken() >=13) {
        Transitioner(
          context: context,
          child: SplashPage(),
          animation: AnimationType.fadeIn, // Optional value
          duration: Duration(milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
      } else {
        Transitioner(
          context: context,
          child: TabScreen(),
          animation: AnimationType.fadeIn, // Optional value
          duration: Duration(milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
      }
    });

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed){
      sentStatus(1);
    }
    else{
      sentStatus(0);
    }
  }

  sentStatus(int value) async {
    _firestore
        .collection("user")
        .doc(context.read<UserProvider>().UserID)
        .set({
      "user_id": context.read<UserProvider>().UserID,
      "status": value,
    });
  }

  int expireToken(){
    final currentTime = DateTime.now();
    final savedTime =context.read<UserProvider>().GetSavedTime==null ? DateTime.now() : DateTime.fromMillisecondsSinceEpoch(context.read<UserProvider>().GetSavedTime!);
    final diff_day = currentTime.difference(savedTime).inDays;
    print("days differences for expiry token $diff_day");

    return diff_day;
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: const Color(0xffebf5f9),
        body: const Center(
          child: CupertinoActivityIndicator(
            color:  Color(0xff1b4a6b)
          )
        )
    );
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    UserProvider userProvider =
    Provider.of<UserProvider>(this.context, listen: false);
    try {

      await Future.delayed(Duration(seconds: 3));
      final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;

      if (deepLink != null) {
        if (deepLink.queryParameters.containsKey('referral_code')) {
          String? referral_code = deepLink.queryParameters['referral_code'];
          String? user_Id = deepLink.queryParameters['user_Id'];
          // Constants.showToastBlack(context, deepLink.queryParameters['referral_code']!);
          // context.watch<UserProvider>().setReferral(referral_code.toString());
          if(referral_code!.isNotEmpty)
           {
          userProvider.setReferral(referral_code.toString());
          print("Referal_user_code${userProvider.GetReferral.toString()}");
          Transitioner(
            context: context,
            child: SignUpScreen_Second(ReferralUserID:deepLink.queryParameters['referral_code'],),
            animation: AnimationType.slideLeft, // Optional value
            duration: Duration(milliseconds: 1000), // Optional value
            replacement: true, // Optional value
            curveType: CurveType.decelerate, // Optional value
          );
          print("referral_code = $referral_code");
        }else{
            Transitioner(
              context: context,
              child: AuthorViewByUserScreen(user_id: user_Id!,),
              animation: AnimationType.slideLeft, // Optional value
              duration: Duration(milliseconds: 1000), // Optional value
              replacement: true, // Optional value
              curveType: CurveType.decelerate, // Optional value
            );

          }
          }
      }

      FirebaseDynamicLinks.instance.onLink.listen(
            (pendingDynamicLinkData) {
              if (deepLink != null) {
                if (deepLink.queryParameters.containsKey('referral_code')) {
                  String? referral_code = deepLink.queryParameters['referral_code'];
                  String? user_Id = deepLink.queryParameters['user_Id'];
                  // Constants.showToastBlack(context, deepLink.queryParameters['referral_code']!);
                  // context.watch<UserProvider>().setReferral(referral_code.toString());
                  if(user_Id!.isNotEmpty){
                    Transitioner(
                      context: context,
                      child: AuthorViewByUserScreen(user_id: deepLink.queryParameters['user_Id'].toString(),

                      ),
                      animation: AnimationType.slideLeft, // Optional value
                      duration: Duration(milliseconds: 1000), // Optional value
                      replacement: true, // Optional value
                      curveType: CurveType.decelerate, // Optional value
                    );
                  }
                  userProvider.setReferral(referral_code.toString());
                  print("Referal_user_code${userProvider.GetReferral.toString()}");
                  Transitioner(
                    context: context,
                    child: SignUpScreen_Second(ReferralUserID:deepLink.queryParameters['referral_code'],),
                    animation: AnimationType.slideLeft, // Optional value
                    duration: Duration(milliseconds: 1000), // Optional value
                    replacement: true, // Optional value
                    curveType: CurveType.decelerate, // Optional value
                  );
                  print("referral_code = $referral_code");
                }
              }
        },
      );

    } catch (e) {
      print(e.toString());
    }
  }

}


class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isLoading= true;

  @override
  void initState() {

    Timer(const Duration(seconds: 1), () {
    setState(() {
      _isLoading=false;
    });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().setLanguage('English');
      changeLanguage(context, 'en');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Image.asset('assets/quotes_data/bg_login.png',fit: BoxFit.fill,),
            ),
          ),
          Positioned(
            top: _height * 0.15,
            // left: _width*0.5,
            child: Container(
                height: _height*0.2,
                width: _width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/quotes_data/NoPath_3x-removebg-preview.png',),
                    fit: BoxFit.cover
                  )
                ),

          ),),
          Positioned(
            top: _height * 0.4,
            left: _width * 0.2,
            child: Container(
                width: 256,
                height: 2,
                decoration: BoxDecoration(color: const Color(0xff333333))),
          ),
          Positioned(
            top: _height * 0.45,
            left:context.read<UserProvider>().SelectedLanguage=='English' ? _width*0.1 : 0.0,
            right:context.read<UserProvider>().SelectedLanguage=='Arabic' ? _width*0.05 : 0.0,


            child: Text(Languages.of(context)!.labelWelcome,
                style: const TextStyle(
                    color: const Color(0xff101010),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Lato",
                    fontStyle: FontStyle.normal,
                    fontSize: 20.0),
                textAlign: TextAlign.center),
          ),
          Positioned(
              top: _height * 0.7,
              left: _width * 0.1,
              child: GestureDetector(
                onTap: (){
                  Transitioner(
                    context: context,
                    child: LoginScreen(),
                    animation: AnimationType.slideLeft, // Optional value
                    duration: Duration(milliseconds: 1000), // Optional value
                    replacement: true, // Optional value
                    curveType: CurveType.decelerate, // Optional value
                  );
                  },
                child: Container(
                  width: _width*0.83,
                  height: _height*0.06,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x24000000),
                            offset: Offset(0, 7),
                            blurRadius: 14,
                            spreadRadius: 0)
                      ],
                      color: const Color(0xff3a6c83)),
                  child: Center(
                    child: Text(
                      Languages.of(context)!.login,
                      style: const TextStyle(
                          color:  const Color(0xffffffff),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Lato",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                    ),
                  ),
                ),
              )),
          Positioned(
            top: _height * 0.79,
            left: _width * 0.1,
            child: GestureDetector(
              onTap: (){
                 Transitioner(
                  context: context,
                  child: SignUpScreen_Second(ReferralUserID: "",),
                  animation: AnimationType.slideLeft, // Optional value
                  duration: Duration(milliseconds: 1000), // Optional value
                  replacement: true, // Optional value
                  curveType: CurveType.decelerate, // Optional value
                );
              },
              child: Container(
                width: _width*0.83,
                height: _height*0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xff3a6c83),
                      width: 2,
                    )),
                child: Center(
                  child: Text(
                    Languages.of(context)!.signup,
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
          ),
          Positioned(
            top: _height*0.05,
            left:context.read<UserProvider>().SelectedLanguage=='English' ? _width*0.8 : _width*0.02,
            child: GestureDetector(
              child: Column(
                children: [
                  Text(context.read<UserProvider>().SelectedLanguage=='English' ? "🇦🇪" : "🇺🇸", style: TextStyle(
                      fontSize: _width*_height*0.0001
                  ),),
                  Text(context.read<UserProvider>().SelectedLanguage=='English' ? "العربية": "English ", style: const TextStyle(
                      color:   Colors.black,
                      fontWeight: FontWeight.w700,
                      fontFamily: "Lato",
                      fontStyle:  FontStyle.normal,
                      fontSize: 14.0
                  ),),

                ],
              ),
              onTap: () {
                UserProvider userProviderlng =
                Provider.of<UserProvider>(this.context, listen: false);
                if(userProviderlng.SelectedLanguage == 'English'){
                  userProviderlng.setLanguage('Arabic');
                  changeLanguage(context, 'ar');
                }else{
                  userProviderlng.setLanguage('English');
                  changeLanguage(context, 'en');
                }

              },
            ),
          ),
          Positioned(
            top: _height * 0.88,
            left: _width * 0.1,
            child: GestureDetector(
              onTap: (){
                Transitioner(
                  context: context,
                  child:HomeScreen(
                    route: "guest",
                  ),
                  animation: AnimationType.slideLeft, // Optional value
                  duration: Duration(milliseconds: 1000), // Optional value
                  replacement: false, // Optional value
                  curveType: CurveType.decelerate, // Optional value
                );
              },
              child: Container(
                width: _width*0.83,
                height: _height*0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xff3a6c83),
                      width: 2,
                    )),
                child: Center(
                  child: Text(
                    Languages.of(context)!.guest,
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
          ),
          _isLoading? Positioned(
            top: _height*0.6,
              left: _width*0.4,
              right:_width*0.4,
              child: CupertinoActivityIndicator(
                color:  Color(0xff1b4a6b),
              )) : Container()
        ],
      ),
    );
  }


}

