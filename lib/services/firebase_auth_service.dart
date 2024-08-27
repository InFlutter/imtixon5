import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class FirebaseAuthService {
  final authService = FirebaseAuth.instance;
  final firestoreService = FirebaseFirestore.instance;

  Future<void> login(String email, String password) async {
    try {
      await authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      UserCredential userCredential = await authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
      );

      await firestoreService.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await authService.signOut();
  }
}
