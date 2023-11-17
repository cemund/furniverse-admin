import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // sign in with email & password
  Future signIn(String email, String password) async {
    try {
      print(email);
      print(password);
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  // signup with email & password
  Future signUp(
      {required String email,
      required String password,
      required String name,
      required String token,
      required Map shippingAddress}) async {
    try {
      User? result = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      // await DatabaseService(uid: result!.uid).updateUserData(
      //   name,
      //   email,
      //   shippingAddress,
      //   token,
      // );
      return result;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

  // sign out
  Future signOut() async {
    try {
      // await UserService().removeToken(
      //     userId: _auth.currentUser?.uid,
      //     token: await MessagingService().initNotification() ?? "");

      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
