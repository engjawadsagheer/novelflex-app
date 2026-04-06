import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:novelflex/MixScreens/InAppPurchase/singletons_data.dart';
import 'package:novelflex/Utils/Constants.dart';
import 'package:novelflex/localization/Language/languages.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:transitioner/transitioner.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/constant.dart';
import 'package:http/http.dart' as http;

import '../../Utils/toast.dart';
import '../../Widgets/loading_widgets.dart';
import '../BooksScreens/BookDetailsAuthor.dart';

class Paywall extends StatefulWidget {
  final Offering offering;

  const Paywall({Key? key, required this.offering}) : super(key: key);

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  bool _isLoading= false;
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 70.0,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0))),
                    child:  Center(
                        child:
                        Text(Languages.of(context)!.novelFlexPremium, style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ))),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.all(_height*0.02),
                    child: SizedBox(
                      child: Center(
                        child: Text(
                          Languages.of(context)!.unlockPremium,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      width: double.infinity,
                    ),
                  ),
                  ListView.builder(
                    itemCount: widget.offering.availablePackages.length,
                    itemBuilder: (BuildContext context, int index) {
                      var myProductList = widget.offering.availablePackages;
                      return Card(
                        color: Colors.white24,
                        child: ListTile(
                            onTap: () async {
                              try {
                                setState(() {
                                  _isLoading=true;
                                });
                                CustomerInfo customerInfo =
                                await Purchases.purchasePackage(
                                    myProductList[index]);
                                appData.entitlementIsActive = customerInfo
                                    .entitlements.all[entitlementID]!.isActive;
                                //Call Subscribe Api
                                Subscribe();
                                print("call_subscribe Api here during purchase");
                              } catch (e) {
                                print(e);
                              }

                              setState(() {});
                              Navigator.pop(context);
                            },
                            title: Text(
                              myProductList[index].storeProduct.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              myProductList[index].storeProduct.description,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 11,
                              ),
                            ),
                            trailing: Text(
                                "${myProductList[index].storeProduct.priceString} / Month",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ))),
                      );
                    },
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  ),
                  Container(
                    margin: EdgeInsets.all(_height*0.03),
                    child: Text(
                      Languages.of(context)!.translaTetext,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 16,

                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (

                            ) {
                          _launchTerms();
                        },
                        child: Text(
                          Languages.of(context)!.termsText,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(left: 8.0,right: 8.0),
                      child: Text("and",  style: TextStyle(
                        color: Colors.white54,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),),),
                      GestureDetector(
                        onTap: (

                            ) {
                          _launchPrivacyPolicy();
                        },
                        child: Text(
                          Languages.of(context)!.privacyPolicy,
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _height*0.05,)
                ],
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: Positioned(
                top: _height*0.325,
                  left: _width*0.35,
                  child: CustomCard(
                    gif: MoreLoadingGif(
                      type: MoreLoadingGifType.spinner,
                      size: _height * _width * 0.0002,
                    ),
                    text: 'Loading',
                  )),
            )
          ],
        ),
      ),
    );
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
        ToastConstant.showToast(context, jsonData1['data'].toString());
        setState(() {
          _isLoading=false;
        });
        print("subscribe done");
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
      }
    }
  }

  _launchPrivacyPolicy() async {
    var url = Uri.parse("https://novelflex.com/automaticRenewalAgreement.html");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchTerms() async {
    var url = Uri.parse("https://www.apple.com/legal/internet-services/itunes/dev/stdeula/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}