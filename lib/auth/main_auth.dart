import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn_firebase/auth/base_auth.dart';

// main class to handle firebase authentication
class MainAuth implements BaseAuth{

  // Firebase auth instance. A reference to firebase.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // create user on firebase
  @override
  Future<FirebaseUser> signUp(String email, String password) async{

    // try-catch to catch exceptions.
    try{
      // create new user
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user; // get the created user details.

      return user;

    }
    catch(e){
      print('ERROR :: $e');
    }

    // if no user then return null.
    return null;
  }

  // sign-in for existing user.
  @override
  Future<FirebaseUser> signIn(String email, String password) async{
    // try-catch to catch exceptions if no user with given email and password.
    try{
      // sign-in the user.
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      //return user.uid;
      return user;
    }
    catch(e){
      print('ERROR :: $e');
    }

    // if no user then return null.
    return null;
  }

  // sign out the user
  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  // get the currently logged in user
  @override
  Future<FirebaseUser> getCurrentUser() async{
    return await _firebaseAuth.currentUser();
  }

  @override
  Future<bool> isEmailVerified() {
    // TODO: implement isEmailVerified
    throw UnimplementedError();
  }

  @override
  Future<void> sendEmailVerification() {
    // TODO: implement sendEmailVerification
    throw UnimplementedError();
  }

  
}