import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:credit_card_form/credit_card_form.dart';
// import 'package:credit_card_scanner/credit_card_scanner.dart';
// import 'package:credit_card_scanner/models/card_details.dart';
// import 'package:credit_card_scanner/models/card_scan_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:novelflex/MixScreens/StripePayment/scan_option_config_widget.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';
import 'package:http/http.dart' as http;
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/Constants.dart';
import '../../Utils/toast.dart';
import '../../Widgets/reusable_button_small.dart';
import '../../localization/Language/languages.dart';
import '../BooksScreens/BookDetail.dart';
import '../BooksScreens/BookDetailsAuthor.dart';
import 'dart:io';
import '../PayPall/payment.dart';
import 'CardScanner.dart';

class StripePayment extends StatefulWidget {
  String bookId;
   StripePayment({Key? key,required this.bookId}) : super(key: key);

  @override
  State<StripePayment> createState() => _StripePaymentState();
}

class _StripePaymentState extends State<StripePayment> {
  // CardDetails? _cardDetails;
  // CardScanOptions scanOptions = const CardScanOptions(
  //   scanCardHolderName: true,
  //   enableLuhnCheck: false,
  //   enableDebugLogs: true,
  //   scanExpiryDate: true,
  //   validCardsToScanBeforeFinishingScan: 5,
  //   possibleCardHolderNamePositions: [
  //     CardHolderNameScanPosition.aboveCardNumber,
  //   ],
  // );
  //
  // Future<void> scanCard() async {
  //   final CardDetails? cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
  //   if ( !mounted || cardDetails == null ) return;
  //   setState(() {
  //     _cardDetails = cardDetails;
  //   });
  // }
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
      // appBar: AppBar(
      //   backgroundColor: const Color(0xffebf5f9),
      //   elevation: 0.0,
      //   leading: IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: Icon(
      //         Icons.arrow_back_ios,
      //         color: Colors.black54,
      //       )),
      // ),
      body:Container(

        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF19547b),Color(0xFF43cea2), Color(0xFF19547b),],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: _height*0.02,),
           Platform.isIOS ? IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: const Color(0xffffffff),
                )) : Container(),
            SizedBox(height: _height*0.01,),
            Center(
              child: SizedBox(
                height: _height * 0.2,
                width: _width * 0.4,
                child: Image.asset('assets/quotes_data/NoPath_3x-removebg-preview.png',
                ),
              ),
            ),
            Center(
              child: Text(
                  Languages.of(context)!.amountAndroid,
                  style: const TextStyle(
                      color:  const Color(0xffffffff),
                      fontWeight: FontWeight.w300,
                      fontFamily: "Alexandria",
                      fontStyle:  FontStyle.normal,
                      fontSize: 20.0
                  ),
                  textAlign: TextAlign.center
              ),
            ),
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
                      color: const Color(0xffebf5f9)
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
                      color: const Color(0xffebf5f9)
                  ),
                  child:  SizedBox(
                      height: _height*0.03,
                      width: _width*0.05,
                      child: Image.asset("assets/quotes_data/bank_imag.png")),
                ),
                GestureDetector(
                  // onTap: (){
                  //     Navigator.of(context).push(
                  //       MaterialPageRoute(
                  //         builder: (BuildContext context) => UsePaypal(
                  //             sandboxMode: false,
                  //             clientId:
                  //             "AeNe9f_qZbK-PxOKuAmzhUunMQMGDMBsmm02IuRoC0z79h5wkmj2uvBQF5wWgjbsDljVIyaKLcRw358W",
                  //             secretKey:
                  //             "AeNe9f_qZbK-PxOKuAmzhUunMQMGDMBsmm02IuRoC0z79h5wkmj2uvBQF5wWgjbsDljVIyaKLcRw358W",
                  //             returnURL: "nativexo://paypalpay",
                  //             cancelURL: "https://samplesite.com/cancel",
                  //             transactions: const [
                  //               {
                  //                 "amount": {
                  //                   "total": '3.00',
                  //                   "currency": "USD",
                  //                   "details": {
                  //                     "subtotal": '3.00',
                  //                     "shipping": '0',
                  //                     "shipping_discount": 0
                  //                   }
                  //                 },
                  //                 "description":
                  //                 "The payment transaction description.",
                  //                 // "payment_options": {
                  //                 //   "allowed_payment_method":
                  //                 //       "INSTANT_FUNDING_SOURCE"
                  //                 // },
                  //                 "item_list": {
                  //                   "items": [
                  //                     {
                  //                       "name": "subscription",
                  //                       "quantity": 1,
                  //                       "price": '3.00',
                  //                       "currency": "USD"
                  //                     }
                  //                   ],
                  //
                  //                   // shipping address is not required though
                  //                   "shipping_address": {
                  //                     "recipient_name": "Mouza Altuniji",
                  //                     "line1": "Al mourjan Tower Murror road",
                  //                     "line2": "Office no 7 M floor",
                  //                     "city": "Abu Dhabi",
                  //                     "country_code": "AE",
                  //                     "postal_code": "00000",
                  //                     "phone": "+971505796166",
                  //                     "state": "United Arab Emirates"
                  //                   },
                  //                 }
                  //               }
                  //             ],
                  //             note: "Contact us for any questions on your order.",
                  //             onSuccess: (Map params) async {
                  //               print("onSuccess: $params");
                  //               Subscribe();
                  //             },
                  //             onError: (error) {
                  //               print("onError: $error");
                  //             },
                  //             onCancel: (params) {
                  //               print('cancelled: $params');
                  //             }),
                  //       ),
                  //     );
                  //
                  // },
                  onTap: (){
                    Transitioner(
                      context: context,
                      child:PaypalPayment(
                        onFinish: (number) async {

                          // payment done
                          print('order id: '+number);

                        },
                      ),
                      animation: AnimationType.slideLeft, // Optional value
                      duration: Duration(milliseconds: 1000), // Optional value
                      replacement: true, // Optional value
                      curveType: CurveType.decelerate, // Optional value
                    );
                  },
                  child: Container(
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
                        color: const Color(0xffebf5f9)
                    ),
                    child:  SizedBox(
                        height: _height*0.03,
                        width: _width*0.05,
                        child: Image.asset("assets/quotes_data/paypal_img.png")),
                  ),
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
                buttonname: Languages.of(context)!.subscribeTxt,
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
            // Container(
            //   margin: EdgeInsets.only(top: _height * 0.03),
            //   child: ResuableMaterialButtonSmall(
            //     onpress: () {
            //       scanCard();
            //     },
            //     buttonname: Languages.of(context)!.scan,
            //   ),
            // ),
            SizedBox(),
          ],
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
        Subscribe();
        print("payment Done");
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future Subscribe() async {

    var map = Map<String, dynamic>();
    map['referral_code'] = context.read<UserProvider>().GetReferral.toString();

    final response =
    await http.post(Uri.parse(ApiUtils.USER_SUBSCRIPTION_API), headers: {
      'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
    },
        body: map
    );

    if (response.statusCode == 200) {
      print('subscribe_response${response.body}');
      var jsonData1 = json.decode(response.body);
      if (jsonData1['status'] == 200) {
        ToastConstant.showToast(context, "Subscription Successful");
        print("subscribe done");
        Transitioner(
          context: context,
          child: BookDetail(bookID: widget.bookId,),
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


