// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:credit_card_scanner/credit_card_scanner.dart';
// import 'package:novelflex/MixScreens/StripePayment/scan_option_config_widget.dart';
//
// class ScanCard extends StatefulWidget {
//   const ScanCard({Key? key}) : super(key: key);
//
//   @override
//   State<ScanCard> createState() => _ScanCardState();
// }
//
// class _ScanCardState extends State<ScanCard> {
//   CardDetails? _cardDetails;
//   CardScanOptions scanOptions = const CardScanOptions(
//     scanCardHolderName: true,
//     validCardsToScanBeforeFinishingScan: 5,
//     possibleCardHolderNamePositions: [
//       CardHolderNameScanPosition.aboveCardNumber,
//     ],
//   );
//
//   Future<void> scanCard() async {
//     final CardDetails? cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
//     if ( !mounted || cardDetails == null ) return;
//     setState(() {
//       _cardDetails = cardDetails;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//         appBar: AppBar(
//           title: const Text('Scan Card'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               MaterialButton(
//                 color: Colors.blue,
//                 onPressed: () async {
//                   scanCard();
//                 },
//                 child: const Text('scan card'),
//               ),
//               Text('$_cardDetails'),
//               Expanded(
//                 child: OptionConfigureWidget(
//                   initialOptions: scanOptions,
//                   onScanOptionChanged: (newOptions) => scanOptions = newOptions,
//                 ),
//               )
//             ],
//           ),
//         ),
//     );
//   }
// }