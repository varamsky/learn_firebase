import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:learn_firebase/auth/main_auth.dart';
import 'package:learn_firebase/screens/signup_screen.dart';
import 'package:learn_firebase/screens/user_screen.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  // text controllers
  final _emailEdit = TextEditingController();
  final _passwordEdit = TextEditingController();

  // reference to MainAuth class
  final MainAuth auth = MainAuth();

  // using these values to determine ErrorMessage for the TextFields.
  bool _emailValidate,_passValidate;
  String _emailError,_passError;

  @override
  void initState() {
    super.initState();

    // initially there is no Error Message
    _emailValidate = false;
    _passValidate = false;
    _emailError = '';
    _passError = '';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Login')),
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
                    controller: _emailEdit,
                    decoration: InputDecoration(
                      hintText: "Enter email",
                      icon: Icon(Icons.alternate_email),
                      errorText: _emailError, // setting the errorText
                      // border decorations
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.teal,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  TextFormField(
                    obscureText: true, // obscureText for passwords
                    controller: _passwordEdit,
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      icon: Icon(Icons.remove_red_eye),
                      errorText: _passError, // setting the errorText
                      // border decorations
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  Builder(
                    builder: (BuildContext context) => RaisedButton(
                      onPressed: () async{
                        print('clicked on Login');

                        // textField validations before before firebase is called
                        setState(() {
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

                        // if everything is fine then signIn
                        if(_emailValidate == true &&_passValidate == true){
                          FirebaseUser user = await auth.signIn(_emailEdit.text,_passwordEdit.text);

                          // If no user with given credentials then display snackBar
                          if(user == null){
                            print('No User');

                            Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('No user with given username and password. Please signup for new user.')),
                            );
                          }
                          // If successful login then send to User Screen
                          else {
                            print('user with email ${user.email} is logged in');
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => UserScreen(user: user,)));
                          }

                        }
                      },
                      child: Text('LOGIN'),
                    ),
                  ),
                  GestureDetector(
                    child: Text('Forgot Password?'),
                    onTap: (){
                      print('clicked on Forgot Password?');
                    },
                  ),
                  RichText(
                    text: TextSpan(
                        text: 'Don\'t have an account?',
                        style: TextStyle(
                            color: Colors.black,),
                        children: <TextSpan>[
                          TextSpan(text: ' Sign up',
                              style: TextStyle(
                                  color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              // Go to SignUp Screen
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignUpScreen())),
                          ),
                        ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
