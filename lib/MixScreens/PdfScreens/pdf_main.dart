import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
import 'package:pdfx/pdfx.dart';
import 'dart:io';

import '../../Widgets/loading_widgets.dart';
import '../../localization/Language/languages.dart';

class PinchPage extends StatefulWidget {
  String url;
  String name;
   PinchPage({Key? key, required this.url, required this.name}) : super(key: key);

  @override
  State<PinchPage> createState() => _PinchPageState();
}

enum DocShown { sample, tutorial, hello, password }

class _PinchPageState extends State<PinchPage> {
  static const int _initialPage = 1;
  DocShown _showing = DocShown.sample;
  late PdfControllerPinch _pdfControllerPinch;

  @override
  void initState() {
    _pdfControllerPinch = PdfControllerPinch(
      // document: PdfDocument.openAsset('assets/hello.pdf'),
      document: PdfDocument.openData(
        InternetFile.get(
          widget.url,
        ),
      ),
      initialPage: _initialPage,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfControllerPinch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:  const Color(0xffebf5f9),
         appBar:  Platform.isIOS ? AppBar(
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
      ) : AppBar(
           backgroundColor:  Colors.white,
           leading: Container(),
           toolbarHeight: 0.0,
         ),
      // appBar: AppBar(
      //   title: const Text('Pdfx example'),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: const Icon(Icons.navigate_before),
      //       onPressed: () {
      //         _pdfControllerPinch.previousPage(
      //           curve: Curves.ease,
      //           duration: const Duration(milliseconds: 100),
      //         );
      //       },
      //     ),
      //     PdfPageNumber(
      //       controller: _pdfControllerPinch,
      //       builder: (_, loadingState, page, pagesCount) => Container(
      //         alignment: Alignment.center,
      //         child: Text(
      //           '$page/${pagesCount ?? 0}',
      //           style: const TextStyle(fontSize: 22),
      //         ),
      //       ),
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.navigate_next),
      //       onPressed: () {
      //         _pdfControllerPinch.nextPage(
      //           curve: Curves.ease,
      //           duration: const Duration(milliseconds: 100),
      //         );
      //       },
      //     ),
      //     IconButton(
      //       icon: const Icon(Icons.refresh),
      //       onPressed: () {
      //         switch (_showing) {
      //           case DocShown.sample:
      //           case DocShown.tutorial:
      //             _pdfControllerPinch.loadDocument(
      //                 PdfDocument.openAsset('assets/flutter_tutorial.pdf'));
      //             _showing = DocShown.hello;
      //             break;
      //           case DocShown.hello:
      //             _pdfControllerPinch
      //                 .loadDocument(PdfDocument.openAsset('assets/hello.pdf'));
      //             _showing = UniversalPlatform.isWeb
      //                 ? DocShown.password
      //                 : DocShown.tutorial;
      //             break;
      //
      //           case DocShown.password:
      //             _pdfControllerPinch.loadDocument(PdfDocument.openAsset(
      //               'assets/password.pdf',
      //               password: 'MyPassword',
      //             ));
      //             _showing = DocShown.tutorial;
      //             break;
      //         }
      //       },
      //     )
      //   ],
      // ),
      body: PdfViewPinch(
        builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(),
          documentLoaderBuilder: (_) =>
              Center(child: CustomCard(
                gif: MoreLoadingGif(
                  type: MoreLoadingGifType.eclipse,
                  size: _height * _width * 0.0002,
                ),
                text: 'Loading',
              )),
          pageLoaderBuilder: (_) =>
           Center(child: CustomCard(
            gif: MoreLoadingGif(
              type: MoreLoadingGifType.eclipse,
              size: _height * _width * 0.0002,
            ),
            text: 'Loading',
          )),
          errorBuilder: (_, error) => Center(child:  Padding(
            padding: EdgeInsets.only(top: _height * 0.4),
            child: Center(
              child: Text(
                Languages.of(context)!.nodata,
                style: const TextStyle(
                    color: const Color(0xff3a6c83),
                    fontWeight: FontWeight.w700,
                    fontFamily: "Lato",
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0),
              ),
            ),
          ))),
        controller: _pdfControllerPinch,
      ),
    );
  }
}