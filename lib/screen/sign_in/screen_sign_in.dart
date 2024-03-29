import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:george_flutter/screen/sign_in/util/auth.dart';
import 'package:george_flutter/util/firebase_helper.dart';
import 'package:george_flutter/util/view/loading.dart';
import 'package:toast/toast.dart';
import 'package:rxdart/rxdart.dart';

import '../route_paths.dart';

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: Center(child: _SignInScreenContainer()),
    );
  }
}

class _SignInScreenContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInScreenContainerState();
  }
}

class _SignInScreenContainerState extends State<_SignInScreenContainer> {
  final _auth = Auth();
  bool _isCheckingAccount;
  bool _isSingingIn;
  AuthData _authData;
  String _error;

  final _signInIntent = PublishSubject<void>();

  @override
  void dispose() {
    super.dispose();
    _signInIntent.close();
  }

  void _initInternal() {
    _signInIntent.doOnEach((dynamic) {
      debugPrint("receive sign in intent");
    }).listen((intent) {
      _auth.signIn().doOnListen(() {
        setState(() {
          _isSingingIn = true;
        });
      }).listen((data) {
        // clear all previous
        Navigator.pushNamedAndRemoveUntil(
            context, ScreenPath.favorite_list_screen, ModalRoute.withName(""));
        Toast.show("Hi ${data.googleSignInAccount.displayName}", context,
            duration: Toast.LENGTH_LONG);
      }, onError: (error) {
        setState(() {
          _isSingingIn = false;
          _error = error.toString();
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint("initState screen sign in");
    _initInternal();
    _auth.isSignIn().doOnListen(() {
      setState(() {
        _isCheckingAccount = true;
        _isSingingIn = false;
      });
    }).listen((isSignIn) {
      debugPrint("isSignIn: $isSignIn");
      _error = null;
      if (isSignIn) {
        Fimber.v('get account & go to next screen');
        setState(() {
          _error = null;
        });
        _signInIntent.add({});
      } else {
        Fimber.v('show sign in button');
        setState(() {
          _error = null;
        });
      }
    }, onError: (error) {
      setState(() {
        _error = "Failed to sign in, reason: $error";
      });
    }, onDone: () {
      setState(() {
        _isCheckingAccount = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _SignInScreenContainerBranch(
      isCheckingAccount: _isCheckingAccount,
      isSingingIn: _isSingingIn,
      authData: _authData,
      error: _error,
      signInIntent: _signInIntent,
    );
  }
}

class _SignInScreenContainerBranch extends StatelessWidget {
  final bool isCheckingAccount;
  final bool isSingingIn;
  final AuthData authData;
  final String error;
  final PublishSubject<void> signInIntent;

  _SignInScreenContainerBranch(
      {@required this.isCheckingAccount,
      @required this.isSingingIn,
      @required this.authData,
      @required this.error,
      @required this.signInIntent});

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      return _Error(error);
    } else if (isCheckingAccount) {
      return CircularProgressBar(text: "Checking account...");
    } else if (isSingingIn) {
      return CircularProgressBar(text: "Signing in...");
    } else {
      return _SignInButton(
        signInIntent: signInIntent,
      );
    }
  }
}

class _Error extends StatelessWidget {
  final String text;

  _Error(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}



class _SignInButton extends StatelessWidget {
  final PublishSubject<void> signInIntent;

  _SignInButton({@required this.signInIntent});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      color: Color.fromARGB(0xff, 0x42, 0x85, 0xF4),
      padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Image.asset(
            'assets/ic_google_white_24dp.png',
          ),
          Padding(padding: EdgeInsets.fromLTRB(2, 0, 6, 0)),
          Text(
            'Sign in with Google',
            textAlign: TextAlign.center,
          )
        ],
      ),
      onPressed: () {
        debugPrint("request sign in");
        signInIntent.add({});
      },
    );
  }
}
