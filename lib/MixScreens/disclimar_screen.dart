import 'package:flutter/material.dart';

import '../Utils/Constants.dart';
import '../localization/Language/languages.dart';
class DisclimarScreen extends StatelessWidget {
  const DisclimarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
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
        child: Padding(
          padding:  EdgeInsets.only(top:_height*0.02,left: _height*0.03,right:_height*0.03 ),
          child: Center(
            child: Text(Languages.of(context)!.disclaimer,style: TextStyle(
              fontSize: 23.0,
              fontFamily: Constants.fontfamily
            ),),
          ),
        ),
      ),
    );
  }
}
