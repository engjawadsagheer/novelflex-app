// import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:more_loading_gif/more_loading_gif.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'dart:io';
//
// import '../Widgets/loading_widgets.dart';
//
// class PdfScreen extends StatefulWidget {
//   String? url;
//   String? name;
//   PdfScreen({required this.url, required this.name});
//
//   @override
//   State<PdfScreen> createState() => _PdfScreenState();
// }
//
// class _PdfScreenState extends State<PdfScreen> {
//   late final WebViewController controller;
//   bool _isLoading = true;
//   PDFDocument? document;
//   bool _usePDFListView = false;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Color(0xffebf5f9))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {},
//           onPageStarted: (String url) {},
//           onPageFinished: (String url) {
//             setState(() {
//               _isLoading = false;
//             });
//           },
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) {
//             if (request.url.startsWith('https://www.youtube.com/')) {
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(widget.url!.indexOf('.pdf') != -1
//           ? Uri.parse(
//               'https://docs.google.com/gview?embedded=true&url=${widget.url}')
//           : Uri.parse(widget.url.toString()));
//     // changePDF();
//   }
//
//   changePDF() async {
//     setState(() => _isLoading = true);
//     document = await PDFDocument.fromURL(widget.url.toString());
//     setState(() => _isLoading = false);
//   }
//
//   @override
//   void dispose() {
//     document = null;
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var _height = MediaQuery.of(context).size.height;
//     var _width = MediaQuery.of(context).size.width;
//     return Platform.isIOS
//         ? Scaffold(
//             backgroundColor: Color(0xffebf5f9),
//             appBar: AppBar(
//               backgroundColor: const Color(0xffebf5f9),
//               elevation: 0.0,
//               leading: IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(
//                     Icons.arrow_back_ios,
//                     color: Colors.black54,
//                     size: _height * _width * 0.00007,
//                   )),
//               toolbarHeight: _height * 0.05,
//             ),
//             body: Stack(
//               children: [
//                 WebViewWidget(controller: controller),
//                 _isLoading
//                     ? Center(
//                         child: CustomCard(
//                           gif: MoreLoadingGif(
//                             type: MoreLoadingGifType.eclipse,
//                             size: _height * _width * 0.0002,
//                           ),
//                           text: 'Loading',
//                         ),
//                       )
//                     : Stack(),
//               ],
//             ),
//
//             // Center(
//             //         child: _isLoading
//             //             ? const Center(
//             //                 child: CupertinoActivityIndicator(
//             //                 ),
//             //               )
//             //             : SafeArea(
//             //                 child: Stack(
//             //                   children: [
//             //                     PDFViewer(
//             //                       document: document!,
//             //                       zoomSteps: 1,
//             //                       indicatorBackground: const Color(0xFF256D85),
//             //                       lazyLoad: false,
//             //                       scrollDirection: Axis.vertical,
//             //                       showPicker: true,
//             //                       progressIndicator: CupertinoActivityIndicator(),
//             //                       pickerButtonColor: const Color(0xFF256D85),
//             //                       showNavigation: true,  navigationBuilder:
//             //                       (context, page, totalPages, jumpToPage, animateToPage) {
//             //                     return Container(
//             //                       color: Colors.white,
//             //                       child: ButtonBar(
//             //
//             //                         alignment: MainAxisAlignment.spaceEvenly,
//             //                         children: <Widget>[
//             //                           IconButton(
//             //                             icon: Icon(Icons.first_page,color: const Color(0xFF256D85),),
//             //                             onPressed: () {
//             //                               jumpToPage(page: 0);
//             //                               // _controller!.clear();
//             //                               // Navigator.pop(context);
//             //                             },
//             //                           ),
//             //                           IconButton(
//             //                             icon: Icon(Icons.arrow_back_ios,color: const Color(0xFF256D85),),
//             //                             onPressed: () {
//             //                               animateToPage(page: page! - 2);
//             //                             },
//             //                           ),
//             //
//             //                           IconButton(
//             //                             icon: Icon(Icons.arrow_forward_ios,color: const Color(0xFF256D85),),
//             //                             onPressed: () {
//             //                               animateToPage(page: page);
//             //                             },
//             //                           ),
//             //                           IconButton(
//             //                             icon: Icon(Icons.last_page,color: const Color(0xFF256D85),),
//             //                             onPressed: () {
//             //                               jumpToPage(page: totalPages! - 1);
//             //                             },
//             //                           ),
//             //                         ],
//             //                       ),
//             //                     );
//             //                   },
//             //                     ),
//             //                     Positioned(
//             //                         top: _height * 0.03,
//             //                         left: _width * 0.05,
//             //                         child: GestureDetector(
//             //                             onTap: () {
//             //                               Navigator.pop(context);
//             //                             },
//             //                             child: Icon(
//             //                               Icons.arrow_back_ios,
//             //                               color: Color(0xFF256D85),
//             //                             )))
//             //                   ],
//             //                 ),
//             //               ),
//             //       )
//           )
//         : Scaffold(
//             backgroundColor: Color(0xffebf5f9),
//             body: SafeArea(
//               child: Stack(
//                 children: [
//                   WebViewWidget(controller: controller),
//                   _isLoading
//                       ? Center(
//                           child: CustomCard(
//                             gif: MoreLoadingGif(
//                               type: MoreLoadingGifType.eclipse,
//                               size: _height * _width * 0.0002,
//                             ),
//                             text: 'Loading',
//                           ),
//                         )
//                       : Stack(),
//                 ],
//               ),
//             ),
//
//             // Center(
//             //         child: _isLoading
//             //             ? const Center(
//             //                 child: CupertinoActivityIndicator(
//             //                 ),
//             //               )
//             //             : SafeArea(
//             //                 child: Stack(
//             //                   children: [
//             //                     PDFViewer(
//             //                       document: document!,
//             //                       zoomSteps: 1,
//             //                       indicatorBackground: const Color(0xFF256D85),
//             //                       lazyLoad: false,
//             //                       scrollDirection: Axis.vertical,
//             //                       showPicker: true,
//             //                       progressIndicator: CupertinoActivityIndicator(),
//             //                       pickerButtonColor: const Color(0xFF256D85),
//             //                       showNavigation: true,  navigationBuilder:
//             //                       (context, page, totalPages, jumpToPage, animateToPage) {
//             //                     return Container(
//             //                       color: Colors.white,
//             //                       child: ButtonBar(
//             //
//             //                         alignment: MainAxisAlignment.spaceEvenly,
//             //                         children: <Widget>[
//             //                           IconButton(
//             //                             icon: Icon(Icons.first_page,color: const Color(0xFF256D85),),
//             //                             onPressed: () {
//             //                               jumpToPage(page: 0);
//             //                               // _controller!.clear();
//             //                               // Navigator.pop(context);
//             //                             },
//             //                           ),
//             //                           IconButton(
//             //                             icon: Icon(Icons.arrow_back_ios,color: const Color(0xFF256D85),),
//             //                             onPressed: () {
//             //                               animateToPage(page: page! - 2);
//             //                             },
//             //                           ),
//             //
//             //                           IconButton(
//             //                             icon: Icon(Icons.arrow_forward_ios,color: const Color(0xFF256D85),),
//             //                             onPressed: () {
//             //                               animateToPage(page: page);
//             //                             },
//             //                           ),
//             //                           IconButton(
//             //                             icon: Icon(Icons.last_page,color: const Color(0xFF256D85),),
//             //                             onPressed: () {
//             //                               jumpToPage(page: totalPages! - 1);
//             //                             },
//             //                           ),
//             //                         ],
//             //                       ),
//             //                     );
//             //                   },
//             //                     ),
//             //                     Positioned(
//             //                         top: _height * 0.03,
//             //                         left: _width * 0.05,
//             //                         child: GestureDetector(
//             //                             onTap: () {
//             //                               Navigator.pop(context);
//             //                             },
//             //                             child: Icon(
//             //                               Icons.arrow_back_ios,
//             //                               color: Color(0xFF256D85),
//             //                             )))
//             //                   ],
//             //                 ),
//             //               ),
//             //       )
//           );
//   }
// }
