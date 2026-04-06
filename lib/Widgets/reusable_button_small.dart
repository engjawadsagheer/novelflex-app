import 'package:flutter/material.dart';

import '../Utils/Constants.dart';

class ResuableMaterialButtonSmall extends StatelessWidget {
  ResuableMaterialButtonSmall({
    Key? key,
    required this.onpress,
    required this.buttonname,
  }) : super(key: key);

   var onpress;
   var  buttonname;

  @override
  Widget build(BuildContext context) {

    var height= MediaQuery.of(context).size.height;
    var width= MediaQuery.of(context).size.width;
    return MaterialButton(
      minWidth: width*0.9,
      height: height*0.06,
      onPressed: onpress,
      child:  Container(
          width: width*0.9,
          height: height*0.06,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
                begin: Alignment(-0.01018629550933838,
                    -0.01894212305545807),
                end: Alignment(1.6960868120193481,
                    1.3281718730926514),
                colors: [
                  Color(0xff246897),
                  Color(0xff1b4a6b),
                ]),
          ),
          child: Center(child: Text(buttonname,style: TextStyle(color: Colors.white,fontSize:width*0.04,fontFamily: Constants.fontfamily, ),)))
    );
  }
}