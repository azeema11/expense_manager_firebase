import 'package:expense_manager_firebase/Pages/home.dart';
import 'package:expense_manager_firebase/Pages/login.dart';
import 'package:expense_manager_firebase/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget{

  _Wrap createState() => _Wrap();
}

class _Wrap extends State<Wrapper>{

  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    final wo = Provider.of<Auth>(context);
    if (wo.uid == null){
      return Login();
    }
    else{
      return Home();
    }
  }
}