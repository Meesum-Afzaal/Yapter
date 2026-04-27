import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:yapter/Designs/flutter_neumorphic_button.dart';
import 'package:yapter/Models/user.dart';
import 'package:yapter/Providers/userProvider.dart';
import 'package:yapter/Services/auth.dart';


class VerifyOTP extends ConsumerStatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  const VerifyOTP({super.key,required this.verificationId,required this.phoneNumber,required this.firstName,required this.lastName});

  @override
  ConsumerState<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends ConsumerState<VerifyOTP> {
  Color baseColor = Color(0xFFE6EBF2);
  final controller=TextEditingController();
  final formKey=GlobalKey<FormState>();
  String? errorText;
  bool isPressed = false;
  bool isPressed2 = false;
  String pin="";
  final Auth _auth=Auth();

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        title: Text("OTP Verification",style: TextStyle(fontSize: 18.0,color: Colors.grey.shade800,fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: baseColor,
        leading: BackButton(color: Colors.grey.shade800,),
      ),
      body:
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello ${widget.firstName},",
                style: TextStyle(
                  fontSize:30,
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 6.0,),
              Text(
                "We've sent a verification code to your number ${widget.phoneNumber}. Please enter the OTP below to verify your account.",
                style: TextStyle(
                    fontSize:15.0,
                    color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 40,),
              Form(
                key: formKey,
                child: Pinput.builder(
                    autofillHints: [AutofillHints.oneTimeCode],
                    autofocus: true,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  controller: controller,
                  onCompleted:(pinS){
                      pin=pinS;
                  },

                  length: 6,

                    validator: (val){
                    if (val!.isEmpty) {
                      errorText="OTP is required!";
                    }
                    else if(val.length<6){
                      errorText="OTP must be 6 digits!";
                    }
                    else{
                      errorText=null;
                    }

                    return null;
                    },

                    builder: (context, pin){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NeumorphicButton(
                            height: 45,
                            width: 45,

                            isPressed: pin.index<controller.text.length ,
                            backgroundColor: baseColor,
                            child: Center(
                              child:Text(
                                pin.value,
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0
                                ),

                              ),
                            ),


                      ),
                    ],
                  );

                }),
              ),
              SizedBox(height: 20,),
              Text(errorText??"",style: TextStyle(color: Colors.red,fontSize: 15.0),),
              SizedBox(height: 40,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // NeumorphicButton(
                  //   height: 50,
                  //   width: 180,
                  //
                  //   backgroundColor: baseColor,
                  //   isPressed: isPressed,
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       setState(() {
                  //         isPressed = true;
                  //       });
                  //       await Future.delayed(Duration(milliseconds: 200));
                  //       setState(() {
                  //         isPressed = false;
                  //       });
                  //
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //
                  //       backgroundColor: Colors.transparent,
                  //       elevation: 0,
                  //     ),
                  //     child: Text(
                  //       "Resend OTP",
                  //       style: TextStyle(color: Colors.grey.shade800),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(width: 8.0,),
                  NeumorphicButton(
                    height: 50,
                    width: 180,
        
                    backgroundColor: baseColor,
                    isPressed: isPressed2,
                    child: ElevatedButton(
                      onPressed: () async {
                        
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          final result = await _auth.signInWithOTP(widget.verificationId, pin);
                          ref.read(userNotifierProvider.notifier).setUser(UserDetails(uid: result,firstName: widget.firstName,lastName: widget.lastName,phoneNumber: widget.phoneNumber));
                          Navigator.popUntil(context, (route) => route.isFirst);
                          
                          
                          






                        }
        
                      },
                      style: ElevatedButton.styleFrom(
        
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                      child: Text(
                        "Verify",
                        style: TextStyle(color: Colors.grey.shade800),
                      ),
                    ),
                  ),

                ],
              ),
        
            ],
        
          ),
        ),
      ),
    );
  }
}
