import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// show logged in user details
class UserScreen extends StatelessWidget {
  final FirebaseUser user;

  UserScreen({this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('User Screen'),),
        body: Center(
          child: Text('User with email ${user.email} has logged in.'),
        ),
      ),
    );
  }
}
