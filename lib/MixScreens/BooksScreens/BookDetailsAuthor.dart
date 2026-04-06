// import 'dart:convert';
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:http/http.dart' as http;
// import 'package:more_loading_gif/more_loading_gif.dart';
// import 'package:novelflex/MixScreens/StripePayment/StripePayment.dart';
// import 'package:novelflex/Models/LikeDislikeModel.dart';
// import 'package:provider/provider.dart';
// import 'package:purchases_flutter/models/offerings_wrapper.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import 'package:transitioner/transitioner.dart';
// import '../../Models/BookDetailsModel.dart';
// import '../../Models/subscriptionModelClass.dart';
// import '../../Provider/UserProvider.dart';
// import '../../Provider/VariableProvider.dart';
// import '../../Utils/ApiUtils.dart';
// import '../../Utils/Constants.dart';
// import '../../Utils/constant.dart';
// import '../../Utils/native_dialog.dart';
// import '../../Utils/store_config.dart';
// import '../../Utils/toast.dart';
// import '../../Widgets/loading_widgets.dart';
// import '../../ad_helper.dart';
// import '../../localization/Language/languages.dart';
// import 'BookViewTab.dart';
// import 'AuthorViewByUserScreen.dart';
// import 'dart:io';
// import '../InAppPurchase/inAppPurchaseSubscription.dart';
// import '../InAppPurchase/paywall.dart';
// import '../InAppPurchase/singletons_data.dart';
// import 'BookReviewScreen.dart';
//
// class BookDetailAuthor extends StatefulWidget {
//   String bookID;
//   BookDetailAuthor({required this.bookID});
//
//   @override
//   State<BookDetailAuthor> createState() => _BookDetailAuthorState();
// }
//
// class _BookDetailAuthorState extends State<BookDetailAuthor> {
//   bool _isLoading = false;
//   bool _isInternetConnected = true;
//   BookDetailsModel? _bookDetailsModel;
//   LikeDislikeModel? _likeDislikeModel;
//   var token;
//   bool? _isLike;
//   bool? _isDisLike;
//   bool _isSaved = false;
//   Offerings? offerings;
//   BannerAd? _bannerAd;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkInternetConnection();
//     _loadAds();
//   }
//
//   _loadAds() {
//     BannerAd(
//       adUnitId: AdHelper.bannerAdUnitId,
//       request: AdRequest(),
//       size: AdSize.banner,
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           setState(() {
//             _bannerAd = ad as BannerAd;
//           });
//         },
//         onAdFailedToLoad: (ad, err) {
//           print('Failed to load a banner ad: ${err.message}');
//           ad.dispose();
//         },
//       ),
//     ).load();
//   }
//
//   @override
//   void dispose() {
//     _bannerAd?.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var _height = MediaQuery.of(context).size.height;
//     var _width = MediaQuery.of(context).size.width;
//     VariableProvider userProvider =
//         Provider.of<VariableProvider>(context, listen: false);
//     return Scaffold(
//       backgroundColor: const Color(0xffebf5f9),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
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
//       body: _isInternetConnected == false
//           ? Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "INTERNET NOT CONNECTED",
//                     style: TextStyle(
//                       fontFamily: Constants.fontfamily,
//                       color: Color(0xFF256D85),
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   SizedBox(
//                     height: _height * 0.019,
//                   ),
//                   InkWell(
//                     child: Container(
//                       width: _width * 0.40,
//                       height: _height * 0.058,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFF256D85),
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(
//                             40.0,
//                           ),
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.5),
//                             spreadRadius: 5,
//                             blurRadius: 7,
//                             offset: Offset(0, 3), // changes position of shadow
//                           ),
//                         ],
//                       ),
//                       child: const Center(
//                         child: Text(
//                           "No Internet Connected",
//                           style: TextStyle(
//                             fontFamily: Constants.fontfamily,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                     onTap: () {
//                       _checkInternetConnection();
//                     },
//                   ),
//                 ],
//               ),
//             )
//           : _isLoading
//               ? Align(
//                   alignment: Alignment.center,
//                   child: CustomCard(
//                     gif: MoreLoadingGif(
//                       type: MoreLoadingGifType.eclipse,
//                       size: _height * _width * 0.0002,
//                     ),
//                     text: 'Loading',
//                   ),
//                 )
//               : Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Transitioner(
//                               context: context,
//                               child: BookViewTab(
//                                 bookId:
//                                     _bookDetailsModel!.data!.bookId.toString(),
//                                 bookName: _bookDetailsModel!.data!.bookTitle
//                                     .toString(),
//                                 readerId:
//                                     _bookDetailsModel!.data!.userId.toString(),
//                                 PaymentStatus: _bookDetailsModel!
//                                     .data!.paymentStatus
//                                     .toString(),
//                                 cover_url: _bookDetailsModel!.data!.imagePath
//                                     .toString(),
//                               ),
//                               animation:
//                                   AnimationType.slideTop, // Optional value
//                               duration: Duration(
//                                   milliseconds: 1000), // Optional value
//                               replacement: false, // Optional value
//                               curveType: CurveType.decelerate, // Optional value
//                             );
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.all(8.0),
//                             child: ClipRRect(
//                               child: Container(
//                                 width: _width * 0.6,
//                                 height: _height * 0.42,
//                                 decoration: BoxDecoration(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(10)),
//                                     color: const Color(0xffebf5f9),
//                                     image: DecorationImage(
//                                         fit: BoxFit.cover,
//                                         image: NetworkImage(_bookDetailsModel!
//                                             .data!.imagePath
//                                             .toString())),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Text(Languages.of(context)!.author,
//                                   style: const TextStyle(
//                                       color: const Color(0xff3a6c83),
//                                       fontWeight: FontWeight.w700,
//                                       fontFamily: "Alexandria",
//                                       fontStyle: FontStyle.normal,
//                                       fontSize: 16.0),
//                                   textAlign: TextAlign.left),
//                               GestureDetector(
//                                 onTap: () {
//                                   Transitioner(
//                                     context: context,
//                                     child: AuthorViewByUserScreen(
//                                       user_id: _bookDetailsModel!.data!.userId
//                                           .toString(),
//                                     ),
//                                     animation: AnimationType
//                                         .slideTop, // Optional value
//                                     duration: Duration(
//                                         milliseconds: 1000), // Optional value
//                                     replacement: false, // Optional value
//                                     curveType:
//                                         CurveType.decelerate, // Optional value
//                                   );
//                                 },
//                                 child: Container(
//                                     width: _width * 0.17,
//                                     height: _height * 0.12,
//                                     decoration: BoxDecoration(
//                                         shape: BoxShape.circle,
//                                         border: Border.all(
//                                             color: const Color(0xff3a6c83),
//                                             width: 1),
//                                         image: DecorationImage(
//                                             image: _bookDetailsModel!
//                                                         .data!.userimage ==
//                                                     null
//                                                 ? AssetImage(
//                                                     'assets/profile_pic.png',
//                                                   )
//                                                 : NetworkImage(
//                                                         _bookDetailsModel!
//                                                             .data!.userimage
//                                                             .toString())
//                                                     as ImageProvider,
//                                             fit: BoxFit.cover),
//                                     ),
//
//                                 ),
//                               ),
//                               Text(
//                                   _bookDetailsModel!.data!.authorName
//                                       .toString(),
//                                   style: const TextStyle(
//                                       color: const Color(0xff2a2a2a),
//                                       fontWeight: FontWeight.w500,
//                                       fontFamily: "Lato",
//                                       fontStyle: FontStyle.normal,
//                                       fontSize: 10.0),
//                                   overflow: TextOverflow.ellipsis,
//                                   maxLines: 1,
//                                   textAlign: TextAlign.left),
//                               SizedBox(
//                                 height: _height * 0.03,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       Text(
//                                           _bookDetailsModel!.data!.subscription
//                                               .toString(),
//                                           style: const TextStyle(
//                                               color: const Color(0xff2a2a2a),
//                                               fontWeight: FontWeight.w500,
//                                               fontFamily: "Lato",
//                                               fontStyle: FontStyle.normal,
//                                               fontSize: 10.0),
//                                           textAlign: TextAlign.left),
//                                       SizedBox(
//                                         height: _height * 0.009,
//                                       ),
//                                       Text(Languages.of(context)!.followers,
//                                           style: const TextStyle(
//                                               color: const Color(0xff2a2a2a),
//                                               fontWeight: FontWeight.w500,
//                                               fontFamily: "Lato",
//                                               fontStyle: FontStyle.normal,
//                                               fontSize: 8.0),
//                                           textAlign: TextAlign.left)
//                                     ],
//                                   ),
//                                   Column(
//                                     children: [
//                                       Text(
//                                           _bookDetailsModel!.data!.publication
//                                               .toString(),
//                                           style: const TextStyle(
//                                               color: const Color(0xff2a2a2a),
//                                               fontWeight: FontWeight.w500,
//                                               fontFamily: "Lato",
//                                               fontStyle: FontStyle.normal,
//                                               fontSize: 10.0),
//                                           textAlign: TextAlign.left),
//                                       SizedBox(
//                                         height: _height * 0.009,
//                                       ),
//                                       Text(Languages.of(context)!.published,
//                                           style: const TextStyle(
//                                               color: const Color(0xff2a2a2a),
//                                               fontWeight: FontWeight.w500,
//                                               fontFamily: "Lato",
//                                               fontStyle: FontStyle.normal,
//                                               fontSize: 8.0),
//                                           textAlign: TextAlign.left)
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: _height * 0.02,
//                               ),
//                               Opacity(
//                                 opacity: 0.20000000298023224,
//                                 child: Container(
//                                     width: _width * 0.23,
//                                     height: 1,
//                                     decoration: BoxDecoration(
//                                         color: const Color(0xff919191))),
//                               ),
//                               SizedBox(
//                                 height: _height * 0.01,
//                               ),
//                               Container(
//                                 width: _width * 0.27,
//                                 height: _height * 0.035,
//                                 decoration: BoxDecoration(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(5)),
//                                     border: Border.all(
//                                         color: const Color(0xff3a6c83),
//                                         width: 1),
//                                     color: const Color(0xffebf5f9)),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   children: [
//                                     Text(
//                                       Languages.of(context)!.view,
//                                       style: const TextStyle(
//                                           color: const Color(0xff3a6c83),
//                                           fontWeight: FontWeight.w400,
//                                           fontFamily: "Lato",
//                                           fontStyle: FontStyle.normal,
//                                           fontSize: 12.0),
//                                     ),
//                                     Text(
//                                         _bookDetailsModel!.data!.bookView
//                                             .toString(),
//                                         style: const TextStyle(
//                                             color: const Color(0xff3a6c83),
//                                             fontWeight: FontWeight.w700,
//                                             fontFamily: "Lato",
//                                             fontStyle: FontStyle.normal,
//                                             fontSize: 12.0),
//                                         textAlign: TextAlign.left)
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: _height * 0.03,
//                               ),
//                               Container(
//                                 width: _width * 0.28,
//                                 height: _height * 0.035,
//                                 decoration: BoxDecoration(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(5)),
//                                     color: const Color(0xffffffff)),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   children: [
//                                     Text(
//                                       context
//                                           .read<VariableProvider>()
//                                           .getLikes
//                                           .toString(),
//                                       style: const TextStyle(
//                                           color: const Color(0xff00bb23),
//                                           fontWeight: FontWeight.w700,
//                                           fontFamily: "Lato",
//                                           fontStyle: FontStyle.normal,
//                                           fontSize: 10.0),
//                                     ),
//                                     Opacity(
//                                       opacity: 0.20000000298023224,
//                                       child: Container(
//                                           width: 1,
//                                           height: _height * 0.02,
//                                           decoration: BoxDecoration(
//                                               color: const Color(0xff919191))),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           if (_isLike!) {
//                                             _LikesDisLikesAPI("0");
//                                             userProvider.setLikes(
//                                                 userProvider.getLikes - 1);
//                                             userProvider.setDislikes(
//                                                 _bookDetailsModel!
//                                                     .data!.bookDisLike!);
//
//                                             print("0");
//                                           } else {
//                                             _LikesDisLikesAPI("1");
//                                             userProvider.setLikes(
//                                                 userProvider.getLikes + 1);
//                                             userProvider.setDislikes(
//                                                 _bookDetailsModel!
//                                                     .data!.bookDisLike!);
//                                             print("1");
//                                           }
//                                           _isLike = !_isLike!;
//                                           _isDisLike = false;
//                                         });
//                                       },
//                                       child: Icon(Icons.thumb_up,
//                                           color: _isLike!
//                                               ? Color(0xff00bb23)
//                                               : Colors.black38),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: _height * 0.03,
//                               ),
//                               Container(
//                                 width: _width * 0.28,
//                                 height: _height * 0.035,
//                                 decoration: BoxDecoration(
//                                     borderRadius:
//                                         BorderRadius.all(Radius.circular(5)),
//                                     color: const Color(0xffffffff)),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceAround,
//                                   children: [
//                                     Text(
//                                       context
//                                           .read<VariableProvider>()
//                                           .getDislikes
//                                           .toString(),
//                                       style: const TextStyle(
//                                           color: const Color(0xff00bb23),
//                                           fontWeight: FontWeight.w700,
//                                           fontFamily: "Lato",
//                                           fontStyle: FontStyle.normal,
//                                           fontSize: 10.0),
//                                     ),
//                                     Opacity(
//                                       opacity: 0.20000000298023224,
//                                       child: Container(
//                                           width: 1,
//                                           height: _height * 0.02,
//                                           decoration: BoxDecoration(
//                                               color: const Color(0xff919191))),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           if (_isDisLike!) {
//                                             _LikesDisLikesAPI("0");
//                                             userProvider.setDislikes(
//                                                 userProvider.getDislikes - 1);
//                                             userProvider.setLikes(
//                                                 _bookDetailsModel!
//                                                     .data!.bookLike!);
//                                           } else {
//                                             _LikesDisLikesAPI("2");
//                                             userProvider.setDislikes(
//                                                 userProvider.getDislikes + 1);
//                                             userProvider.setLikes(
//                                                 _bookDetailsModel!
//                                                     .data!.bookLike!);
//                                           }
//                                           _isLike = false;
//                                           _isDisLike = !_isDisLike!;
//                                         });
//                                       },
//                                       child: Icon(Icons.thumb_down,
//                                           color: _isDisLike!
//                                               ? Color(0xff00bb23)
//                                               : Colors.black38),
//                                     )
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(top: _height * 0.01),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//
//                           Container(
//                             width: _width*0.4,
//                             child: Text(_bookDetailsModel!.data!.bookTitle!,
//                                 style: const TextStyle(
//                                     color: const Color(0xff2a2a2a),
//                                     fontWeight: FontWeight.w700,
//                                     fontFamily: "Alexandria",
//                                     fontStyle: FontStyle.normal,
//                                     fontSize: 16.0),
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left),
//                           ),
//                           Container(
//                             width: _width*0.15,
//                             child: Text(_bookDetailsModel!.data!.catgoryTitle.toString(),
//                                 style: const TextStyle(
//                                     color: const Color(0xff3a6c83),
//                                     fontWeight: FontWeight.w700,
//                                     fontFamily: "Lato",
//                                     fontStyle: FontStyle.normal,
//                                     fontSize: 12.0),
//                                 textAlign: TextAlign.left),
//                           ),
//                           InkWell(
//                             onTap: () {
//                               Transitioner(
//                                 context: context,
//                                 child: ShowAllReviewScreen(
//                                   bookId: _bookDetailsModel!.data!.bookId
//                                       .toString(),
//                                   bookName: _bookDetailsModel!.data!.bookTitle
//                                       .toString(),
//                                   bookImage: _bookDetailsModel!.data!.imagePath
//                                       .toString(),
//                                 ),
//                                 animation:
//                                     AnimationType.slideTop, // Optional value
//                                 duration: Duration(
//                                     milliseconds: 1000), // Optional value
//                                 replacement: false, // Optional value
//                                 curveType:
//                                     CurveType.decelerate, // Optional value
//                               );
//                             },
//                             child: Column(
//                               children: [
//                                 Text(Languages.of(context)!.allReview,
//                                     style: const TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                         fontFamily: "Lato",
//                                         fontStyle: FontStyle.normal,
//                                         fontSize: 13.0),
//                                     textAlign: TextAlign.left),
//                                 Container(
//                                     width: _width * 0.3,
//                                     height: 1,
//                                     decoration:
//                                         BoxDecoration(color: Colors.black))
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.only(
//                           left: _width * 0.02,
//                           top: _height * 0.02,
//                           right: _width * 0.02),
//                       child: Container(
//                         height: _height * 0.2,
//                         width: _width,
//                         padding: EdgeInsets.all(_width * 0.035),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             color: Colors.white),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text(
//                                   Languages.of(context)!.aboutBook,
//                                   style: const TextStyle(
//                                       color: const Color(0xff2a2a2a),
//                                       fontWeight: FontWeight.w500,
//                                       fontFamily: "Alexandria",
//                                       fontStyle: FontStyle.normal,
//                                       fontSize: 16.0),
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     Transitioner(
//                                       context: context,
//                                       child: AuthorViewByUserScreen(
//                                         user_id: _bookDetailsModel!.data!.userId
//                                             .toString(),
//                                       ),
//                                       animation: AnimationType
//                                           .slideTop, // Optional value
//                                       duration: Duration(
//                                           milliseconds: 1000), // Optional value
//                                       replacement: false, // Optional value
//                                       curveType: CurveType
//                                           .decelerate, // Optional value
//                                     );
//                                   },
//                                   child: Padding(
//                                     padding:
//                                         EdgeInsets.only(right: _width * 0.07),
//                                     child: Column(
//                                       children: [
//                                         Text(
//                                             Languages.of(context)!
//                                                 .seeAuthorBooks,
//                                             style: const TextStyle(
//                                                 color: Color(0xff3a6c83),
//                                                 fontWeight: FontWeight.bold,
//                                                 fontFamily: "Lato",
//                                                 fontStyle: FontStyle.normal,
//                                                 fontSize: 13.0),
//                                             textAlign: TextAlign.left),
//                                         Container(
//                                             width: _width * 0.3,
//                                             height: 1,
//                                             decoration: BoxDecoration(
//                                                 color: const Color(0xff3a6c83)))
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: _height * 0.01,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 _bookDetailsModel!.data!.bookDescription
//                                     .toString(),
//                                 style: const TextStyle(
//                                     color: const Color(0xff676767),
//                                     fontWeight: FontWeight.w400,
//                                     fontFamily: "Lato",
//                                     fontStyle: FontStyle.normal,
//                                     fontSize: 14.0),
//                                 overflow: TextOverflow.ellipsis,
//                                 maxLines: 4,
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             // switch (_bookDetailsModel!.data!.paymentStatus
//                             //     .toString())
//                             // {
//                             //   case "1":
//                             //     //All chapters Api for free books
//                             //     Transitioner(
//                             //       context: context,
//                             //       child: BookAllPDFViewSceens(
//                             //         bookId: _bookDetailsModel!.data!.bookId
//                             //             .toString(),
//                             //         bookName: _bookDetailsModel!.data!.bookTitle
//                             //             .toString(),
//                             //         readerId: _bookDetailsModel!.data!.userId
//                             //             .toString(),
//                             //       ),
//                             //       animation:
//                             //           AnimationType.slideTop, // Optional value
//                             //       duration: Duration(
//                             //           milliseconds: 1000), // Optional value
//                             //       replacement: false, // Optional value
//                             //       curveType:
//                             //           CurveType.decelerate, // Optional value
//                             //     );
//                             //     break;
//                             //   case "2":
//                             //     if (_bookDetailsModel!.data!.userId
//                             //             .toString() ==
//                             //         context
//                             //             .read<UserProvider>()
//                             //             .UserID
//                             //             .toString()) {
//                             //       //paid book but this is the author of this book
//                             //       Transitioner(
//                             //         context: context,
//                             //         child: BookAllPDFViewSceens(
//                             //             bookId: _bookDetailsModel!.data!.bookId
//                             //                 .toString(),
//                             //             bookName: _bookDetailsModel!
//                             //                 .data!.bookTitle
//                             //                 .toString(),
//                             //             readerId: _bookDetailsModel!
//                             //                 .data!.userId
//                             //                 .toString()),
//                             //         animation: AnimationType
//                             //             .slideTop, // Optional value
//                             //         duration: Duration(
//                             //             milliseconds: 1000), // Optional value
//                             //         replacement: false, // Optional value
//                             //         curveType:
//                             //             CurveType.decelerate, // Optional value
//                             //       );
//                             //     } else {
//                             //       if (_subscriptionModelClass!.success ==
//                             //           true) {
//                             //         //Reader or Author Already Subscribe
//                             //         Transitioner(
//                             //           context: context,
//                             //           child: BookAllPDFViewSceens(
//                             //               bookId: _bookDetailsModel!
//                             //                   .data!.bookId
//                             //                   .toString(),
//                             //               bookName: _bookDetailsModel!
//                             //                   .data!.bookTitle
//                             //                   .toString(),
//                             //               readerId: _bookDetailsModel!
//                             //                   .data!.userId
//                             //                   .toString()),
//                             //           animation: AnimationType
//                             //               .slideTop, // Optional value
//                             //           duration: Duration(
//                             //               milliseconds: 1000), // Optional value
//                             //           replacement: false, // Optional value
//                             //           curveType: CurveType
//                             //               .decelerate, // Optional value
//                             //         );
//                             //       } else {
//                             //         if (Platform.isIOS) {
//                             //           SubscribeFunction();
//                             //         } else {
//                             //           Transitioner(
//                             //             context: context,
//                             //             child: StripePayment(
//                             //               bookId: _bookDetailsModel!
//                             //                   .data!.bookId
//                             //                   .toString(),
//                             //             ),
//                             //             animation: AnimationType
//                             //                 .slideLeft, // Optional value
//                             //             duration: Duration(
//                             //                 milliseconds:
//                             //                     1000), // Optional value
//                             //             replacement: false, // Optional value
//                             //             curveType: CurveType
//                             //                 .decelerate, // Optional value
//                             //           );
//                             //         }
//                             //       }
//                             //     }
//                             //     break;
//                             //   default:
//                             //     Constants.showToastBlack(
//                             //         context, "server busy please try again");
//                             //     break;
//                             // }
//
//                             Transitioner(
//                               context: context,
//                               child: BookViewTab(
//                                 bookId:
//                                     _bookDetailsModel!.data!.bookId.toString(),
//                                 bookName: _bookDetailsModel!.data!.bookTitle
//                                     .toString(),
//                                 readerId:
//                                     _bookDetailsModel!.data!.userId.toString(),
//                                 PaymentStatus: _bookDetailsModel!
//                                     .data!.paymentStatus
//                                     .toString(),
//                                 cover_url: _bookDetailsModel!.data!.imagePath
//                                     .toString(),
//                               ),
//                               animation:
//                                   AnimationType.slideTop, // Optional value
//                               duration: Duration(
//                                   milliseconds: 1000), // Optional value
//                               replacement: false, // Optional value
//                               curveType: CurveType.decelerate, // Optional value
//                             );
//                           },
//                           child: Container(
//                             width: _width * 0.7,
//                             height: _height * 0.05,
//                             decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(25)),
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: const Color(0x24000000),
//                                     offset: Offset(0, 7),
//                                     blurRadius: 14,
//                                     spreadRadius: 0)
//                               ],
//                               gradient: LinearGradient(
//                                   begin: Alignment(-0.01018629550933838,
//                                       -0.01894212305545807),
//                                   end: Alignment(
//                                       1.6960868120193481, 1.3281718730926514),
//                                   colors: [
//                                     Color(0xff246897),
//                                     Color(0xff1b4a6b),
//                                   ]),
//                             ),
//                             child: Center(
//                               child: Text(Languages.of(context)!.read,
//                                   style: const TextStyle(
//                                       color: const Color(0xffffffff),
//                                       fontWeight: FontWeight.w700,
//                                       fontFamily: "Lato",
//                                       fontStyle: FontStyle.normal,
//                                       fontSize: 14.0),
//                                   textAlign: TextAlign.center),
//
//                               // Text(
//                               //     _bookDetailsModel!.data!.paymentStatus
//                               //                     .toString() ==
//                               //                 "1" ||
//                               //             _bookDetailsModel!.data!.userId
//                               //                     .toString() ==
//                               //                 context
//                               //                     .read<UserProvider>()
//                               //                     .UserID
//                               //                     .toString()
//                               //         ? Languages.of(context)!.read
//                               //         : _subscriptionModelClass!.success == true
//                               //             ? Languages.of(context)!.read
//                               //             : Languages.of(context)!.subscribeTxt,
//                               //     style: const TextStyle(
//                               //         color: const Color(0xffffffff),
//                               //         fontWeight: FontWeight.w700,
//                               //         fontFamily: "Lato",
//                               //         fontStyle: FontStyle.normal,
//                               //         fontSize: 14.0),
//                               //     textAlign: TextAlign.center),
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _isSaved = !_isSaved;
//                               _SaveBookAPI();
//                             });
//                           },
//                           child: Container(
//                             width: _width * 0.13,
//                             height: _height * 0.12,
//                             decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(
//                                     color: const Color(0xff3a6c83), width: 1),
//                                 boxShadow: [
//                                   BoxShadow(
//                                       color: const Color(0x12000000),
//                                       offset: Offset(0, 7),
//                                       blurRadius: 14,
//                                       spreadRadius: 0),
//                                 ],
//                                 color: _isSaved
//                                     ? Color(0xff3a6c83)
//                                     : Color(0xfffafcfd)),
//                             child: _isSaved
//                                 ? Icon(
//                                     Icons.bookmark_border_outlined,
//                                     color: Colors.white,
//                                   )
//                                 : Icon(
//                                     Icons.bookmark_border_outlined,
//                                     color: Colors.black,
//                                   ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: _height * 0.05,
//                       child: _bannerAd != null
//                           ? Align(
//                               alignment: Alignment.bottomCenter,
//                               child: Container(
//                                 width: _bannerAd!.size.width.toDouble(),
//                                 height: _bannerAd!.size.height.toDouble(),
//                                 child: AdWidget(ad: _bannerAd!),
//                               ),
//                             )
//                           : Container(),
//                     )
//                   ],
//                 ),
//     );
//   }
//
//   Future _checkInternetConnection() async {
//     if (this.mounted) {
//       setState(() {
//         _isLoading = true;
//       });
//     }
//
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (!(connectivityResult == ConnectivityResult.mobile ||
//         connectivityResult == ConnectivityResult.wifi)) {
//       Constants.showToastBlack(context, "Internet not connected");
//       if (this.mounted) {
//         setState(() {
//           _isLoading = false;
//           _isInternetConnected = false;
//         });
//       }
//     } else {
//       _callBookDetailsAPI();
//     }
//   }
//
//   Future _callBookDetailsAPI() async {
//     setState(() {
//       _isInternetConnected = true;
//     });
//
//     var map = Map<String, dynamic>();
//     map['bookId'] = widget.bookID.toString();
//     final response = await http.post(
//       Uri.parse(
//         ApiUtils.BOOK_DETAIL_API,
//       ),
//       headers: {
//         'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
//       },
//       body: map,
//     );
//
//     if (response.statusCode == 200) {
//       print('BookDetail_response under 200 ${response.body}');
//       var jsonData = json.decode(response.body);
//       if (jsonData['status'] == 200) {
//         _bookDetailsModel = BookDetailsModel.fromJson(jsonData);
//         print("status_likes${_bookDetailsModel!.data!.status!.status}");
//         switch (_bookDetailsModel!.data!.status!.status) {
//           case 0:
//             _isLike = false;
//             _isDisLike = false;
//             break;
//           case 1:
//             _isLike = true;
//             _isDisLike = false;
//
//             break;
//           case 2:
//             _isLike = false;
//             _isDisLike = true;
//             break;
//         }
//         _isSaved = _bookDetailsModel!.data!.bookSaved!;
//         VariableProvider userProvider =
//             Provider.of<VariableProvider>(context, listen: false);
//
//         userProvider.setLikes(_bookDetailsModel!.data!.bookLike!);
//         userProvider.setDislikes(_bookDetailsModel!.data!.bookDisLike!);
//         print(
//             "likes_provider${context.read<VariableProvider>().getLikes.toString()}");
//         setState(() {
//           _isLoading = false;
//         });
//       } else {
//         // Constants.showToastBlack(context, "Some things went wrong");
//         Constants.warning(context);
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } else {
//       // Constants.showToastBlack(context, "Some things went wrong");
//       Constants.warning(context);
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future _LikesDisLikesAPI(String status) async {
//     var map = Map<String, dynamic>();
//     map['book_id'] = widget.bookID.toString();
//     // map['book_id'] = "9";
//     map['reader_id'] = "${context.read<UserProvider>().UserID}";
//     map['status'] = status.toString();
//     final response = await http.post(
//       Uri.parse(
//         ApiUtils.LIKES_AND_DISLIKES_API,
//       ),
//       headers: {
//         'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
//       },
//       body: map,
//     );
//
//     if (response.statusCode == 200) {
//       print('likesDislikes under 200 ${response.body}');
//       var jsonData = json.decode(response.body);
//       _likeDislikeModel = LikeDislikeModel.fromJson(jsonData);
//     } else {
//       Constants.showToastBlack(context, "Some things went wrong");
//     }
//   }
//
//   Future _SaveBookAPI() async {
//     var map = Map<String, dynamic>();
//     map['book_id'] = widget.bookID.toString();
//     final response = await http.post(
//       Uri.parse(
//         ApiUtils.SAVE_BOOK_API,
//       ),
//       headers: {
//         'Authorization': "Bearer ${context.read<UserProvider>().UserToken}",
//       },
//       body: map,
//     );
//
//     if (response.statusCode == 200) {
//       print('likesDislikes under 200 ${response.body}');
//       var jsonData = json.decode(response.body);
//       if (jsonData['status'] == 200) {
//         Constants.showToastBlack(context, jsonData['success']);
//       }
//     } else {
//       Constants.showToastBlack(context, "Some things went wrong");
//     }
//   }
//
//
//
// }
