import 'dart:convert';

import 'package:expense_manager_firebase/Services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';

class Home extends StatefulWidget{

  _Home createState() => _Home();
}

class _Home extends State<Home>{

  String s = " in the last 7 days";
  int v = 0;
  final formkey = GlobalKey<FormState>();
  String purpose;
  double amount;
  DateTime date;
  final FocusNode f1 = new FocusNode();
  final FocusNode f2 = new FocusNode();

  @override
  Widget build(BuildContext context) {
    final ho = Provider.of<Auth>(context);
    return Scaffold(
      floatingActionButton: CircleAvatar(
        radius: MediaQuery.of(context).size.height/30,
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: (){
            date = null;
            showModalBottomSheet(
              isScrollControlled: true,
              context: context, 
              builder: (BuildContext context,){
                return Container(
                  height: MediaQuery.of(context).size.height/2.4 + MediaQuery.of(context).viewInsets.bottom/1.2,
                  padding: EdgeInsets.all(MediaQuery.of(context).size.height/30),
                  child: Form(
                    key: formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        TextFormField(
                          focusNode: f1,
                          decoration: InputDecoration(
                            labelText:"Purpose",
                            labelStyle: TextStyle(
                              color: f1.hasFocus ? Colors.blueGrey[800]:null,
                              ),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width:2.0,color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey[800], width: 2.0),),
                          ),
                          validator: RequiredValidator(errorText: "Enter the purpose"),
                          onChanged: (value) => purpose = value,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height/80,),
                        TextFormField(
                          focusNode: f2,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText:"Amount",
                            labelStyle: TextStyle(
                              color: f2.hasFocus ? Colors.blueGrey[800]:null,
                              ),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(width:2.0,color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blueGrey[800], width: 2.0),),
                          ),
                          validator: RequiredValidator(errorText: "Enter the amount"),
                          onChanged: (value) => amount = double.parse(value),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height/60,),
                        StatefulBuilder(builder: (BuildContext context, StateSetter setModalState){
                          return Container(
                            child: Row(
                              children:[
                                Container(
                                  width: MediaQuery.of(context).size.width/4,
                                  child: Text(
                                    date == null ? "No Date Choosen!":DateFormat("MMMM dd,y").format(date),
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width/2.45),
                                FlatButton(
                                  color: Colors.blueGrey[800],
                                  onPressed: () {
                                    showRoundedDatePicker(
                                      context: context, 
                                      firstDate: DateTime(1999), 
                                      initialDate: DateTime.now(), 
                                      lastDate: DateTime(2021),
                                      borderRadius: 0,
                                      theme: ThemeData(
                                        primarySwatch: Colors.blueGrey,
                                        accentColor: Colors.blueGrey[800],
                                        primaryIconTheme: IconThemeData(color:Colors.blueGrey[800]),
                                        primaryColor: Colors.blueGrey[800],
                                      ),
                                    ).then((value) {
                                      if (value == null){
                                        return;
                                      }
                                      setModalState(() {
                                      date = value;
                                      }); 
                                    });
                                    setState(() {
                                    });
                                  },
                                  child:Text(
                                    "Choose Date",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ]
                            ),
                          );
                        }),
                        SizedBox(height: MediaQuery.of(context).size.height/60,),
                        Center(
                          child: FlatButton(
                            color: Colors.blueGrey[800],
                            onPressed: (){
                              if(formkey.currentState.validate() == false /*|| date == null*/){}
                              else{
                                ho.setdata(purpose, amount, date).whenComplete(() => Navigator.of(context).pop());
                              }
                            }, 
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.white
                              ),
                            )
                          ),
                        )
                      ]
                    ),
                  ),
                );
              }
            );
          }
        ),
      ),
      drawer: SafeArea(
        child: Drawer(
          elevation: 3.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(),
                margin: EdgeInsets.all(0),
                color: Colors.blueGrey[800],
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height:MediaQuery.of(context).size.height/40),
                          CircleAvatar(
                            backgroundColor: Colors.blueGrey[600],
                            radius: 50.0,
                            backgroundImage: ho.usrdoc == null || ho.usrdoc["fields"]["Image"]["stringValue"] == ""? null:MemoryImage(base64Decode(ho.usrdoc["fields"]["Image"]["stringValue"])),
                            child: Text(
                              ho.usrdoc == null || ho.usrdoc["fields"]["Image"]["stringValue"] != ""? "":ho.usrdoc["fields"]["Name"]["stringValue"][0],
                              style: TextStyle(
                                fontSize: 69.0,
                                fontWeight: FontWeight.w300,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/50,),
                          Text(
                            ho.usrdoc == null? "":ho.usrdoc["fields"]["Name"]["stringValue"],
                            style: TextStyle(
                              fontSize: 21.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height:MediaQuery.of(context).size.height/40),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height/1.55,),
              Container(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/4.2),
                child: RaisedButton(
                  child: Text(
                    "Sign-Out",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                  color: Colors.blueGrey[700],
                    onPressed: () {
                      ho.signOut();
                  },
                ),
              )
            ]
          ),
        ),
      ),
      appBar: AppBar(
        title: Text("My Expenses"),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list), 
            onPressed: (){
              showModalBottomSheet(
                context: context, 
                builder: (BuildContext context){
                return StatefulBuilder(builder: (BuildContext context, StateSetter setModalState){
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/25),
                    height: MediaQuery.of(context).size.height/3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height/40),
                        Row(
                          children: [
                            Text(
                              "Filters:",
                              style: TextStyle(
                                fontSize: 23.0,
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width/1.999,),
                            FlatButton(
                              onPressed: (){
                                ho.d = DateTime.now().subtract(Duration(days: 6));
                                ho.getdata();
                                v = 0;
                                s = " in the last 7 days";
                                setModalState((){});
                              }, 
                              child: Text(
                                "Clear all filters",
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              )
                            )
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height/40),
                        FlatButton(
                          onPressed: (){
                            ho.d = DateTime.parse(DateTime.now().year.toString() + "-" + (DateTime.now().month < 10? "0"+DateTime.now().month.toString():DateTime.now().month.toString()) + "-01");
                            ho.getdata();
                            v = 1;
                            s = " this Month";
                            setModalState(() {});
                          }, 
                          child: Text(
                            "Current Month",
                            style: TextStyle(
                              color: v == 1? Colors.blueGrey[800]:null,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        FlatButton(
                          onPressed: (){
                            ho.d = null;
                            ho.getalldata();
                            v = 2;
                            s = "";
                            setModalState(() {});
                          }, 
                          child: Text(
                            "All Expenses",
                            style: TextStyle(
                              color: v == 2? Colors.blueGrey[800]:null,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ]
                    ),
                  );
                });
              });
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/50),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    child: Card(
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height/50,),
                          Text(
                            "Total Money spent"+s+":",
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/100,),
                          Text(
                            "\u20B9"+ho.sum.toString(),
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height/50,),
                        ],
                      )
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height/50,),
            Expanded(
              child: ho.expenses == null || ho.expenses.length == 0? Center(child:Text("No expenses")) : ListView.builder(
                itemCount: ho.expenses.length,
                itemBuilder: (context, pos){
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: MediaQuery.of(context).size.height/20,
                        child: Text(
                          "\u20B9"+ho.expenses[pos]["fields"]["Amount"]["integerValue"].toString(),
                        )
                      ),
                      title: Text(
                        ho.expenses[pos]["fields"]["Purpose"]["stringValue"].toString(),
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/21
                        ),
                      ),
                      subtitle: Text(
                        DateFormat("yyyy-MM-dd").format(DateTime.parse(ho.expenses[pos]["fields"]["Date"]["timestampValue"]).toLocal()), 
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width/23
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.blueGrey[700],
                        ), 
                        onPressed: (){
                          ho.deleteexp(
                            ho.expenses[pos]["name"],
                            pos
                          );
                        }
                      ),
                    ),
                  );
                }
              ),
            ),
          ],
        )
      ),
    );
  }
}