import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:novelflex/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../localization/Language/languages.dart';

class WithDrawPaymentScreen extends StatefulWidget {
  const WithDrawPaymentScreen({Key? key}) : super(key: key);

  @override
  State<WithDrawPaymentScreen> createState() => _WithDrawPaymentScreenState();
}

class _WithDrawPaymentScreenState extends State<WithDrawPaymentScreen> {
  final _ibanFN = new FocusNode();
  final _nameFN = new FocusNode();
  final _fatherFN = new FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _ibanKey = GlobalKey<FormFieldState>();
  final _nameKey = GlobalKey<FormFieldState>();
  final _fatherNameKey = GlobalKey<FormFieldState>();

  TextEditingController? _ibanController;
  TextEditingController? _nameController;
  TextEditingController? _fatherNameController;
  bool _isLoading = false;
  bool _isInternetConnected = true;
  String? amount = "3";


  @override
  void initState()  {
    super.initState();
    _ibanController = TextEditingController();
    _nameController = TextEditingController();
    _fatherNameController = TextEditingController();
  }

  @override
  void dispose() {
    _ibanController!.dispose();
    _nameController!.dispose();
    _fatherNameController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf6f9),
      appBar: AppBar(
        backgroundColor: const Color(0xffebf5f9),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            )),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: _height * 0.03,
              ),
              Container(
                height: _height * 0.5,
                width: _width,
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: _height * 0.02, horizontal: _width * 0.04),
                        child: TextFormField(
                          key: _ibanKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _ibanController,
                          focusNode: _ibanFN,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          validator: validateIBAN,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_nameFN);
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
                              hintText: Languages.of(context)!.iban,
                              // labelText: Languages.of(context)!.email,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: _height * 0.02, horizontal: _width * 0.04),
                        child: TextFormField(
                          key: _nameKey,
                          controller: _nameController,
                          focusNode: _nameFN,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          cursorColor: Colors.black,
                          validator: validateName,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_fatherFN);
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
                              hintText: Languages.of(context)!.cardHolderName,
                              // labelText: Languages.of(context)!.email,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: _height * 0.02, horizontal: _width * 0.04),
                        child: TextFormField(
                          key: _fatherNameKey,
                          controller: _fatherNameController,
                          focusNode: _fatherFN,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.black,
                          validator: validateFatherName,
                          // onFieldSubmitted: (_) {
                          //   FocusScope.of(context)
                          //       .requestFocus(_passwordFocusNode);
                          // },
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
                              hintText: Languages.of(context)!.fatherName,
                              // labelText: Languages.of(context)!.email,
                              hintStyle: const TextStyle(
                                fontFamily: Constants.fontfamily,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: _height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 110,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0x17000000),
                              offset: Offset(0, 5),
                              blurRadius: 16,
                              spreadRadius: 0)
                        ],
                        color: const Color(0xffffffff)),
                    child: SizedBox(
                        height: _height * 0.03,
                        width: _width * 0.05,
                        child: Image.asset(
                            "assets/quotes_data/matercard_withDraw.png")),
                  ),
                  Container(
                    width: 110,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0x17000000),
                              offset: Offset(0, 5),
                              blurRadius: 16,
                              spreadRadius: 0)
                        ],
                        color: const Color(0xffffffff)),
                    child: SizedBox(
                        height: _height * 0.03,
                        width: _width * 0.05,
                        child: Image.asset("assets/quotes_data/bank_imag.png")),
                  ),
                  Container(
                    width: 110,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0x17000000),
                              offset: Offset(0, 5),
                              blurRadius: 16,
                              spreadRadius: 0)
                        ],
                        color: const Color(0xffffffff)),
                    child: SizedBox(
                        height: _height * 0.03,
                        width: _width * 0.05,
                        child:
                            Image.asset("assets/quotes_data/paypal_img.png")),
                  ),
                ],
              ),
              Visibility(
                  visible: _isLoading,
                  child: Padding(
                    padding: EdgeInsets.only(top: _height * 0.1),
                    child: const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )),
              SizedBox(
                height: _height * 0.02,
              ),
              Container(
                margin: EdgeInsets.only(top: _height * 0.03),
                child: ResuableMaterialButtonSmall(
                  onpress: () {
                    if (_formKey.currentState!.validate()) {
                      _checkInternetConnection();
                    } else {
                      ToastConstant.showToast(context,
                          "Please fill all the Fields with Correct information");
                    }
                  },
                  buttonname: Languages.of(context)!.apply,
                ),
              ),
              SizedBox(
                height: _height * 0.03,
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(_width * 0.05),
                  child: Text(Languages.of(context)!.carefulText,
                      style: const TextStyle(
                          color: const Color(0xff707070),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Alexandria",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.center),
                ),
              ),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future WithDrawPAymentApiCall() async {
    var map = Map<String, dynamic>();
    map['iban'] = _ibanController!.text.trim().toString();
    map['username'] = _nameController!.text.trim().toString();
    map['father_name'] = _fatherNameController!.text.trim().toString();

    final response = await http.post(Uri.parse(ApiUtils.PAYMENT_APPLY_API),
        headers: {
          'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
        },
        body: map);

    if (response.statusCode == 200) {
      print('payment_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        ToastConstant.showToast(context, jsonData1['success'].toString());
        Transitioner(
          context: context,
          child: TabScreen(),
          animation: AnimationType.fadeIn, // Optional value
          duration: Duration(milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );

      } else {
        ToastConstant.showToast(context, jsonData1['success'].toString());
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
      WithDrawPAymentApiCall();
    }
  }

  String? validateIBAN(String? value) {
    if (value!.isEmpty) {
      return 'Please Inter International Bank Account Number';
    } else
      return null;
  }

  String? validateName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Account Holder Name';
    } else {
      return null;
    }
  }

  String? validateFatherName(String? value) {
    if (value!.isEmpty) {
      return 'Please enter Account Holder Father Name';
    } else{
      return null;
    }

  }
}
