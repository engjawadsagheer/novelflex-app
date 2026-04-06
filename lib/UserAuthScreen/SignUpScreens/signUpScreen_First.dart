import 'dart:convert';

import 'package:custom_signin_buttons/button_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:novelflex/UserAuthScreen/login_screen.dart';
import '../../localization/Language/languages.dart';
import 'SignUpScreen_Second.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

GoogleSignIn _googleSignIn = GoogleSignIn(
  // Optional clientId
  // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class SignUpScreen_First extends StatefulWidget {
  const SignUpScreen_First({Key? key}) : super(key: key);

  @override
  State<SignUpScreen_First> createState() => _SignUpScreen_FirstState();
}

class _SignUpScreen_FirstState extends State<SignUpScreen_First> {

  final plugin = FacebookLogin(debug: true);
  FacebookLogin? pluginf;

  String? _sdkVersion;
   FacebookAccessToken? _token;
   FacebookUserProfile? _profile;
   String? _email;
   String? _imageUrl;


   Future<void> _onPressedLogInButton() async {
     await plugin.logIn(permissions: [
       // FacebookPermission.publicProfile,
       FacebookPermission.email,
     ]);
     await _updateLoginInfo();
   }

   Future<void> _getSdkVersion() async {
     final sdkVersion = await plugin.sdkVersion;
     setState(() {
       _sdkVersion = sdkVersion;
     });
   }

   Future<void> _updateLoginInfo() async {
      final plugin = pluginf;
     final token = await plugin!.accessToken;
     FacebookUserProfile? profile;
     String? email;
     String? imageUrl;

     if (token != null) {
       profile = await plugin.getUserProfile();
       if (token.permissions.contains(FacebookPermission.email.name)) {
         email = await plugin.getUserEmail();
       }
       imageUrl = await plugin.getProfileImageUrl(width: 100);
     }

     setState(() {
       _token = token;
       _profile = profile;
       _email = email;
       _imageUrl = imageUrl;
     });
   }




  GoogleSignInAccount? _currentUser;
  String _contactText = '';

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleGetContact(_currentUser!);
      }
    });
    _googleSignIn.signInSilently();
    _getSdkVersion();
    _updateLoginInfo();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
    json.decode(response.body) as Map<String, dynamic>;
    final String? namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  String? _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic>? connections = data['connections'] as List<dynamic>?;
    final Map<String, dynamic>? contact = connections?.firstWhere(
          (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>?;
    if (contact != null) {
      final Map<String, dynamic>? name = contact['names'].firstWhere(
            (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>?;
      if (name != null) {
        return name['displayName'] as String?;
      }
    }
    return null;
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final GoogleSignInAccount? user = _currentUser;

    return  Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus &&
                currentFocus.focusedChild != null) {
              currentFocus.focusedChild!.unfocus();
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: [
              mainText2(width),
              SizedBox(
                height: height*0.1,
                width: width*0.6,
                child: Image.asset('assets/quotes_data/NoPath.png',fit: BoxFit.cover,),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSignInButton(
                    text: 'Sign In With Email',
                    customIcon: Icons.email,
                    iconLeftPadding: width*0.06,
                    iconSize: height*width*0.0001,
                    height: height*0.075,
                    width: width*0.85,
                    iconTopPadding: height*0.01,
                    buttonColor: Color(0xff3a6c83),
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    mini: false,
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  SignUpScreen_Second(ReferralUserID: "",)));
                    },
                  ),
                  SizedBox(height: height*0.02,),
                  CustomSignInButton(
                    text: 'Sign In With Gmail',
                    height: height*0.075,
                    iconSize: height*width*0.00015,
                    width: width*0.85,
                    iconLeftPadding: width*0.04,
                    customIcon: Icons.g_mobiledata_outlined,
                    buttonColor: Color(0xfff14336),
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    mini: false,
                    onPressed: (){
                      _handleSignIn();
                    },
                  ),
                  SizedBox(height: height*0.02,),
                  CustomSignInButton(
                    text: 'Sign In With Facebook',
                    customIcon: Icons.facebook_outlined,
                    height: height*0.075,
                    width: width*0.85,
                    iconLeftPadding: width*0.055,
                    iconTopPadding: 5,
                    iconSize: height*width*0.0001,
                    buttonColor: Color(0xff2275e9),
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    mini: false,
                    onPressed: (){
                      _onPressedLogInButton();
                    },
                  ),
                  SizedBox(height: height*0.02,),
                  Platform.isIOS ? CustomSignInButton(
                    text: 'Sign In With Apple',
                    customIcon: Icons.apple,
                    height: height*0.075,
                    width: width*0.85,
                    iconLeftPadding: width*0.055,
                    iconSize: height*width*0.0001,
                    iconTopPadding: 5,
                    buttonColor: Color(0xff1e1e1e),
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    mini: false,
                  ) : Container(
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: height * 0.02,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      Languages.of(context)!.alreadyhaveAccountSignIn,
                      style: const TextStyle(
                          color:  const Color(0xff002333),
                          fontWeight: FontWeight.w400,
                          fontFamily: "Lato",
                          fontStyle:  FontStyle.normal,
                          fontSize: 14.0
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget mainText2(var width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Languages.of(context)!.signup,
          style: const TextStyle(
              color:  const Color(0xff002333),
              fontWeight: FontWeight.w700,
              fontFamily: "Lato",
              fontStyle:  FontStyle.normal,
              fontSize: 14.0
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
