import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:DocConnect/screens/signIn.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  String _email;
  bool showSpinner = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Future<void> resetPassword() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      setState(() {
        showSpinner = true;
      });
      formState.save();
      try {
        await _auth.sendPasswordResetEmail(email: _email);
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                  title: new Text(
                      "Reset link has been sent to your registered email address!"),
                  content: new Text("Press ok to login with the new password!"),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Ok',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/SignIn');
                      },
                    ),
                  ],
                ));
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        showModalBottomSheet(context: context, builder: reset);
      }
    }
  }

  Widget reset(BuildContext context) {
    Fluttertoast.showToast(
      msg: 'Enter a valid email',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Navigator.pop(context);
    return null;
  }

  Widget redirect(BuildContext context) {
    Fluttertoast.showToast(
      msg: 'Redirecting you to the login page!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.blueGrey,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    Navigator.pop(context);
    return null;
  }

  final TextEditingController editCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Forgot password'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Container(
            margin: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please enter email';
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(input)) {
                        return "Please enter valid email";
                      }
                    },
                    onSaved: (input) {
                      _email = input;
                    },
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'Enter Email',
                      labelStyle: TextStyle(color: Colors.black),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        child: Text(
                          'Reset Password',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: resetPassword),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
