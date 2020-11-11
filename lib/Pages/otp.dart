import 'package:flutter/material.dart';
import 'package:flutter_otp/flutter_otp.dart';

class Otp extends StatefulWidget{

  _Otp createState() => _Otp();
}

class _Otp extends State<Otp>{

  int otp;
  String pno;
  String s = "";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              onChanged: (value) => pno = value,
            ),
            RaisedButton(
              onPressed: (){
                FlutterOtp().sendOtp(
                  pno,
                  "OTP is : ",
                  1000,
                  9999,
                  "+91",
                );
              },
            ),
            TextFormField(
              onChanged: (value) => otp = int.parse(value),
            ),
            RaisedButton(
              onPressed: (){
                if(FlutterOtp().resultChecker(otp)){
                  s = "Otp correct";
                }
                else{
                  s = "Otp incorrect";
                }
                setState(() {});
              },
            ),
            Text(s),
          ],
        ),
      ),
    );
  }
}