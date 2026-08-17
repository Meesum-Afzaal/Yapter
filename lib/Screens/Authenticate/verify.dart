import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Designs/neumorphic_circle.dart';
import 'package:yapter/Models/user.dart';
import 'package:yapter/Providers/firestore_service_provider.dart';
import 'package:yapter/Providers/userProvider.dart';
import 'package:yapter/Services/auth.dart';

class VerifyOTP extends ConsumerStatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final String firstName;
  final String lastName;

  const VerifyOTP({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
  });

  @override
  ConsumerState<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends ConsumerState<VerifyOTP> {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? errorText;
  bool isPressed = false;
  bool isPressed2 = false;
  bool isLoading = false;
  String pin = "";

  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    final firestoreservice = ref.read(firestoreServiceProvider);

    // Fetch theme colors dynamically just like the Register screen
    final theme = Theme.of(context);
    final baseColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;
    final secondaryTextColor = textColor.withOpacity(0.6);

    return Scaffold(
      backgroundColor: baseColor,
      appBar: AppBar(
        title: Text(
          "OTP Verification",
          style: TextStyle(
            fontSize: 18.0,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: baseColor,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor), // Adapts back button color
        leading: const BackButton(),
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isLoading
              ? Center(
            key: const ValueKey('loading'),
            child: NeumorphicCircle(
              backgroundColor: baseColor,
              size: 80,
              child: CircularProgressIndicator(
                color: secondaryTextColor,
              ),
            ),
          )
              : SingleChildScrollView(
            key: const ValueKey('loaded'),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello ${widget.firstName},",
                    style: TextStyle(
                      fontSize: 30,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6.0,
                  ),
                  Text(
                    "We've sent a verification code to your number ${widget.phoneNumber}. Please enter the OTP below to verify your account.",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: formKey,
                    child: Pinput.builder(
                      autofillHints: const [AutofillHints.oneTimeCode],
                      autofocus: true,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      controller: controller,
                      onCompleted: (pinS) {
                        pin = pinS;
                      },
                      length: 6,
                      validator: (val) {
                        if (val!.isEmpty) {
                          errorText = "OTP is required!";
                        } else if (val.length < 6) {
                          errorText = "OTP must be 6 digits!";
                        } else {
                          errorText = null;
                        }

                        return null;
                      },
                      builder: (context, pinItem) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            NeumorphicContainer(
                              height: 45,
                              width: 45,
                              isPressed:
                              pinItem.index < controller.text.length,
                              backgroundColor: baseColor,
                              child: Center(
                                child: Text(
                                  pinItem.value,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    errorText ?? "",
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 15.0,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NeumorphicContainer(
                        height: 50,
                        width: 180,
                        backgroundColor: baseColor,
                        isPressed: isPressed2,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              setState(() {
                                isLoading = true;
                              });

                              try {
                                final result = await _auth.signInWithOTP(
                                    widget.verificationId, pin);
                                await firestoreservice.addUser(
                                    result,
                                    widget.firstName,
                                    widget.lastName,
                                    widget.phoneNumber);

                                if (mounted) {
                                  Navigator.popUntil(
                                      context, (route) => route.isFirst);
                                }
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                          child: Text(
                            "Verify",
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}