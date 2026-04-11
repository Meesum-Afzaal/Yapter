import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  String? verificationIdtemp;

  FirebaseAuth auth = FirebaseAuth.instance;


  Future<void> verifyOTP(String phoneNumber)async{
    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential)async{
        await auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e){
        print(e.message);
    },
      codeSent: (String verificationId, int? resendToken){
        verificationIdtemp=verificationId;

      },
      codeAutoRetrievalTimeout: (String verificationId){},
    );
  }

  Future<void> signInWithOTP(String verificationId,String otpPin)async{
    try{
      PhoneAuthCredential credential=await PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpPin);
      await auth.signInWithCredential(credential);
    }
    catch(e){
      print(e.toString());
    }
  }


}