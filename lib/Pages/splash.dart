import 'package:expense_manager_firebase/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  void loadingtime() async{
    await Future.delayed(Duration(seconds: 3), () {
      setState(() {
        Navigator.popAndPushNamed(context, "/w");
      });
    });
  }

  @override
  void initState(){
    super.initState();
    loadingtime();
  }

  @override
  Widget build(BuildContext context) {
    final so = Provider.of<Auth>(context);
    if(so.loading == true){
      so.getuserdata();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height/11,),
            Container(
              height: MediaQuery.of(context).size.height/3.5,
              width: MediaQuery.of(context).size.width/3,
              child: Image.asset(
                'assets/rupee.jpeg',
                fit: BoxFit.contain,
              ),
            ),
            Text(
              "Expense Manager",
              style: TextStyle(
                fontSize: 40.0,
                color: Colors.white
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height/3,),
            SpinKitFadingCube(
              color: Colors.grey[300],
              size: MediaQuery.of(context).size.height/19,
            ),
          ],
        ),
      ),
    );
  }
}