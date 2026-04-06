//
// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:intl_phone_field/phone_number.dart';
// import '../../Utils/toast.dart';
// import '../../localization/Language/languages.dart';
// import 'ResetPasswordScreen.dart';
//
// class ForgetPasswordScreen extends StatefulWidget {
//   @override
//   _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
// }
//
// class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
//   GlobalKey<FormState> _formKey = GlobalKey();
//
//   TextEditingController textController = TextEditingController();
//   String countryCode = "+971";
//   var phoneNumber;
//
//   @override
//   Widget build(BuildContext context) {
//     var _height = MediaQuery.of(context).size.height;
//     var _width = MediaQuery.of(context).size.width;
//     return Scaffold(
//         backgroundColor: const Color(0xffebf5f9),
//         appBar: AppBar(
//           toolbarHeight: _height*0.1,
//           backgroundColor: const Color(0xffebf5f9),
//           title: Text(Languages.of(context)!.forgetPassword,
//             style: const TextStyle(
//                 color:  const Color(0xff002333),
//                 fontWeight: FontWeight.w700,
//                 fontFamily: "Lato",
//                 fontStyle:  FontStyle.normal,
//                 fontSize: 14.0
//             ),),
//           centerTitle: true,
//           elevation: 0.0,
//           leading: IconButton(
//               onPressed: (){
//
//                 Navigator.pop(context);
//               },
//               icon: Icon(Icons.arrow_back_ios,size: _height*0.03,color: Colors.black54,)),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 IntlPhoneField(
//                   controller: textController,
//                   decoration: InputDecoration(
//                     labelText: Languages.of(context)!.phoneNumber,
//
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(
//                           color: Color(0xFF256D85)
//                       ),
//                       borderRadius: BorderRadius.circular(10),
//
//                     ),
//
//
//                   ),
//                   cursorColor: Color(0xFF256D85),
//                   onChanged: (phone) {
//                     print(phone.completeNumber);
//                     // if(phone.completeNumber.length==13){
//                       phoneNumber=phone.completeNumber;
//                     //   Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyPhoneNumberScreen(phoneNumber: phone.completeNumber,)));
//                     //
//                     // }
//
//                  },
//                   initialCountryCode: 'AE',
//                   onCountryChanged: (country) {
//                     print('Country changed to: ' + country.name);
//                     countryCode = country.code;
//                   },
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Center(
//                   child: MaterialButton(
//                     child: Text(Languages.of(context)!.verify),
//                     color: const Color(0xFF256D85),
//                     textColor: Colors.white,
//                     onPressed: () {
//                       // ;
//                       if(textController.text.isNotEmpty){
//                         Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyPhoneNumberScreen(phoneNumber: phoneNumber.toString().trim(),)));
//                         print("phoneNumber ${phoneNumber}");
//                       }else{
//                         ToastConstant.showToast(context, "Enter Phone Number");
//                       }
//
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//
//   }
// }
//
