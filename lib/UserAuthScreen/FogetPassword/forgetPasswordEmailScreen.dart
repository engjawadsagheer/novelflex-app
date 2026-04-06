import 'dart:convert';

import 'package:auth_handler/auth_handler.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Models/forgetPasswordModelEmail.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../localization/Language/languages.dart';
import 'NewPasswordScreen.dart';

class ForgetPasswordEmailScreen extends StatefulWidget {
  const ForgetPasswordEmailScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordEmailScreen> createState() =>
      _ForgetPasswordEmailScreenState();
}

class _ForgetPasswordEmailScreenState extends State<ForgetPasswordEmailScreen> {

  AuthHandler authHandler = AuthHandler();
  TextEditingController otpController = TextEditingController();
  TextEditingController? _controllerEmail;
  var _emailFocusNode = new FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool firstState= false;

  var _emailKey = GlobalKey<FormFieldState>();

  ForgetPasswordModelEmail? forgetPasswordModelEmail;

  @override
  void initState() {
    super.initState();
    authHandler.config(
      senderName: "NovelFlex",
      senderEmail: "no-reply",
      otpLength: 6
    );
    _controllerEmail = TextEditingController();
  }

  @override
  void dispose() {
    _controllerEmail!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: _height * 0.2,
                  ),
                  Container(
                    width: _width * 0.5,
                    height: _height * 0.2,
                    decoration: BoxDecoration(
                        color: Colors.black12,
                        borderRadius: BorderRadius.circular(20)),
                    child: Icon(
                      Icons.lock,
                      color: const Color(0xff3a6c83),
                      size: _height * _width * 0.0003,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: _height * 0.03),
                    child: Text(Languages.of(context)!.resetPasswordtxt,
                        style: const TextStyle(
                            color: const Color(0xff3a6c83),
                            fontWeight: FontWeight.w700,
                            fontFamily: "Lato",
                            fontStyle: FontStyle.normal,
                            fontSize: 20.0),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: _height * 0.03),
                      child: Text(Languages.of(context)!.resetPasswordtxt2,
                          style: const TextStyle(
                              color: const Color(0xff002333),
                              fontWeight: FontWeight.w400,
                              fontFamily: "Lato",
                              fontStyle: FontStyle.normal,
                              fontSize: 12.0),
                          textAlign: TextAlign.center)),
                  Visibility(
                    visible: !firstState,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: _width * 0.05,
                          right: _width * 0.05,
                          top: _height * 0.05),
                      child: TextFormField(
                        key: _emailKey,
                        controller: _controllerEmail,
                        focusNode: _emailFocusNode,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        validator: validateEmail,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus();
                        },
                        decoration: InputDecoration(
                            errorMaxLines: 3,
                            counterText: "",
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF256D85),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                            hintText: Languages.of(context)!.email,
                            // labelText: Languages.of(context)!.email,
                            hintStyle: const TextStyle(
                              fontFamily: Constants.fontfamily,
                            )),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: firstState,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: _width * 0.05,
                          right: _width * 0.05,
                          top: _height * 0.05),
                      child: TextFormField(
                        controller: otpController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.black,
                        validator: validateOtp,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus();
                        },
                        decoration: InputDecoration(
                            errorMaxLines: 3,
                            counterText: "",
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFF256D85),
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
                                borderRadius:
                                BorderRadius.all(Radius.circular(10)),
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
                            hintText: Languages.of(context)!.otp,
                            // labelText: Languages.of(context)!.email,
                            hintStyle: const TextStyle(
                              fontFamily: Constants.fontfamily,
                            )),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: _height * 0.06),
                    child: ResuableMaterialButtonSmall(
                      onpress: () async {
                        if(firstState){
                          bool verify = await authHandler.verifyOtp(otpController.text);
                          if(verify){
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => NewPasswordScreen(
                                      token: forgetPasswordModelEmail!.user!.accessToken
                                          .toString(),
                                    )),
                                    (Route<dynamic> route) => false);
                          }else{
                            ToastConstant.showToast(context, "Sorry OTP is incorrect");
                          }

                        }else{
                          _checkInternetConnection();
                        }

                      },
                      buttonname: Languages.of(context)!.continuebtn,
                    ),
                  ),
                  Visibility(
                    visible: _isLoading,
                    child: Padding(
                      padding: EdgeInsets.only(top: _height * 0.1),
                      child: const Center(
                        child: CupertinoActivityIndicator(
                          color:  Color(0xff1b4a6b),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    } else {
      return null;
    }
  }

  String? validateOtp(String? value) {
    if (value!.isEmpty)
      return 'Enter OTP to verify';
    else
      return null;
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
      ToastConstant.showToast(context, "Internet Not Connected");
      if (this.mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _callResetPassword1stAPI();
    }
  }

  Future _callResetPassword1stAPI() async {
    // setState(() {
    //   _isLoading = true;
    // });

    var map = Map<String, dynamic>();
    map['email'] = _controllerEmail!.text.trim();

    final response = await http.post(
      Uri.parse(ApiUtils.FORGET_PASSWORD_API),
      body: map,
    );

    var jsonData;

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      if (jsonData['status'] == 200) {
        forgetPasswordModelEmail = ForgetPasswordModelEmail.fromJson(jsonData);
        print('forget_response: $jsonData');
        authHandler.sendOtp(_controllerEmail!.text);

        setState(() {
          firstState=true;
          _isLoading = false;
        });

      } else {
        ToastConstant.showToast(context, "Sorry You have not register yet!");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ToastConstant.showToast(context, "Sorry You have not register yet!");
      setState(() {
        _isLoading = false;
      });
    }
  }
}
