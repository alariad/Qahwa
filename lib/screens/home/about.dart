import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff353745),
          title: Text('About',
              style: TextStyle(
                fontSize: 18,
              ))),
      body: Container(
        color: Color(0xffBFD9D7),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image(
                  image: ExactAssetImage("assets/logo.jpg"),
                  height: 200,
                  width: 200),
              Column(children: [
                Text('This App is created',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color:Color(0xff353745))),
                Text('by Alaa Al Tuhl',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color:Color(0xff353745))),
              ],),

            ],
          )
        ),
      ),
    );
  }
}



