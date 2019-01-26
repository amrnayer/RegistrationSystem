import'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import'LoginForm.dart';
import 'UpdateProfile.dart';
import 'dart:io';


class Signup extends StatefulWidget{
  @override
  State createState()=>new SignUpState();
}
class SignUpState extends State<Signup> with SingleTickerProviderStateMixin{
  String _email,_password,_name,_phonenumber;
  //key is responsible for data in form
  final FormKey= new GlobalKey<FormState>();
  //State error message
  var message=new TextEditingController();
  //Function that responsible for validate form and server side
  _Signup(){
    final form =FormKey.currentState;
    if (form.validate()) {
      form.save();
      performsignup();
      print(message.text);
    }
  }
//function responisble for post information in the form to data
  performsignup()async{
    http.Response res =await http.post("https://internship-api-v0.7.intcore.net/api/v1/user/auth/signup",headers: {"Accept":"application/json"},body:{"email":_email.toLowerCase(),"phone":_phonenumber,"password":_password,"name":_name});
    if(res.statusCode==200){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => UpdateProfile(json.decode(res.body)["user"]["api_token"],_email,_name,_phonenumber)));
    }
    else{
      setState(() {
        message.text=json.decode(res.body)["errors"][0]["message"];
      });
    }
  }
  gosignin(){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginPage()));

  }


  //Application Widgets


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false, title: new Text("Registration",style: TextStyle(color: Colors.teal,fontSize: 35.0)),backgroundColor: Colors.black,centerTitle: true,),

        backgroundColor: Colors.black,
        body:new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Image(image: new AssetImage("assets/images/back.jpg"),
                  fit: BoxFit.cover,
                  color: Colors.black87,
                  colorBlendMode: BlendMode.darken
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Theme(
                    data: new ThemeData(
                        brightness: Brightness.dark
                        ,primarySwatch: Colors.teal,
                        inputDecorationTheme:new InputDecorationTheme(
                            labelStyle: new TextStyle(
                                color: Colors.teal,
                                fontSize: 15.0
                            )
                        )
                    ),

                    child: new Container(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Form(
                        key: FormKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(message.text,style: TextStyle(color: Colors.red)),
                            new TextFormField(
                              validator:(val)=>val.length<=0?'Wrong Email':null,
                              onSaved: (val)=>_email=val,
                              decoration: new InputDecoration(
                                labelText: "Email",
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            new TextFormField(
                              validator:(val)=>val.length<=0?'Wrong Password':null,
                              onSaved:(val)=>_password=val,

                              decoration: new InputDecoration(
                                labelText: "Password",
                              ),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                            ),
                            new TextFormField(
                              onSaved:(val)=>_name=val,

                              decoration: new InputDecoration(
                                labelText: "Name",
                              ),
                              keyboardType: TextInputType.text,

                            ),
                            new TextFormField(
                                onSaved:(val)=>_phonenumber=val,
                              decoration: new InputDecoration(
                                labelText: "Phone Number",
                              ),
                              keyboardType: TextInputType.text
                            ),
                            new Padding(padding: const EdgeInsets.only(top: 20.0)),
                            new RaisedButton(
                              color:Colors.teal,
                              textColor: CupertinoColors.lightBackgroundGray,
                              child: Text("SignUp"),
                              onPressed: _Signup,
                              splashColor: CupertinoColors.activeBlue,
                            ),
                            new CupertinoButton(child: Text("Signin here",style: TextStyle(color: Colors.tealAccent
                            ),), onPressed: gosignin)

                          ],
                        ),
                      ),
                    ),
                  ) ,
                ],
              )
            ]
        )
    );
  }


}