import 'package:expense_manager_firebase/Pages/home.dart';
import 'package:expense_manager_firebase/Pages/login.dart';
import 'package:expense_manager_firebase/Pages/register.dart';
import 'package:expense_manager_firebase/Pages/splash.dart';
import 'package:expense_manager_firebase/Pages/wrap.dart';
import 'package:expense_manager_firebase/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(create: (context) => Auth(),)
      ],
      child: MaterialApp(
        title: 'Expenses',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          primaryColor: Colors.blueGrey[800],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: "/",
        routes: {
          "/" : (context) => Splash(),
          "/w" : (context) => Wrapper(),
          "/l" : (context) => Login(),
          "/h" : (context) => Home(),
          "/r" : (context) => Register(),
        },
      ),
    );
  }
}
