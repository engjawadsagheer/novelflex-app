import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novelflex/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:transitioner/transitioner.dart';
import '../../Provider/UserProvider.dart';
import '../../Utils/ApiUtils.dart';
import '../../Utils/toast.dart';

class PaymentDoneScreen extends StatefulWidget {
  const PaymentDoneScreen({Key? key}) : super(key: key);

  @override
  State<PaymentDoneScreen> createState() => _PaymentDoneScreenState();
}

class _PaymentDoneScreenState extends State<PaymentDoneScreen> {

  @override
  void initState() {
    Subscribe();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      body: Container(
        height: double.infinity,
        child: Center(
          child: CupertinoActivityIndicator(),
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
        ToastConstant.showToast(context, "Subscription Successful");
        print("subscribe done");
        Transitioner(
          context: context,
          child: TabScreen(),
          animation: AnimationType
              .slideLeft, // Optional value
          duration: Duration(
              milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType:
          CurveType.decelerate, // Optional value
        );
        // setState(() {
        //   _isLoading = false;
        // });
      } else {
        ToastConstant.showToast(context, jsonData1['message'].toString());
        // setState(() {
        //   _isLoading = false;
        // });
      }
    }
  }
}
