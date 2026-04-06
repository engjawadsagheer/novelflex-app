
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:transitioner/transitioner.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../localization/Language/languages.dart';

class GiftScreen extends StatefulWidget {
  String author_id;
  String amount;
   GiftScreen({Key? key,required this.author_id, required this.amount}) : super(key: key);

  @override
  State<GiftScreen> createState() => _GiftScreenState();
}

class _GiftScreenState extends State<GiftScreen> {

  bool _isLoading = false;
  bool _isInternetConnected = true;
  String? cardNumber;
  String? cardHolderName;
  String? expMonth;
  String? expYear;
  String? cvV;
  String? amount= "3";

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return  Scaffold(
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
      body:SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: _height*0.03,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CreditCardForm(
                  theme: CreditCardLightTheme(),
                  onChanged: (CreditCardResult result) {

                    cardNumber=result.cardNumber;
                    cardHolderName=result.cardHolderName;
                    expMonth=result.expirationMonth;
                    expYear=result.expirationYear;
                    cvV=result.cvc;

                    print(result.cardNumber);
                    print(result.cardHolderName);
                    print(result.expirationMonth);
                    print(result.expirationYear);
                    print(result.cardType);
                    print(result.cvc);
                  },
                ),
              ),
              SizedBox(height: _height*0.04,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 110,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)
                        ),
                        boxShadow: [BoxShadow(
                            color: const Color(0x17000000),
                            offset: Offset(0,5),
                            blurRadius: 16,
                            spreadRadius: 0
                        )] ,
                        color: const Color(0xffffffff)
                    ),
                    child:  SizedBox(
                        height: _height*0.03,
                        width: _width*0.05,
                        child: Image.asset("assets/quotes_data/matercard_withDraw.png")),
                  ),
                  Container(
                    width: 110,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)
                        ),

                        boxShadow: [BoxShadow(
                            color: const Color(0x17000000),
                            offset: Offset(0,5),
                            blurRadius: 16,
                            spreadRadius: 0
                        )] ,
                        color: const Color(0xffffffff)
                    ),
                    child:  SizedBox(
                        height: _height*0.03,
                        width: _width*0.05,
                        child: Image.asset("assets/quotes_data/bank_imag.png")),
                  ),
                  Container(
                    width: 110,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10)
                        ),
                        boxShadow: [BoxShadow(
                            color: const Color(0x17000000),
                            offset: Offset(0,5),
                            blurRadius: 16,
                            spreadRadius: 0
                        )] ,
                        color: const Color(0xffffffff)
                    ),
                    child:  SizedBox(
                        height: _height*0.03,
                        width: _width*0.05,
                        child: Image.asset("assets/quotes_data/paypal_img.png")),
                  ),
                ],
              ),
              SizedBox(height: _height*0.04,),
              Container(
                margin: EdgeInsets.only(top: _height * 0.03),
                child: ResuableMaterialButtonSmall(
                  onpress: () {
                    if(cardHolderName!.isNotEmpty && cardNumber!.isNotEmpty && expMonth!.isNotEmpty &&
                        expYear!.isNotEmpty && cvV!.isNotEmpty){
                      _checkInternetConnection();
                    }else{
                      Constants.showToastBlack(context, "Please fill all the Fields with Correct information");
                    }

                  },
                  buttonname: Languages.of(context)!.gift,
                ),
              ),
              Visibility(
                  visible: _isLoading,
                  child : Padding(
                    padding:  EdgeInsets.only(top: _height*0.1),
                    child: const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  )),
              SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future StripeApiCall() async {

    var map = Map<String, dynamic>();
    map['cardno'] = cardNumber;
    map['month'] = expMonth;
    map['year'] = expYear;
    map['cvv'] = cvV;
    map['amount'] = amount;
    map['payment_method'] = "1";
    map['name'] = cardHolderName;
    final response =
    await http.post(Uri.parse(ApiUtils.STRIPE_PAYMENT_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    },
        body: map
    );

    if (response.statusCode == 200) {
      print('payment_response${response.body}');
      var jsonData = response.body;
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        GiftApi();
        print("payment Done");
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future GiftApi() async {

    var map = Map<String, dynamic>();
    map['user_id'] = widget.author_id.toString();
    map['amount'] = widget.amount.toString();

    final response =
    await http.post(Uri.parse(ApiUtils.GIFT_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    },
        body: map
    );

    if (response.statusCode == 200) {
      print('subscribe_response${response.body}');
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        ToastConstant.showToast(context, jsonData1['success'].toString());
        print("gift done");
        Transitioner(
          context: context,
          child: TabScreen(),
          animation: AnimationType
              .slideLeft, // Optional value
          duration: Duration(
              milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType:
          CurveType.decelerate, // Optional value
        );
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
      StripeApiCall();
    }
  }
}
