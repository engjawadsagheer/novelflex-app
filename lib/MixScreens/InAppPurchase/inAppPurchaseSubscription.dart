// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:novelflex/MixScreens/InAppPurchase/paywall.dart';
// import 'package:novelflex/MixScreens/InAppPurchase/singletons_data.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// import '../../Utils/constant.dart';
// import '../../Utils/native_dialog.dart';
// import '../../Utils/store_config.dart';
// import '../../Utils/top_bar.dart';
// import '../../Widgets/reusable_button_small.dart';
// import '../../localization/Language/languages.dart';
//
// class InAppSubscription extends StatefulWidget {
//   const InAppSubscription({Key? key}) : super(key: key);
//
//   @override
//   State<InAppSubscription> createState() => _InAppSubscriptionState();
// }
//
// class _InAppSubscriptionState extends State<InAppSubscription> {
//   bool _isLoading = false;
//   Offerings? offerings;
//
//   @override
//   void initState() {
//     initPlatformState();
//     super.initState();
//   }
//
//   Future<void> initPlatformState() async {
//     // Enable debug logs before calling `configure`.
//     await Purchases.setLogLevel(LogLevel.debug);
//
//     /*
//     - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
//     - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
//     */
//     PurchasesConfiguration configuration;
//     if (StoreConfig.isForAmazonAppstore()) {
//       configuration = AmazonConfiguration(StoreConfig.instance.apiKey!)
//         ..appUserID = null
//         ..observerMode = false;
//     } else {
//       configuration = PurchasesConfiguration(StoreConfig.instance.apiKey!)
//         ..appUserID = null
//         ..observerMode = false;
//     }
//     await Purchases.configure(configuration);
//
//     appData.appUserID = await Purchases.appUserID;
//
//     Purchases.addCustomerInfoUpdateListener((customerInfo) async {
//       appData.appUserID = await Purchases.appUserID;
//
//       CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//       (customerInfo.entitlements.all[entitlementID] != null &&
//           customerInfo.entitlements.all[entitlementID]!.isActive)
//           ? appData.entitlementIsActive = true
//           : appData.entitlementIsActive = false;
//
//       setState(() {});
//     });
//   }
//
//   /*
//     We should check if we can magically change the weather
//     (subscription active) and if not, display the paywall.
//   */
//   void SubscribeFunction() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//
//     if (customerInfo.entitlements.all[entitlementID] != null &&
//         customerInfo.entitlements.all[entitlementID]!.isActive == true) {
//       // appData.currentData = WeatherData.generateData();
//
//       setState(() {
//         _isLoading = false;
//       });
//     } else {
//
//       try {
//         offerings = await Purchases.getOfferings();
//         print("offers_revenue cat ${offerings?.all.toString()}");
//       } on PlatformException catch (e) {
//         await showDialog(
//             context: context,
//             builder: (BuildContext context) => ShowDialogToDismiss(
//                 title: "Error", content: e.message.toString(), buttonText: 'OK'));
//       }
//
//       setState(() {
//         _isLoading = false;
//       });
//
//       if (offerings!.current == null) {
//         // offerings are empty, show a message to your user
//       } else {
//         // current offering is available, show paywall
//         await showModalBottomSheet(
//           useRootNavigator: true,
//           isDismissible: true,
//           isScrollControlled: true,
//           backgroundColor: Colors.black,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
//           ),
//           context: context,
//           builder: (BuildContext context) {
//             return StatefulBuilder(
//                 builder: (BuildContext context, StateSetter setModalState) {
//                   return Paywall(
//                     offering: offerings!.current!,
//                   );
//                 });
//           },
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var _height = MediaQuery.of(context).size.height;
//     var _width = MediaQuery.of(context).size.width;
//     return  Scaffold(
//           backgroundColor: const Color(0xffebf5f9),
//           appBar: AppBar(
//             backgroundColor: const Color(0xffebf5f9),
//             elevation: 0.0,
//             leading: IconButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 icon: Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.black54,
//                 )),
//           ),
//           body: _isLoading ? const Center(child: CupertinoActivityIndicator()): ListView(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             children: [
//               Text(
//                 " ${ Languages.of(context)!.oneTimeSub}",
//                 style: TextStyle(
//                   fontSize: 20,
//                   color: Color(0xff333333),
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: _height * 0.05),
//               SizedBox(height: _height * 0.01),
//               Text(
//                 Languages.of(context)!.afterSub,
//                 style: TextStyle(
//                   color: Color(0xff777777),
//                   fontSize: 15,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: _height * 0.4),
//               Container(
//                 margin: EdgeInsets.only(top: _height * 0.03),
//                 child: ResuableMaterialButtonSmall(
//                   onpress: () {
//                     SubscribeFunction();
//                   },
//                   buttonname: Languages.of(context)!.Subscribe,
//                 ),
//               ),
//               SizedBox(height: _height * 0.05),
//               Row(
//                mainAxisAlignment: MainAxisAlignment.spaceAround,
//                children: [
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: [
//                      Text(
//                        Languages.of(context)!.paymentPolicy,
//                        style: TextStyle(
//                          color: Colors.black87,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 13,
//                        ),
//                      ),
//                      SizedBox(height: _height * 0.01),
//                      Text(
//                        Languages.of(context)!.privacyPolicy,
//                        style: TextStyle(
//                          color: Colors.black,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 13,
//                        ),
//                      ),
//                      SizedBox(height: _height * 0.01),
//                      Text(
//                        Languages.of(context)!.refundPolicy,
//                        style: TextStyle(
//                          color: Colors.black,
//                          fontWeight: FontWeight.bold,
//                          fontSize: 13,
//                        ),
//                      ),
//                    ],
//                  ),
//                ],
//              ),
//
//
//             ],
//           ),
//
//         );
//   }
// }
