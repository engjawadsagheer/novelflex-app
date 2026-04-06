import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:novelflex/UserAuthScreen/SignUpScreens/signUpScreen_First.dart';
import 'package:novelflex/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:sign_in_apple/apple_id_user.dart';
// import 'package:sign_in_apple/sign_in_apple.dart';
import 'package:transitioner/transitioner.dart';
import '../Models/CheckStatusModel.dart';
import '../Models/UserModel.dart';
import '../Provider/UserProvider.dart';
import '../Utils/ApiUtils.dart';
import '../Utils/Constants.dart';
import '../Utils/toast.dart';
import '../Widgets/reusable_button.dart';
import '../Widgets/reusable_button_small.dart';
import '../localization/Language/languages.dart';
import 'FogetPassword/ForgetPasswordScreen.dart';
import 'FogetPassword/forgetPasswordEmailScreen.dart';
import 'SignUpScreens/SignUpScreen_Second.dart';
import 'SignUpScreens/signUpScreen_Third.dart';
import 'dart:io';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignInAccount? _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  Map _userFBObject = {};
  AuthorizationCredentialAppleID? credential;
  Map<String, dynamic>? _userData;
  AccessToken? _accessToken;

  static const String id = 'login_screen';

  final _emailFocusNode = new FocusNode();
  final _passwordFocusNode = new FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _passwordKey = GlobalKey<FormFieldState>();
  final _emailKey = GlobalKey<FormFieldState>();

  TextEditingController? _controllerEmail;
  TextEditingController? _controllerPassword;

  bool _autoValidate = false;

  bool _isLoading = false;

  UserModel? _userModel;
  CheckStatusModel? _checkStatusModel;

  String _errorMsg = "";

  String social_login_ID = "0";

  String _name = 'Unknown';
  String _mail = 'Unknown';
  String _userIdentify = 'Unknown';
  String _authorizationCode = 'Unknown';
  bool show = true;
  String? fcmToken;
  Dio dio = Dio();

  @override
  void initState()  {
    super.initState();
    // initPlatformState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
    getToken();
  }

  @override
  void dispose() {
    _controllerEmail!.dispose();
    _controllerPassword!.dispose();
    super.dispose();
  }

  void handleLoginUser() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _checkInternetConnection();
    } else {
      setState(() {
        _autoValidate = true;
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
      _errorMsg = "No internet connection.";
    } else {
      _callLoginAPI();
    }
  }

  _navigateAndRemove() {
    Transitioner(
      context: context,
      child: TabScreen(),
      animation: AnimationType.slideLeft, // Optional value
      duration: Duration(milliseconds: 1000), // Optional value
      replacement: true, // Optional value
      curveType: CurveType.decelerate, // Optional value
    );
  }

  getToken() async {
    SharedPreferences prefts = await SharedPreferences.getInstance();
    fcmToken = prefts.getString('fcm_token');
    print("firebase_token_preferences_login ${fcmToken}");
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    UserProvider userProvider =
    Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: height * 0.02,
                    ),
                    mainText2(width),
                    SizedBox(
                      height: height * 0.01,
                    ),
                    SizedBox(
                      height: height * 0.2,
                      width: width * 0.4,
                      child: Image.asset('assets/quotes_data/NoPath_3x-removebg-preview.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.02, horizontal: width * 0.04),
                      child: TextFormField(
                        key: _emailKey,
                        controller: _controllerEmail,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        validator: validateEmail,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        decoration: InputDecoration(
                            errorMaxLines: 3,
                            counterText: "",
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.white12,
                              ),
                            ),
                            disabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF256D85),
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF256D85),
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.red,
                                )),
                            focusedErrorBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Colors.red,
                              ),
                            ),
                            hintText: Languages.of(context)!.email,
                            // labelText: Languages.of(context)!.email,
                            hintStyle: const TextStyle(
                              fontFamily: Constants.fontfamily,
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.02, horizontal: width * 0.04),
                      child: Stack(
                        children: [
                          Positioned(
                            child: TextFormField(
                              key: _passwordKey,
                              controller: _controllerPassword,
                              focusNode: _passwordFocusNode,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              cursorColor: Colors.black,
                              validator: validatePassword,
                              obscureText: show,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocusNode);
                              },
                              decoration: InputDecoration(
                                errorMaxLines: 3,
                                counterText: "",
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black12,
                                  ),
                                ),
                                disabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.black12,
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xFF256D85),
                                  ),
                                ),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.red,
                                    )),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Colors.red,
                                  ),
                                ),
                                hintText: Languages.of(context)!.password,
                                hintStyle: const TextStyle(
                                  fontFamily: Constants.fontfamily,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                              top: height * 0.01,
                              left: context
                                          .read<UserProvider>()
                                          .SelectedLanguage ==
                                      'English'
                                  ? width * 0.8
                                  : 0.0,
                              right: context
                                          .read<UserProvider>()
                                          .SelectedLanguage ==
                                      'Arabic'
                                  ? width * 0.8
                                  : 0.0,
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      show = !show;
                                    });
                                  },
                                  icon: show
                                      ? Icon(
                                          Icons.remove_red_eye_outlined,
                                          color: Colors.black38,
                                        )
                                      : Icon(
                                          Icons.remove_red_eye,
                                          color: const Color(0xff3a6c83),
                                        )))
                        ],
                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          Transitioner(
                            context: context,
                            // child: ForgetPasswordScreen(),
                            child: ForgetPasswordEmailScreen(),
                            animation:
                                AnimationType.slideLeft, // Optional value
                            duration:
                                Duration(milliseconds: 1000), // Optional value
                            replacement: false, // Optional value
                            curveType: CurveType.bounce, // Optional value
                          );
                        },
                        child: forgetPassword(height)),
                    Container(

                      margin: EdgeInsets.only(top: height * 0.03),
                      child: ResuableMaterialButtonSmall(
                        onpress: () {
                          handleLoginUser();
                        },
                        buttonname: Languages.of(context)!.login,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: width * 0.2,
                              height: 1,
                              decoration: BoxDecoration(
                                  color: const Color(0xff3a6c83))),
                          Text(Languages.of(context)!.continueWith,
                              style: const TextStyle(
                                  color: const Color(0xff002333),
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Lato",
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12.0),
                              textAlign: TextAlign.center),
                          Container(
                              width: width * 0.2,
                              height: 1,
                              decoration:
                                  BoxDecoration(color: const Color(0xff3a6c83)))
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: height * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _googleSignIn.signIn().then((userData) {
                                setState(() {
                                  _userObj = userData;
                                  social_login_ID = "1";
                                });
                                CHECK_STATUS_API("1", userData!.email);
                              }).catchError((e) {
                                print(e);
                              });
                            },
                            child: SvgPicture.asset(
                                "assets/quotes_data/google_login.svg", //asset location

                                fit: BoxFit.scaleDown),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          GestureDetector(
                            onTap: () async {
                              FacebookAuth.instance.login(permissions: [
                                "public_profile",
                                "email"
                              ]).then((value) {
                                FacebookAuth.instance
                                    .getUserData()
                                    .then((userData) {
                                  setState(() {
                                    social_login_ID = "2";
                                    _userFBObject = userData;
                                  });
                                  CHECK_STATUS_API("2", _userFBObject["email"]);
                                });
                              });
                            },
                            child: SvgPicture.asset(
                                "assets/quotes_data/facebook_login.svg", //asset location

                                fit: BoxFit.scaleDown),
                          ),
                          SizedBox(
                            width: width * 0.02,
                          ),
                          GestureDetector(
                            onTap: () async {
                               if(Platform.isIOS){
                                 if (await SignInWithApple.isAvailable()) {
                                   credential = await SignInWithApple.getAppleIDCredential(
                                     scopes: [
                                       AppleIDAuthorizationScopes.email,
                                       AppleIDAuthorizationScopes.fullName,
                                     ],
                                     // webAuthenticationOptions: WebAuthenticationOptions(
                                     //   redirectUri: Uri.parse('https://api.dreamwod.app/auth/callbacks/apple-sign-in'),
                                     //   clientId: 'com.dreamwod.app.login',
                                     // ),
                                   );

                                   if(userProvider.GetApple==""||userProvider.GetApple==null){
                                     userProvider.setApple(credential!.email.toString());
                                   }
                                   print("Apple_email ${credential!.email}");
                                   print("Apple_userName ${credential!.givenName}");
                                   print("Provider_email ${userProvider.GetApple}");
                                   setState(() {
                                     social_login_ID = "3";

                                   });

                                   CHECK_STATUS_API("3", userProvider.GetApple=="" ? credential!.email.toString() : context.read<UserProvider>().GetApple.toString());

                                 } else {
                                   print('Apple SignIn is not available for your device');
                                   ToastConstant.showToast(context, "Apple SignIn is not available for your device");
                                 }

                               }else{
                                 // ToastConstant.showToast(context, "Login Successfully");
                               }






                              // SignInApple.clickAppleSignIn();
                            },
                            child: SvgPicture.asset(
                                "assets/quotes_data/apple_login.svg", //asset location
                                fit: BoxFit.scaleDown),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Visibility(
                  visible: _isLoading == true,
                  child: const Center(
                    child: CupertinoActivityIndicator(
                      color:  Color(0xff1b4a6b),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Transitioner(
                      context: context,
                      child: SignUpScreen_Second(
                        ReferralUserID: "",
                      ),
                      animation: AnimationType.slideLeft, // Optional value
                      duration: Duration(milliseconds: 1000), // Optional value
                      replacement: true, // Optional value
                      curveType: CurveType.decelerate, // Optional value
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: height * 0.02,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        Languages.of(context)!.donthaveanaccountSignUp,
                        style: const TextStyle(
                            color: const Color(0xff3a6c83),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Lato",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget mainText(var width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Languages.of(context)!.welcomenovelflex,
          style: TextStyle(
            color: Colors.black87,
            fontSize: width * 0.05,
            fontWeight: FontWeight.w800,
            fontFamily: Constants.fontfamily,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget mainSmallText(double height) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.02),
      child: Text(
        Languages.of(context)!.socailtext,
        style: TextStyle(
          color: Colors.black26,
          fontSize: height * 0.02,
          fontFamily: Constants.fontfamily,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget mainText2(var width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Languages.of(context)!.login,
          style: const TextStyle(
              color: const Color(0xff002333),
              fontWeight: FontWeight.w700,
              fontFamily: "Lato",
              fontStyle: FontStyle.normal,
              fontSize: 14.0),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget forgetPassword(double height) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: height * 0.01,
                  right: height * 0.04,
                  left: height * 0.04),
              child: Text(
                Languages.of(context)!.forgetPassword,
                style: const TextStyle(
                    color: const Color(0xff002333),
                    fontWeight: FontWeight.w400,
                    fontFamily: "Lato",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: height * 0.04, left: height * 0.04),
              child: SizedBox(
                width: width * 0.24,
                child: const Divider(
                  color: Colors.black,
                  thickness: 1.0,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return 'Please Enter Email';
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    // RegExp regex = new RegExp(pattern);
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else
      return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) return 'Please enter password';

    if (value.length < 6) {
      return 'Password should be more than 6 characters';
    } else
      return null;
  }

  Future _callLoginAPI() async {
    setState(() {
      _isLoading = true;
    });
    var map = Map<String, dynamic>();
    map['email'] = _controllerEmail!.text.trim();
    map['password'] = _controllerPassword!.text.trim();
    map['firebase_token'] = fcmToken!.isEmpty ? "xyzdatachc": fcmToken!.trim().toString();

    final response = await http.post(
      Uri.parse(ApiUtils.URL_LOGIN_USER_API),
      body: map,
    );

    var jsonData;

    if (response.statusCode == 200) {
      //Success

      jsonData = json.decode(response.body);
      print('login_user_success_data_shown: $jsonData');
      if (jsonData['status'] == 200) {
        _userModel = UserModel.fromJson(jsonData);
        saveToPreferencesUserDetail(_userModel);
        _navigateAndRemove();

        ToastConstant.showToast(context, "Login Successfully");
        setState(() {
          _isLoading = false;
        });
      } else {
        ToastConstant.showToast(context, "Invalid Credential!");
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

  Future CHECK_STATUS_API(String id, String email) async {
    setState(() {
      _isLoading = true;
    });
    var map = Map<String, dynamic>();
    map['email'] = email;
    map['google_id'] = id;

    final response = await http.post(
      Uri.parse(ApiUtils.CHECK_STATUS_API),
      body: map,
    );

    var jsonData;

    if (response.statusCode == 200) {
      //Success

      jsonData = json.decode(response.body);

      if (jsonData['status'] == 200) {
        print('check_status_api_response: $jsonData');
        _checkStatusModel = CheckStatusModel.fromJson(jsonData);
        setState(() {
          _isLoading = false;
        });
        if (_checkStatusModel!.data == "false") {
          print("false executed");
          if (social_login_ID == "1") {
            Transitioner(
              context: context,
              child: SingUpScreen_Third(
                name: _userObj!.displayName!,
                email: _userObj!.email,
                password: "",
                phone: social_login_ID.toString(),
                route: "login",
                photoUrl: _userObj!.photoUrl.toString(),
              ),
              animation: AnimationType.slideLeft, // Optional value
              duration: Duration(milliseconds: 1000), // Optional value
              replacement: true, // Optional value
              curveType: CurveType.decelerate, // Optional value
            );
          } else if (social_login_ID == "2") {
            Transitioner(
              context: context,
              child: SingUpScreen_Third(
                name: _userFBObject["name"],
                email: _userFBObject["email"],
                password: "",
                phone: social_login_ID.toString(),
                route: "login",
                photoUrl: _userFBObject["picture"]["data"]["url"],
              ),
              animation: AnimationType.slideLeft, // Optional value
              duration: Duration(milliseconds: 1000), // Optional value
              replacement: true, // Optional value
              curveType: CurveType.decelerate, // Optional value
            );
          } else if (social_login_ID == "3") {
            Transitioner(
              context: context,
              child: SingUpScreen_Third(
                name:  credential!.givenName.toString().trim(),
                email:  credential!.email.toString().trim(),
                password: "",
                phone: social_login_ID.toString(),
                route: "login",
                photoUrl: "",
              ),
              animation: AnimationType.slideLeft, // Optional value
              duration: Duration(milliseconds: 1000), // Optional value
              replacement: true, // Optional value
              curveType: CurveType.decelerate, // Optional value
            );
          } else {
            ToastConstant.showToast(context, "Error!");
          }
        } else {
          print("true executed");
          if (social_login_ID == "1") {
            SOCIAL_LOGIN_GOOGLE_API();
          } else if (social_login_ID == "2") {
            SOCIAL_LOGIN_FACEBOOK_API();
          } else if (social_login_ID == "3") {
            SOCIAL_LOGIN_APPLE_API();
          }
        }
      } else {
        ToastConstant.showToast(context, "Error!");
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

  Future SOCIAL_LOGIN_GOOGLE_API() async {
    print("google token $fcmToken");
    var map = Map<String, dynamic>();
    map['email'] = _userObj!.email.toString();
    map['firebase_token'] = fcmToken!.trim();

    final response = await http.post(
      Uri.parse(ApiUtils.USER_SOCIAL_LOGIN),
      body: map,
    );

    var jsonData;

    if (response.statusCode == 200) {
      //Success

      jsonData = json.decode(response.body);
      print('social_login_response: $jsonData');
      if (jsonData['status'] == 200) {
        jsonData = json.decode(response.body);
        print('loginSuccess_data: $jsonData');
        if (jsonData['status'] == 200) {
          _userModel = UserModel.fromJson(jsonData);
          saveToPreferencesUserDetail(_userModel);
          _navigateAndRemove();

          ToastConstant.showToast(context, "Login Successfully");
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ToastConstant.showToast(context, "Error!");
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

  Future SOCIAL_LOGIN_FACEBOOK_API() async {
    var map = Map<String, dynamic>();
    map['email'] = _userFBObject["email"].toString();
    map['firebase_token'] = fcmToken!.trim();

    final response = await http.post(
      Uri.parse(ApiUtils.USER_SOCIAL_LOGIN),
      body: map,
    );

    var jsonData;

    if (response.statusCode == 200) {
      //Success

      jsonData = json.decode(response.body);
      print('social_login_response: $jsonData');
      if (jsonData['status'] == 200) {
        jsonData = json.decode(response.body);
        print('loginSuccess_data: $jsonData');
        if (jsonData['status'] == 200) {
          _userModel = UserModel.fromJson(jsonData);
          saveToPreferencesUserDetail(_userModel);
          _navigateAndRemove();

          ToastConstant.showToast(context, "Login Successfully");
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ToastConstant.showToast(context, "Error!");
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

  Future SOCIAL_LOGIN_APPLE_API() async {

    print("Apple_ID ${context.read<UserProvider>().GetApple}");
    print("fcm_token $fcmToken");
    var map = Map<String, dynamic>();
    map['email'] = context.read<UserProvider>().GetApple=="" ||context.read<UserProvider>().GetApple==null ? credential!.email.toString() :context.read<UserProvider>().GetApple.toString();
    map['firebase_token'] = fcmToken!.trim();
    final response = await http.post(
      Uri.parse(ApiUtils.USER_SOCIAL_LOGIN),
      body: map,
    );

    var jsonData;

    if (response.statusCode == 200) {
      //Success

      jsonData = json.decode(response.body);
      print('social_login_response: $jsonData');
      if (jsonData['status'] == 200) {
        jsonData = json.decode(response.body);
        print('loginSuccess_data: $jsonData');
        if (jsonData['status'] == 200) {
          _userModel = UserModel.fromJson(jsonData);
          saveToPreferencesUserDetail(_userModel);
          _navigateAndRemove();

          ToastConstant.showToast(context, "Login Successfully");
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        ToastConstant.showToast(context, "Please go to your iphone setting and stop Apps Using Your Apple ID and then Try");
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

  // Future<void> initPlatformState() async {
  //   SignInApple.handleAppleSignInCallBack(onCompleteWithSignIn: (AppleIdUser user) async {
  //     print("flutter receiveCode: \n");
  //     print(user.authorizationCode);
  //     print("flutter receiveToken \n");
  //     print(user.identifyToken);
  //     setState(() {
  //       _name = user.name ?? ""; // may be null or "" if use set privacy
  //       _mail = user.mail ?? ""; // may be null or "" if use set privacy
  //       _userIdentify = user.userIdentifier;
  //       _authorizationCode = user.authorizationCode;
  //     });
  //
  //     CHECK_STATUS_API("3",_mail);
  //
  //   }, onCompleteWithError: (AppleSignInErrorCode code) async {
  //     var errorMsg = "unknown";
  //     switch (code) {
  //       case AppleSignInErrorCode.canceled:
  //         errorMsg = "user canceled request";
  //         break;
  //       case AppleSignInErrorCode.failed:
  //         errorMsg = "request fail";
  //         break;
  //       case AppleSignInErrorCode.invalidResponse:
  //         errorMsg = "request invalid response";
  //         break;
  //       case AppleSignInErrorCode.notHandled:
  //         errorMsg = "request not handled";
  //         break;
  //       case AppleSignInErrorCode.unknown:
  //         errorMsg = "request fail unknown";
  //         break;
  //     }
  //     print(errorMsg);
  //   });
  // }


  void saveToPreferencesUserDetail(UserModel? _userModel) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    userProvider.setUserEmail(_userModel!.user.email);
    userProvider.setUserToken(_userModel.user.accessToken);
    userProvider.setUserName(_userModel.user.username);
    userProvider.setUserID(_userModel.user.id.toString());
    userProvider.setUserImage(_userModel.user.image.toString());
    userProvider.setSavedDate(DateTime.now().millisecondsSinceEpoch);
  }
}
