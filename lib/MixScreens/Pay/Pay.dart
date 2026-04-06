// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:novelflex/localization/Language/languages.dart';
// import 'package:pay/pay.dart';
// import 'payment_configurations.dart' as payment_configurations;
//
// const _paymentItems = [
//   PaymentItem(
//     label: 'Total',
//     amount: '3',
//     status: PaymentItemStatus.final_price,
//   )
// ];
//
// class Pay extends StatefulWidget {
//   String image;
//   String name;
//   Pay({Key? key, required this.image, required this.name}) : super(key: key);
//
//   @override
//   State<Pay> createState() => _PayState();
// }
//
// class _PayState extends State<Pay> {
//   late final Future<PaymentConfiguration> _googlePayConfigFuture;
//   late final Future<PaymentConfiguration> _ApplePayConfigFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _googlePayConfigFuture =
//         PaymentConfiguration.fromAsset('default_google_pay_config.json');
//     _ApplePayConfigFuture =
//         PaymentConfiguration.fromAsset('default_apple_pay_config.json');
//   }
//
//   void onGooglePayResult(paymentResult) {
//     debugPrint(paymentResult.toString());
//   }
//
//   void onApplePayResult(paymentResult) {
//     debugPrint(paymentResult.toString());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var _height = MediaQuery.of(context).size.height;
//     var _width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: const Color(0xffebf5f9),
//       appBar: AppBar(
//         backgroundColor: const Color(0xffebf5f9),
//         elevation: 0.0,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: Icon(
//               Icons.arrow_back_ios,
//               color: Colors.black54,
//             )),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.symmetric(horizontal: 20),
//         children: [
//           Text(
//             " ${ Languages.of(context)!.oneTimeSub}",
//             style: TextStyle(
//               fontSize: 20,
//               color: Color(0xff333333),
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: _height * 0.05),
//           SizedBox(height: _height * 0.01),
//           Text(
//             Languages.of(context)!.afterSub,
//             style: TextStyle(
//               color: Color(0xff777777),
//               fontSize: 15,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: _height * 0.1),
//           Center(
//             child: CircleAvatar(
//               backgroundColor: Colors.black38,
//               child: CachedNetworkImage(
//                 filterQuality: FilterQuality.high,
//                 imageBuilder: (context, imageProvider) => Container(
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     // borderRadius:
//                     // BorderRadius.circular(
//                     //     10),
//                     image: DecorationImage(
//                         image: imageProvider, fit: BoxFit.cover),
//                   ),
//                 ),
//                 imageUrl: widget.image,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => const Center(
//                     child: CupertinoActivityIndicator(
//                   color: Color(0xFF256D85),
//                 )),
//                 errorWidget: (context, url, error) =>
//                     const Center(child: Icon(Icons.error_outline)),
//               ),
//               radius: _height * _width * 0.00015,
//             ),
//           ),
//           Center(
//             child: Text(
//               widget.name,
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Color(0xff333333),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           SizedBox(height: _height * 0.1),
//
//           FutureBuilder<PaymentConfiguration>(
//               future: _googlePayConfigFuture,
//               builder: (context, snapshot) => snapshot.hasData
//                   ? GooglePayButton(
//                       paymentConfiguration: snapshot.data!,
//                       height: RawGooglePayButton.defaultButtonHeight,
//                       paymentItems: _paymentItems,
//                       type: GooglePayButtonType.subscribe,
//                       margin: const EdgeInsets.only(top: 15.0),
//                       onPaymentResult: onGooglePayResult,
//                       loadingIndicator: const Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     )
//                   : const SizedBox.shrink()),
//
//           FutureBuilder<PaymentConfiguration>(
//               future: _ApplePayConfigFuture,
//               builder: (context, snapshot) => snapshot.hasData
//                   ? ApplePayButton(
//                       paymentConfiguration: snapshot.data!,
//                       height: _height*0.06,
//                       paymentItems: _paymentItems,
//                       style: ApplePayButtonStyle.black,
//                       type: ApplePayButtonType.subscribe,
//                       margin: const EdgeInsets.only(top: 15.0),
//                       onPaymentResult: onApplePayResult,
//                       loadingIndicator: const Center(
//                         child: CupertinoActivityIndicator(),
//                       ),
//                     )
//                   : const SizedBox.shrink()),
//
//           const SizedBox(height: 15)
//         ],
//       ),
//     );
//   }
// }
