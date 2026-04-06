import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../Provider/UserProvider.dart';
import '../localization/Language/languages.dart';

class Constants {
  static const fontfamily = 'ProximaNovaAlt';


  static void showToastBlack(BuildContext context, String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      textColor: Colors.white,
      backgroundColor: Colors.black,
      fontSize: 14,
    );
  }

  static Widget  InternetNotConnected(double height) {
    return Container(
      height:height,
      alignment: Alignment.center,
      color: Color(0xFF256D85),
      // padding: EdgeInsets.all(16.0),
      child: Text(
        "Check your Internet Connection",
        style: TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }

  static void warning(context) {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        animType: QuickAlertAnimType.slideInUp,
        autoCloseDuration: Duration(seconds: 5),
        title: 'Oops...',
        text: 'Sorry, something went wrong',
        confirmBtnColor: Color(0xFF256D85),
        confirmBtnText: Languages.of(context)!.okText
    );

  }

}
