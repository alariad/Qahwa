import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterapp1/services/services.dart';
import 'package:flutterapp1/shared/loading.dart';
import 'package:provider/provider.dart';


class ProfileScreen extends StatelessWidget {

  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {

    Report report = Provider.of<Report>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);



    if (user != null) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffBFD9D7),
        title: Text(user.email,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),


              Text( report.total.toString() ,
                  style: Theme.of(context).textTheme.display3),


            Text('Quizzes Completed',
                style: Theme.of(context).textTheme.subhead),

            Spacer(),
            Container(
              width: 300,
              height: 45,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18.0)),
                  child: Text('logout', style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  ),
                  color: Color(0xff353745),
                  onPressed: () async {
                    await auth.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                  }),
            ),
            Spacer()
          ],
        ),
      ),
    );
    } else {
      return Loading();
    }
  }

}
