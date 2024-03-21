import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CloudAuthentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final CloudAuthentication _instance = CloudAuthentication._();

  CloudAuthentication._() {}

  factory CloudAuthentication() {
    return _instance;
  }

  get isLoggedIn {
    return _firebaseAuth.currentUser != null;
  }

  Future<void> signInUsingPhone(
      {required String phone,
      required Future<String> Function(int timeout) fetchCode}) async {
    bool userAuthenticated = false;
    if (kIsWeb) {
      userAuthenticated = await _phoneSignInWeb(phone, fetchCode);
    } else {
      userAuthenticated = await _phoneSignInMobile(phone, fetchCode);
    }

    if (!userAuthenticated) {
      throw FirebaseAuthException(message: "Unable to login", code: "unknown");
    }

    /* HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable("resyncUserToken");
    try {
      final response = await callable();
      _userId = response.data;
    } catch (e) {
      throw FirebaseAuthException(message: "Resync failed", code: "unknown");
    }
    await _firebaseAuth.currentUser!.getIdTokenResult(true);
    await _firebaseAuth.currentUser!.reload();
    return _userId;*/
  }

  Future<bool> _phoneSignInMobile(
    String phone,
    Future<String> Function(int timeout) fetchCode,
  ) async {
    var completer = Completer<PhoneAuthCredential>();
    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91$phone",
        timeout: const Duration(seconds: 60),
        verificationCompleted: (phoneCredential) {
          completer.complete(phoneCredential);
        },
        verificationFailed: (exception) {
          completer.completeError(FirebaseAuthException(
              message: "Verification failed", code: "unknown"));
        },
        codeSent: (verificationId, resendToken) async {
          var code = await fetchCode(60);
          completer.complete(PhoneAuthProvider.credential(
              verificationId: verificationId, smsCode: code));
        },
        codeAutoRetrievalTimeout: (verificationId) {
          if (!completer.isCompleted) {
            completer.completeError(FirebaseAuthException(
                message: "Timeout occurred", code: "unknown"));
          }
        });
    UserCredential result =
        await _firebaseAuth.signInWithCredential(await completer.future);
    return (result.user != null);
  }

  Future<bool> _phoneSignInWeb(
    String phone,
    Future<String> Function(int timeout) fetchCode,
  ) async {
    ConfirmationResult confirmationResult =
        await _firebaseAuth.signInWithPhoneNumber("+91$phone");
    var code = await fetchCode(60);
    UserCredential userCredential = await confirmationResult.confirm(code);
    return (userCredential.user != null);
  }

  Future<String> signIn(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;
    return user!.uid;
  }

  bool isEmailVerified() {
    return _firebaseAuth.currentUser!.emailVerified;
  }

  User? _getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<bool> isAuthenticatedUser() async {
    User? user = _getCurrentUser();
    return (user != null);
  }

  Future<String?> getCurrentUserEmail() async {
    User? user = _getCurrentUser();
    return user!.email;
  }

  Future<bool> validateCurrentPassword(String currentPassword) async {
    final user = _getCurrentUser();
    try {
      await user!.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email ?? '',
          password: currentPassword,
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _getCurrentUser();
    try {
      await user!.reauthenticateWithCredential(
        EmailAuthProvider.credential(
          email: user.email ?? '',
          password: currentPassword,
        ),
      );
      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> sendEmailVerification() async {
    await _firebaseAuth.currentUser!.sendEmailVerification();
  }

  Future<bool> passwordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
