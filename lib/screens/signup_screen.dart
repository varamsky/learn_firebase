import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase/auth/main_auth.dart';
import 'package:learn_firebase/screens/login_screen.dart';
import 'package:learn_firebase/screens/user_screen.dart';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  // text controllers
  final _nameEdit = TextEditingController();
  final _emailEdit = TextEditingController();
  final _passwordEdit = TextEditingController();


  // reference to MainAuth class
  final MainAuth auth = MainAuth();

  bool _nameValidate,_emailValidate,_passValidate;
  String _nameError,_emailError,_passError;

  @override
  void initState() {
    super.initState();

    // initially there is no Error Message
    _nameValidate = false;
    _emailValidate = false;
    _passValidate = false;
    _nameError = '';
    _emailError = '';
    _passError = '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('SignUp')),
        body: Center(
          // ScrollView for no outOfBounds error when the keyboard comes up
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _nameEdit,
                    decoration: InputDecoration(
                      hintText: 'Enter Full Name',
                      icon: Icon(Icons.person),
                      errorText: _nameError, // setting the errorText
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                              color: Colors.teal,
                            ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  TextField(
                    controller: _emailEdit,
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                      icon: Icon(Icons.alternate_email),
                      errorText: _emailError, // setting the errorText
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                              color: Colors.teal,
                            ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    controller: _passwordEdit,
                    decoration: InputDecoration(
                      hintText: 'Set password',
                      icon: Icon(Icons.remove_red_eye),
                      errorText: _passError, // setting the errorText
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                              color: Colors.teal,
                            ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  RaisedButton(
                      onPressed: () async{
                        print('clicked on Login');

                        // textField validations before before firebase is called
                        setState(() {
                            if(_nameEdit.text.isEmpty) {
                              _nameError = 'Please fill this field.';
                              _nameValidate = false;
                            }
                            else if(_nameEdit.text.length < 4){
                              _nameError = 'Name must be of more than 3 characters';
                              _nameValidate = false;
                            }
                            else{
                              _nameError = '';
                              _nameValidate = true;
                            }

                            String regex = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
                            if(_emailEdit.text.isEmpty) {
                              _emailError = 'Please fill this field.';
                              _emailValidate = false;
                            }
                            else{
                              if(!RegExp(regex).hasMatch(_emailEdit.text)) {
                                _emailError = 'Please enter a valid email.';
                                _emailValidate = false;
                              }
                              else {
                                _emailValidate = true;
                                _emailError = '';
                              }
                            }
                            if(_passwordEdit.text.isEmpty){
                              _passError =  'Please fill this field.';
                              _passValidate = false;
                            }
                            else{
                              if(_passwordEdit.text.length < 6){
                                _passError = 'Please enter a valid password.';
                                _passValidate = false;
                              }
                              else{
                                _passValidate = true;
                                _passError = '';
                              }
                            }
                          });


                        // if everything is fine then signUp
                        if(_nameValidate == true && _emailValidate == true &&_passValidate == true){
                          FirebaseUser user = await auth.signUp(_emailEdit.text,_passwordEdit.text);
                          if(user == null){
                            print('No User');

                            Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('There is some error with connection.')),
                            );
                          }
                          // If successful login then send to User Screen
                          else {
                            print('user with email ${user.email} is logged in');
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => UserScreen(user: user,)));
                          }

                        }

                      },
                    child: Text('SIGN UP'),
                  ),
                  // Go back to Login Screen
                  RichText(
                    text: TextSpan(
                      text: 'Want to go back to ',
                      style: TextStyle(
                        color: Colors.black,),
                      children: <TextSpan>[
                        TextSpan(text: 'Login?',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginScreen())),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
