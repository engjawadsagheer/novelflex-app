import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:novelflex/MixScreens/WalletDirectory/withdrawPaymentScreen.dart';
import 'package:novelflex/tab_screen.dart';
import 'package:provider/provider.dart';
import 'package:transitioner/transitioner.dart';

import '../../Provider/UserProvider.dart';
import '../../localization/Language/languages.dart';

class UnlockWalletScreenOne extends StatefulWidget {
  const UnlockWalletScreenOne({Key? key}) : super(key: key);

  @override
  State<UnlockWalletScreenOne> createState() => _UnlockWalletScreenOneState();
}

class _UnlockWalletScreenOneState extends State<UnlockWalletScreenOne> {
  final Color kDarkBlueColor = Color(0xff3a6c83);
  String? cardNumber;
  String? cardHolderName;
  String? expMonth;
  String? expYear;
  String? cvV;
  String? amount= "3";

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return OnBoardingSlider(
      finishButtonText: Languages.of(context)!.confirmTxt,
      // finishButtonColor: kDarkBlueColor,
      onFinish: () {
        Transitioner(
          context: context,
          child: WithDrawPaymentScreen(),
          animation: AnimationType.fadeIn, // Optional value
          duration: Duration(milliseconds: 1000), // Optional value
          replacement: true, // Optional value
          curveType: CurveType.decelerate, // Optional value
        );
      },
      controllerColor: kDarkBlueColor,
      totalPage: 3,
      headerBackgroundColor: const Color(0xffebf5f9),
      pageBackgroundColor: const Color(0xffebf5f9),
      background: [
        Container(
          margin: EdgeInsets.only(
            left:_width*0.06
          ),
          padding: EdgeInsets.only(
            left:context.read<UserProvider>().SelectedLanguage=='English' ? _width*0.02 : 0.0,
            right:context.read<UserProvider>().SelectedLanguage=='Arabic' ? _width*0.02 : 0.0,
          ),
          alignment: Alignment.center,
          width: _width*0.85,
          height: _height*0.79,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(20)
              ),
              boxShadow: [BoxShadow(
                  color: const Color(0x14000000),
                  offset: Offset(0,5),
                  blurRadius: 14,
                  spreadRadius: 0
              )] ,
              color: const Color(0xffffffff)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: _height*0.15,
                  child: Image.asset("assets/quotes_data/extra_pngs/unlock_wallet.gif")),
              Padding(
                padding:  EdgeInsets.all(_width*0.05),
                child: Text(
                    Languages.of(context)!.wallet1,
                    style: const TextStyle(
                        color:  const Color(0xff3a6c83),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Neckar",
                        fontStyle:  FontStyle.normal,
                        fontSize: 14.0
                    ),
                    textAlign: TextAlign.center
                ),
              ),
              Opacity(
                opacity : 0.5,
                child:   Container(
                    width: 368,
                    height: 1,
                    decoration: BoxDecoration(
                        color: const Color(0xffbcbcbc)
                    )
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                          color: const Color(0xff676767)
                      )
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: _width*0.05,right: _width*0.05),
                    child: Text(
                             Languages.of(context)!.wallet1,
                        style: const TextStyle(
                            color:  const Color(0xff707070),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Alexandria",
                            fontStyle:  FontStyle.normal,
                        ),
                        overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff676767)
                      )
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: _width*0.05,right: _width*0.05),
                    child: Text(
                       Languages.of(context)!.wallet3,
                      style: const TextStyle(
                        color:  const Color(0xff707070),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Alexandria",
                        fontStyle:  FontStyle.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff676767)
                      )
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: _width*0.05,right: _width*0.05),
                    child: Text(
                      Languages.of(context)!.wallet4,
                      style: const TextStyle(
                        color:  const Color(0xff707070),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Alexandria",
                        fontStyle:  FontStyle.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff676767)
                      )
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: _width*0.05,right: _width*0.05),
                    child: Text(
                     Languages.of(context)!.wallet5,
                      style: const TextStyle(
                        color:  const Color(0xff707070),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Alexandria",
                        fontStyle:  FontStyle.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff676767)
                      )
                  ),
                  Padding(
                    padding:  EdgeInsets.only(left: _width*0.05,right: _width*0.05),
                    child: Text(
                      Languages.of(context)!.wallet6,
                      style: const TextStyle(
                        color:  const Color(0xff707070),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Alexandria",
                        fontStyle:  FontStyle.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  )
                ],
              ),



            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: _width*0.06),
          padding: EdgeInsets.only(left: _width*0.02),
          alignment: Alignment.center,
          width: _width*0.85,
          height: _height*0.79,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(20)
              ),
              boxShadow: [BoxShadow(
                  color: const Color(0x14000000),
                  offset: Offset(0,5),
                  blurRadius: 14,
                  spreadRadius: 0
              )] ,
              color: const Color(0xffffffff)
          ),
          child: Column(
            children: [
              SizedBox(height: _height*0.05,),
              SizedBox(
                  height: _height*0.15,
                  child: Image.asset("assets/quotes_data/dollar_icon.png")),
              SizedBox(height: _height*0.03,),
              Padding(
                padding:  EdgeInsets.all(_width*0.05),
                child: Text(
                      Languages.of(context)!.EAccount1,
                      style: const TextStyle(
                          color:  const Color(0xff2a2a2a),
                          fontWeight: FontWeight.w700,
                          fontFamily: "Neckar",
                          fontStyle:  FontStyle.normal,
                          fontSize: 16.0
                      ),
                      textAlign: TextAlign.center
                  ),
            
              ),
              SizedBox(height: _height*0.05,),
              Opacity(
                opacity : 0.5,
                child:   Container(
                    width: 368,
                    height: 1,
                    decoration: BoxDecoration(
                        color: const Color(0xffbcbcbc)
                    )
                ),
              ),
              SizedBox(height: _height*0.05,),
              Expanded(
                child:      Text(
                    Languages.of(context)!.EAccount2,
                    style: const TextStyle(
                        color:  const Color(0xff707070),
                        fontWeight: FontWeight.w400,
                        fontFamily: "Alexandria",
                        fontStyle:  FontStyle.normal,
                        fontSize: 14.0
                    ),
                    textAlign: TextAlign.center
                ),
              )


            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: _width*0.06),
          padding: EdgeInsets.only(left: _width*0.02),
          alignment: Alignment.center,
          width: _width*0.85,
          height: _height*0.79,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(20)
              ),
              boxShadow: [BoxShadow(
                  color: const Color(0x14000000),
                  offset: Offset(0,5),
                  blurRadius: 14,
                  spreadRadius: 0
              )] ,
              color: const Color(0xffffffff)
          ),
          child: Column(
            children: [
              SizedBox(height: _height*0.05,),
              SizedBox(
                  height: _height*0.15,
                  child: Image.asset("assets/quotes_data/dollar_icon.png")),
              SizedBox(height: _height*0.03,),
              Padding(
                padding:  EdgeInsets.all(_width*0.05),
                child: Text(
                    Languages.of(context)!.FinsihAllsteps,
                    style: const TextStyle(
                        color:  const Color(0xff2a2a2a),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Neckar",
                        fontStyle:  FontStyle.normal,
                        fontSize: 16.0
                    ),
                    textAlign: TextAlign.center
                ),
              ),
              SizedBox(height: _height*0.05,),
              Opacity(
                opacity : 0.5,
                child:   Container(
                    width: 368,
                    height: 1,
                    decoration: BoxDecoration(
                        color: const Color(0xffbcbcbc)
                    )
                ),
              ),
              SizedBox(height: _height*0.05,),
              SizedBox(
                  height: _height*0.15,
                  child: Image.asset("assets/quotes_data/done_calping.jpeg")),


            ],
          ),
        ),
      ],
      speed: 2.8,
      pageBodies: [
        Container(),
        Container(),
        Container(),
      ],
    );
  }
}




  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return  Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      appBar: AppBar(
        backgroundColor: const Color(0xffebf5f9),
        title: Text(
            Languages.of(context)!.unlockWallet,
            style: const TextStyle(
                color:  const Color(0xff2a2a2a),
                fontWeight: FontWeight.w700,
                fontFamily: "Alexandria",
                fontStyle:  FontStyle.normal,
                fontSize: 14.0
            ),
            textAlign: TextAlign.left
        ),
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
      body: Center(
        child: Container(
            width: _width*0.8,
            height: _height*0.79,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(20)
                ),
                boxShadow: [BoxShadow(
                    color: const Color(0x14000000),
                    offset: Offset(0,5),
                    blurRadius: 14,
                    spreadRadius: 0
                )] ,
                color: const Color(0xffffffff)
            ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/quotes_data/extra_pngs/unlock_wallet.gif"),
              Text(
                  "Conditions for applying to activate the wallet and reap profits from ads",
                  style: const TextStyle(
                      color:  const Color(0xff3a6c83),
                      fontWeight: FontWeight.w700,
                      fontFamily: "Neckar",
                      fontStyle:  FontStyle.normal,
                      fontSize: 16.0
                  ),
                  textAlign: TextAlign.center
              ),
              Opacity(
                opacity : 0.5,
                child:   Container(
                    width: 368,
                    height: 1,
                    decoration: BoxDecoration(
                        color: const Color(0xffbcbcbc)
                    )
                ),
              ),
              Row(
                children: [
                  Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: const Color(0xff676767)
                      )
                  ),
                   Text(
                "If it is a novel, the percentage of views is more than 200, with at least 100 pages.",
                style: const TextStyle(
            color:  const Color(0xff707070),
            fontWeight: FontWeight.w400,
            fontFamily: "Alexandria",
            fontStyle:  FontStyle.normal,
            fontSize: 14.0
        ),
          textAlign: TextAlign.left
      )
                ],
              ),
              Row(
                children: [
                  Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: const Color(0xff676767)
                      )
                  ),
            Text(
                "If it is a manga, it must have obtained more than 200 views for all chapters together with at least 6 ",
            style: const TextStyle(
            color:  const Color(0xff707070),
            fontWeight: FontWeight.w400,
            fontFamily: "Alexandria",
            fontStyle:  FontStyle.normal,
            fontSize: 14.0
        ),
          textAlign: TextAlign.left
      )
                ],
              ),
              Row(
                children: [
                  Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: const Color(0xff676767)
                      )
                  ),
            Text(
                "If it is a manga, it must have obtained more than 200 views for all chapters together with at least 6 chapters and each chapter is 18 pages with a cover.",

                style: const TextStyle(
            color:  const Color(0xff707070),
            fontWeight: FontWeight.w400,
            fontFamily: "Alexandria",
            fontStyle:  FontStyle.normal,
            fontSize: 14.0
        ),
          textAlign: TextAlign.left
      )
                ],
              ),
              Row(
                children: [
                  Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                          color: const Color(0xff676767)
                      )
                  ),
            Text(
                "It is ensured that the works are not stolen or quoted from other authors",
                style: const TextStyle(
            color:  const Color(0xff707070),
            fontWeight: FontWeight.w400,
            fontFamily: "Alexandria",
            fontStyle:  FontStyle.normal,
            fontSize: 14.0
        ),
          textAlign: TextAlign.left
      )
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }
