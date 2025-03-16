import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String> signup(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        message = "An account already exists with the same email.";
      }
      return message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signin(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-credential') {
        message = "Email or password is wrong. Please try again.";
      }
      return message;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signout() async {
    await FirebaseAuth.instance.signOut();
  }
}
