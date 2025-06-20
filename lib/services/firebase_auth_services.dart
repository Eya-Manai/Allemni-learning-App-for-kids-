import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'error',
        message: 'Unexpected error during sign in.',
      );
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw FirebaseAuthException(
        code: 'error',
        message: 'Unexpected error during sign in.',
      );
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
