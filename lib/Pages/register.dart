import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:expense_manager_firebase/Services/auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget{

  _Register createState() => _Register();
}

class _Register extends State<Register>{

  File img;
  String email;
  String password;
  String name;  
  int val = 0;
  final formkey = GlobalKey<FormState>();
  FocusNode f1 = new FocusNode();
  FocusNode f2 = new FocusNode();
  FocusNode f3 = new FocusNode();
  FocusNode f4 = new FocusNode();
  final imagepicker = ImagePicker();

  Future photo(BuildContext context, ImageSource ims) async{
    var picker = await imagepicker.getImage(source: ims).then((pickedFile) => pickedFile.path).catchError((e){});
    var pick = picker == null? null:File(picker);
    if(pick != null){
      pick = await ImageCropper.cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: pick.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
          toolbarColor: Colors.green[800],
          toolbarTitle: "Profile Image",
          showCropGrid: true,
        ),
      );
      this.setState(() {
        img = pick;
        Navigator.of(context).pop();
      });
    }
  }

  @override

  Widget build(BuildContext context){
    final ro = Provider.of<Auth>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
            textColor: Colors.blueGrey[800],
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Already have an Account?",
              style: TextStyle(
                fontSize: 19.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white12,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.blueGrey[800],
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/20, MediaQuery.of(context).size.height/100, MediaQuery.of(context).size.width/20, 0.0),
        child: Form(
          key: formkey,
          child: ListView(
            children: [
              Text(
                "Register",
                style: TextStyle(
                  fontSize: 60.0,
                  fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/30,),
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.blueGrey[800],
                  backgroundImage: img == null? null:FileImage(img),
                  radius: 60.0,
                  child: Center(
                    child: IconButton(
                      icon: Icon(Icons.photo), 
                      onPressed: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) { 
                            return AlertDialog(
                              title: Text("Pick image from"),
                              content: SingleChildScrollView(
                                child: Row(
                                  children:[ 
                                    Container(
                                      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/10, MediaQuery.of(context).size.height/60, MediaQuery.of(context).size.width/10, MediaQuery.of(context).size.height/60),
                                      child: Column(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.photo_album), 
                                            onPressed: (){
                                              photo(context, ImageSource.gallery);
                                            },
                                          ),
                                          Text("Gallery")
                                        ]
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/10, MediaQuery.of(context).size.height/60, MediaQuery.of(context).size.width/10, MediaQuery.of(context).size.height/60),
                                      child: Column(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.camera_alt), 
                                            onPressed: (){
                                              photo(context, ImageSource.camera);
                                            },
                                          ),
                                          Text("Camera")
                                        ]
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        );
                      }
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/60,),
              TextFormField(
                focusNode: f1,
                decoration: InputDecoration(
                  labelText:"Name",
                  labelStyle: TextStyle(
                    color: f1.hasFocus ? Colors.blueGrey[800]:null,
                    ),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width:2.0,color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey[800], width: 2.0),),
                ),
                validator: RequiredValidator(errorText: "Enter your name"),
                onChanged: (value) => name = value,
              ),
              SizedBox(height: MediaQuery.of(context).size.height/80,),
              TextFormField(
                focusNode: f2,
                decoration: InputDecoration(
                  labelText:"Email-Id",
                  labelStyle: TextStyle(
                    color: f2.hasFocus ? Colors.blueGrey[800]:null,
                    ),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width:2.0,color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey[800], width: 2.0),),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Enter your email-id"),
                  EmailValidator(errorText: "Enter valid email address"),
                ]),
                onChanged: (value) => email = value,
              ),
              SizedBox(height: MediaQuery.of(context).size.height/80,),
              TextFormField(
                obscureText: true,
                focusNode: f3,
                decoration: InputDecoration(
                  labelText:"Password",
                  labelStyle: TextStyle(
                    color: f3.hasFocus ? Colors.blueGrey[800]:null,
                    ),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width:2.0,color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey[800], width: 2.0),),
                ),
                validator: MultiValidator([
                  RequiredValidator(errorText: "Enter the Password"),
                  MinLengthValidator(6, errorText: "Password must have minimum 6 characters"),
                  PatternValidator(r'^(?=.*?[a-z])(?=.*?[0-9]).{6,}$', errorText: "Password must contain atleast one number and one letter")
                ]), 
                onChanged: (value) => password = value,
              ),
              SizedBox(height: MediaQuery.of(context).size.height/80,),
              TextFormField(
                obscureText: true,
                focusNode: f4,
                decoration: InputDecoration(
                  labelText:"Confirm Password",
                  labelStyle: TextStyle(
                    color: f4.hasFocus ? Colors.blueGrey[800]:null,
                    ),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width:2.0,color: Colors.grey)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey[800], width: 2.0),),
                ),
                validator: (value){
                  return MatchValidator(errorText: "Passwords do not match").validateMatch(value, password);
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height/80,),
              Text(
                ro.rstr == null ? "" : ro.rstr,
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/80),
              Center(
                child: ro.loading == true? CircularProgressIndicator() : RaisedButton(
                  color: Colors.blueGrey[800],
                  textColor: Colors.white,
                  onPressed: () {
                    ro.rerrorstr(null);
                    if(formkey.currentState.validate() == false){
                    }
                    else{
                      ro.register(email, password, name, img).whenComplete(() {
                        if(ro.uid != null){
                          Navigator.pop(context);
                        }
                      });
                    }
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/40),
            ],
          ),
        ),        
      ),
    );
  }
}