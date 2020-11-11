import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Auth extends ChangeNotifier{

  int sum = 0;
  DateTime d = DateTime.now().subtract(Duration(days: 6));
  bool loading = false;
  List expenses;
  var usrdoc;
  String uid;
  Map auth;
  String lstr;
  String rstr;
  String url = "https://firestore.googleapis.com/v1beta1/projects/expense-manager-303f3/databases/(default)/documents/";
  bool checklogin = false;

  void lerrorstr(String s){
    lstr = s;
    notifyListeners();
  }

  void rerrorstr(String s){
    rstr = s;
    notifyListeners();
  }

  void loadingfun(bool load){
    loading = load;
    notifyListeners();
  }

  Future login(String email, String pass) async{
    loadingfun(true);
    final SharedPreferences pref = await SharedPreferences.getInstance();
    Map credential = {"email": email, "password": pass};
    await post(
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyBoddg4vYBPy-YMuYy2-V2fvgtAFg0LW3Q", 
      body: credential
    ).catchError((e){
      if(email == null || pass == null){
        loading = false;
        lerrorstr("Enter valid email and password");
      }
      else{
        loading = false;
        lerrorstr(e.toString());
      }
      notifyListeners();
    }).then((value) async{
      auth = jsonDecode(value.body);
      if(auth["localId"] == null){
        loading = false;
        lerrorstr("Enter valid email and password");
      }
      else{
        pref.setString("User Id", auth["localId"]);
        await getuserdata();
      }
    }).timeout(Duration(seconds: 20),onTimeout: (){
      loading = false;
      lerrorstr("Server Timed-Out");
    });
  }

  Future register(String email, String pass, String name, File img) async{
    loadingfun(true);
    String image = "";
    final SharedPreferences pref = await SharedPreferences.getInstance();
    Map credentials = {"email": email, "password": pass};
    await post(
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBoddg4vYBPy-YMuYy2-V2fvgtAFg0LW3Q",
      body: credentials
    ).catchError((e){
      loading = false;
      rerrorstr(e.toString());
    }).then((value) async{
      auth = jsonDecode(value.body);
      if(auth.containsKey("error")){
        if(auth["error"].containsValue("EMAIL_EXISTS")){
          loading = false;
          rerrorstr("Email already exists");
        }
      }
      else{
        img == null? image = "" : image = base64Encode(await img.readAsBytes());
        Map details = {"fields": {"Name": {"stringValue": name}, "Email": {"stringValue": email}, "Image": {"stringValue": image}}};
        await post(
          url+"Users?documentId="+auth["localId"],
          body: jsonEncode(details),
        );
        pref.setString("User Id", auth["localId"]);
        await getuserdata();
      }
    }).timeout(Duration(seconds: 20), onTimeout: () {
      loading = false;
      rerrorstr("Server Timed-Out");
    },);
  }

  Future getuserdata() async{
    //loadingfun(true);
    await SharedPreferences.getInstance().then((value) async{
      value.containsKey("User Id")? uid = value.getString("User Id") : uid = null;
      if(uid != null){
        await get(url+"Users/"+uid).then((value) async{
          usrdoc = jsonDecode(value.body);
          if(usrdoc.containsKey("error") && usrdoc["error"]["status"] == "NOT_FOUND"){
            await signOut();
          }
          else{
            await getdata();
          }
        });
      }
      else{
        loadingfun(false);
      }
    });
  }

  Future getalldata() async{
    loadingfun(true);
    sum = 0;
    await get(url+"Users/"+uid+"/Expenses").then((value) {
      expenses = jsonDecode(value.body)["documents"];
      if(expenses != null){
        expenses.sort((b,a)=> a["fields"]["Date"]["timestampValue"].compareTo(b["fields"]["Date"]["timestampValue"]));
        expenses.forEach((element) {
          sum = sum + int.parse(element["fields"]["Amount"]["integerValue"]);
        });
      }
      loadingfun(false);
    });
  }

  Future setdata(String purpose, double amount, DateTime date) async{
    loadingfun(true);
    Map details = {"fields": {"Purpose": {"stringValue": purpose}, "Amount": {"integerValue": amount}, "Date": {"timestampValue": date.toUtc().toIso8601String()}}};
    await post(
      url+"Users/"+uid+"/Expenses",
      body: jsonEncode(details)
    ).then((value) {
      if(date.compareTo(d) >= 0){
        expenses.add(jsonDecode(value.body));
        sum = sum + amount.toInt();
        if(expenses.length > 1){
          expenses.sort((b,a)=> a["fields"]["Date"]["timestampValue"].compareTo(b["fields"]["Date"]["timestampValue"]));
        }
      }
      loading = false;
      notifyListeners();
    });
  }

  Future signOut() async{
    loadingfun(true);
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("User Id");
    uid = null;
    auth = null;
    usrdoc = null;
    expenses = null;
    d = DateTime.now().subtract(Duration(days: 6));
    loading = false;
    notifyListeners();
  }

  Future deleteexp(String s, int pos) async{
    loadingfun(true);
    await delete(
      "https://firestore.googleapis.com/v1beta1/" + s
    ).whenComplete(() {
      sum = sum - int.parse(expenses[pos]["fields"]["Amount"]["integerValue"]);
      expenses.removeAt(pos);
      loading = false;
      notifyListeners();
    });
  }

  Future getdata() async{
    loadingfun(true);
    sum = 0;
    expenses = [];
    Map query = {
      "structuredQuery":{
        "select": {
          "fields": [
            {"fieldPath": "Purpose"},
            {"fieldPath": "Amount"},
            {"fieldPath": "Date"},
          ]
        },
        "from":[
          {"collectionId": "Expenses"}
        ],
        "where":{
          "fieldFilter":{
            "field":{
              "fieldPath": "Date"
            },
            "op": "GREATER_THAN_OR_EQUAL",
            "value": {"timestampValue": d.toUtc().toIso8601String()}
          }    
        }
      }
    };
    await post(
      url+"Users/"+uid+":runQuery",
      body: jsonEncode(query),
    ).then((value) {
      if(jsonDecode(value.body)[0].containsKey("document")){
        jsonDecode(value.body).forEach((value){
          expenses.add(value["document"]);
          sum = sum + int.parse(value["document"]["fields"]["Amount"]["integerValue"]);
        });
      }
    }).whenComplete(() {
      if(expenses.length > 1){
        expenses.sort((b,a)=> a["fields"]["Date"]["timestampValue"].compareTo(b["fields"]["Date"]["timestampValue"]));
      }
      loading = false;
      notifyListeners();
    });
  } 
}
