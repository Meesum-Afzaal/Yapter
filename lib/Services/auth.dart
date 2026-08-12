import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:yapter/Models/user.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String?> verifyOTP(String phoneNumber) async {
    final completer = Completer<String?>();

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,

        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await auth.signInWithCredential(credential);

            // Android may automatically verify the number.
            // In this case there may be no need to show OTP screen.
            if (!completer.isCompleted) {
              completer.complete(null);
            }
          } catch (e) {
            if (!completer.isCompleted) {
              completer.completeError(e);
            }
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          print("Phone verification failed");
          print("Code: ${e.code}");
          print("Message: ${e.message}");

          if (!completer.isCompleted) {
            completer.completeError(e);
          }
        },

        codeSent: (String verificationId, int? resendToken) {
          print("OTP code sent");
          print("Verification ID received");

          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          print("OTP auto retrieval timeout");

          // Do NOT complete the completer here.
          //
          // codeSent() has already provided the verificationId.
        },
      );

      return await completer.future;
    } catch (e) {
      print("verifyOTP error: $e");

      if (!completer.isCompleted) {
        completer.completeError(e);
      }

      return null;
    }
  }

  Future<String> signInWithOTP(
      String verificationId,
      String otpPin,
      ) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpPin,
      );

      final result = await auth.signInWithCredential(credential);

      if (result.user == null) {
        throw Exception("User sign-in failed: No user found.");
      }

      return result.user!.uid;
    } on FirebaseAuthException catch (e) {
      print("OTP sign-in failed");
      print("Code: ${e.code}");
      print("Message: ${e.message}");

      return e.message ?? e.code;
    } catch (e) {
      print("OTP sign-in error: $e");
      return e.toString();
    }
  }

  Stream<UserDetails?> get user {
    return auth.authStateChanges().map((firebaseUser) {
      if (firebaseUser == null) {
        return null;
      }

      return UserDetails(
        uid: firebaseUser.uid,
      );
    });
  }

  Future<void> signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print("Sign out error: $e");
    }
  }
}