import'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'UpdateProfile.dart';
import 'dart:io';
import'LoginForm.dart';
import "ResetPassword.dart";
class UpdateProfile extends StatefulWidget{
  UpdateProfile(this.token,this._email1,this._name1,this._Reset):super();
  final String  _email1;
  final String token;
  final String _name1;
  final String _Reset;
  @override
  State createState()=>new UpdateProfileState();
}
class UpdateProfileState extends State<UpdateProfile> with SingleTickerProviderStateMixin{
  String Jsontostring(Map<String,dynamic> json){
    return json["message"];
  }
  var message=new TextEditingController();
  var pn_txc=new TextEditingController();
  var em_txc=new TextEditingController();
  var em_txc1=new TextEditingController();
  var name_txc=new TextEditingController();
  final FormKey= new GlobalKey<FormState>();
  String _email;
  String _name;
  //Animation related
  AnimationController _IconAc;
  Animation<double>_IconA;
  @override
  void initState(){
    setState(() {

      name_txc.text=widget._name1;
      message.text="";
      em_txc.text=widget._email1;
      em_txc1.text=widget._email1;
    });

    super.initState();
    //Icon Animation States
    _IconAc=new AnimationController(
        vsync: this,
        duration: new Duration(microseconds: 500)
    );
    _IconA=new CurvedAnimation(
        parent: _IconAc,
        curve: Curves.easeOut
    );
    _IconA.addListener(()=>this.setState((){}));
    _IconAc.forward();
    //Text State controller

  }
//Print Server Response

  @override
  void dispose(){

    super.dispose();
    _IconAc.removeListener(()=>this.setState((){}));
    _IconAc.dispose();

  }
  
  GoBack(BuildContext context){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginPage()));
  }

  _Update(){

    final form =FormKey.currentState;
    if (form.validate()) {
      form.save();
      PerformUpdate();
      print(message.text);

    }
  }
  PerformUpdate()async{
    String U="https://internship-api-v0.7.intcore.net/api/v1/user/auth/update-profile?api_token="+widget.token+"&name="+_name+"&email="+_email;
    final res= await http.patch(U,headers: {"Accept":"application/json"});
if(res.statusCode!=200){
  message.text=json.decode(res.body)["errors"][0]["message"];
}

else if(res.statusCode==200) {
  setState(() {
    message.text = "Updated";
    em_txc.text=_email;
  });
}
  }

  ResetP(){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ResetPassword(widget.token,em_txc.text,widget._Reset)));
  }

//Form related
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
appBar: AppBar(
  title: Text("Profile",textAlign: TextAlign.center,style: TextStyle(color: Colors.teal,fontSize: 35.0),),
  centerTitle: true,
  backgroundColor:Colors.black,
  actions:
  <Widget>[
    CupertinoButton(
      child: Text("logout",style: TextStyle(color: CupertinoColors.destructiveRed),)
      ,onPressed:()=> Navigator.push(context,
        MaterialPageRoute(builder: (context) => LoginPage()))
      ,)
  ],
  automaticallyImplyLeading: false,
),
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

                      child: Form(
                        key: FormKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[

                            new Text(em_txc.text,style: TextStyle(color: Colors.teal,fontSize: _IconAc.value*45)),
                            Text(message.text,style: TextStyle(color: Colors.red),),
                            new TextFormField(
                              controller: em_txc1,
                              validator:(val)=>val.length<=0?'Insert Your Email':null,
                              onSaved: (val)=>_email=val,
                              decoration: new InputDecoration(
                                labelText: "Email",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            new TextFormField(
                              controller: name_txc,
                              validator:(val)=>val.length<=0?'Insert name':null,
                              onSaved: (val)=>_name=val,
                              decoration: new InputDecoration(
                                labelText: "User Name",
                              ),
                              keyboardType: TextInputType.text,
                            ),
                            new Padding(padding: const EdgeInsets.only(top: 20.0)),
                            new RaisedButton(
                              color:Colors.teal,
                              textColor: CupertinoColors.lightBackgroundGray,
                              child: Text("Update"),
                              splashColor: CupertinoColors.activeBlue,
                              onPressed: _Update,
                            ),
                            new CupertinoButton(child: Text("Reset Password",style: TextStyle(color: Colors.tealAccent
                            ),),
                            onPressed:ResetP,

                            ),

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