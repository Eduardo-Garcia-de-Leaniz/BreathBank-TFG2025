import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

ValueNotifier<Authentication_service> authenticationService = ValueNotifier(
  Authentication_service(),
);

class Authentication_service {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // 👇 Nuevo: Notificador del usuario actual
  final ValueNotifier<User?> userNotifier = ValueNotifier(null);

  Authentication_service() {
    // Escuchar cambios de login y actualizar el notifier
    firebaseAuth.authStateChanges().listen((user) {
      userNotifier.value = user;
    });
  }

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final result = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    userNotifier.value = result.user; // 🔄 actualizar notifier
    return result;
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
  }) async {
    final result = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    userNotifier.value = result.user;
    return result;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
    userNotifier.value = null;
  }

  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    await currentUser!.updateDisplayName(username);
  }

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
    userNotifier.value = null;
  }

  Future<void> resetPasswordFromCurrentPassword({
    required String currentPassword,
    required String newPassword,
    required String email,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }
}
