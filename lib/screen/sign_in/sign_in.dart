import 'package:flutter/material.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Center(child: GoogleSignInButton()),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      color: Color.fromARGB(0xff, 0x42, 0x85, 0xF4),
      padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
//        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            'assets/ic_google_white_24dp.png',
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(2, 0, 6, 0)
          ),
          Text(
            'Sign in with Google',
            textAlign: TextAlign.center,
          )
        ],
      ),
      onPressed: () {
        // Navigate to the second screen using a named route.
        debugPrint("QQQQQQ");
      },
    );
  }
}
