import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yapter/Models/user.dart';

class Auth {
  String? verificationIdtemp;
  FirebaseAuth auth = FirebaseAuth.instance;


  Future verifyOTP(String phoneNumber)async{
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
    return  verificationIdtemp;


  }

  Future<String> signInWithOTP(String verificationId,String otpPin)async{
    try{
      PhoneAuthCredential credential=await PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpPin);
      UserCredential result = await auth.signInWithCredential(credential);
      if (result.user == null) {
        throw Exception("User sign-in failed: No user found.");
      }
      String uid =result.user!.uid;
      return uid;
    }
    catch(e){
      return e.toString();
    }
  }
  Stream<UserDetails?> get user{
    return auth.authStateChanges().map((firebaseuser){
      if(firebaseuser==null){
        return null;
      }
      return UserDetails(uid: firebaseuser.uid);

    });
  }
  Future<void> signOut()async{
    try{
      await auth.signOut();
    }
    catch(e){
     ;

    }
  }


}