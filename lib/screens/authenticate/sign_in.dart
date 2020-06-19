import 'package:flutterapp1/animation/fadeanimation.dart';
import 'package:flutterapp1/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp1/shared/constants.dart';
import 'package:flutterapp1/shared/loading.dart';


class SignIn extends StatefulWidget {
  //this function passed by Authenticate widget
  final Function toggleView;
  SignIn({ this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
            backgroundColor: Color(0xffBFD9D7),
            body: Container(
              color: Color(0xffBFD9D7),
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  SizedBox(height: 20.0),
                  Image(
                      image: ExactAssetImage("assets/logo.jpg"),
                      height: 200,
                      width: 200),
                  SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                        SizedBox(height: 8.0),
                        Material(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          elevation: 8,
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                                hintText: 'email', icon: Icon(Icons.mail)),
                            validator: (val) =>
                            !(val.contains('@')) ? 'Email is invalid' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Material(
                          elevation: 8,
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                          child: TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'password',
                                icon: Icon(Icons.lock_outline)),
                            validator: (val) => val.length < 6
                                ? 'Pasword is short (minimum is 6 characters)'
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          'Forget your password?',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 300,
                          height: 45,
                          child: RaisedButton(
                              color: Color(0xff353745),
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(18.0)),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error = 'Invalid email or password';
                                    }
                                    );
                                  }
                                }
                              }),
                        ),
                        SizedBox(height: 12.0),
                        SizedBox(height: 12.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account? ',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 17)),
                            GestureDetector(
                              onTap: () => widget.toggleView(),
                              child: Container(
                                child: Text('Sign Up',
                                    style: TextStyle(
                                        color: Color(0xff353745),
                                        decoration: TextDecoration.underline,
                                        fontSize: 17)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          );
  }
}
