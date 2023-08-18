

import 'package:firebase_auth/firebase_auth.dart';
import '../Model/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // lớp xác thực
  // create user obj based on Firebase
  UserFirebase? _userFormFirebaseUser(User user) {
    // ignore: unnecessary_null_comparison
    return user != null ? UserFirebase(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserFirebase>? get user {
    return _auth
        .authStateChanges()
        .map((User? user) => _userFormFirebaseUser(user!)!);
  }

  //sign in anonymous
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;

      return _userFormFirebaseUser(user!);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  //sign in with email & pass
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFormFirebaseUser(user!);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

  // register with email & pass

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return null;
    }
  }

}
