import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert' as convert;
import 'package:http_auth/http_auth.dart';
import 'package:novelflex/MixScreens/PayPall/PaymentDoneScreen.dart';
import 'package:transitioner/transitioner.dart';

class PaypalServices {

  // String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
 String domain = "https://api.paypal.com"; // for production mode

  // change clientId and secret with your own, provided by paypal
  //Testing Sandbox credential
  // String clientId = 'AUlpcIex6VDXpuV_VFPQ3Q6SW4sdOWU3reCHlnjDCGLoixzGB1qFhbzWREOwak1nj2EHU8v7Zf-F-xW-';
  // String secret = 'EOb0DRB8lsW80p6_nu76ykrhxipKMHmyi_JiScPChHe4F6FEJN--UvwTuQUGCYcoPwu3S7YpDfVLAu6m';


  String clientId = 'Aa30YqNQrALXRkPyU1ZtL47aXOR2KDCDHenVVm4e3J9esa0dioQIjRr7AwOf6bnQuUjM6Uhi14z1QGmZ';
  String secret = 'EFpDcPpQhrWklTfvhMZVXfdkEdnploFCoCcClti26BTKicw0xP8cp8PFsmn5WtqF6n4rsav8yBdHlbgM';
  // for getting the access token from Paypal
  Future<String?> getAccessToken() async {
    try {
      var client = BasicAuthClient(clientId, secret);
      var response = await client.post(Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200) {
        final body = convert.jsonDecode(response.body);
        return body["access_token"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>?> createPaypalPayment(
      transactions, accessToken) async {
    try {
      var response = await http.post(Uri.parse("$domain/v1/payments/payment"),
          body: convert.jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 201) {
        if (body["links"] != null && body["links"].length > 0) {
          List links = body["links"];

          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approval_url",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"];
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"];
          }
          return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  // for executing the payment transaction
  Future<String?> executePayment(url, payerId, accessToken,BuildContext context) async {
    try {
      var response = await http.post(url,
          body: convert.jsonEncode({"payer_id": payerId}),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer ' + accessToken
          });

      final body = convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        Transitioner(
          context: context,
          child:PaymentDoneScreen(
          ),
          animation: AnimationType.slideLeft, // Optional value
          duration: Duration(milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
        return body["id"];
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }



}