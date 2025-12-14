import 'package:firebase_auth/firebase_auth.dart';

import 'firestore.dart';

abstract class AuthenticationDatasource {
  Future<void> register(String email, String password, String passwordConfirm);
  Future<void> login(String email, String password);
}

class AuthenticationRemote extends AuthenticationDatasource {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirestoreDatasource();

  @override
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  @override
  Future<void> register(
      String email, String password, String passwordConfirm) async {
    if (passwordConfirm != password) {
      throw FirebaseAuthException(
        code: 'password-mismatch',
        message: 'As senhas não coincidem.',
      );
    }

    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    await _firestore.createUser(userCredential.user!.email ?? email);
  }
}
