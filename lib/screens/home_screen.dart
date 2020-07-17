import 'package:flutter/material.dart';
import 'package:learn_firebase/screens/firestore_screen.dart';
import 'package:learn_firebase/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Home Screen'),),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Firestore screen'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => FirestoreScreen())),
              ),
              RaisedButton(
                child: Text('Firebase Auth screen'),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginScreen())),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
