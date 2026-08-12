import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:yapter/Designs/neumorphic_circle.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:yapter/Screens/Authenticate/verify.dart';
import 'package:yapter/Services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final Auth _auth = Auth();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  final FocusNode _focusNode3 = FocusNode();

  final TextEditingController controller1 = TextEditingController();
  final TextEditingController controller2 = TextEditingController();
  final TextEditingController controller3 = TextEditingController();

  IsoCode code = IsoCode.PK;

  String errorText = '';
  String errorText2 = '';

  bool isPressed = false;
  bool isLoading = false;

  String? firstName;
  String? lastName;

  String number = "";

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() => setState(() {}));
    _focusNode2.addListener(() => setState(() {}));
    _focusNode3.addListener(() => setState(() {}));

    controller1.addListener(() => setState(() {}));
    controller2.addListener(() => setState(() {}));

    controller3.addListener(() {
      formatNumber();
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();

    controller1.dispose();
    controller2.dispose();
    controller3.dispose();

    super.dispose();
  }

  void formatNumber() {
    final text = controller3.text;

    if (text.isEmpty) {
      return;
    }

    try {
      final phoneNumber = PhoneNumber.parse(
        text,
        callerCountry: code,
      );

      final formattedNumber = phoneNumber.formatNsn();

      if (formattedNumber != text) {
        controller3.value = controller3.value.copyWith(
          text: formattedNumber,
          selection: TextSelection.collapsed(
            offset: formattedNumber.length,
          ),
          composing: TextRange.empty,
        );
      }
    } catch (e) {
      return;
    }
  }

  Future<void> register() async {
    if (isLoading) {
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      errorText = '';
      errorText2 = '';
    });

    if (!formKey.currentState!.validate()) {
      return;
    }

    formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });

    try {
      print("Starting phone verification...");
      print("Phone number: $number");

      final verificationId = await _auth.verifyOTP(number);

      print("Verification ID result: $verificationId");

      if (!mounted) {
        return;
      }

      if (verificationId != null) {
        print("Opening OTP screen...");

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyOTP(
              verificationId: verificationId,
              phoneNumber: number,
              firstName: firstName!,
              lastName: lastName!,
            ),
          ),
        );
      } else {
        // This can happen if Android automatically verified
        // the phone number.
        print("Phone number was automatically verified.");
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error");
      print("Code: ${e.code}");
      print("Message: ${e.message}");

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? "Phone verification failed.",
          ),
        ),
      );
    } catch (e) {
      print("Registration error: $e");

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Something went wrong: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final baseColor = theme.colorScheme.surface;

    final textColor = theme.colorScheme.onSurface;

    final secondaryTextColor =
    textColor.withOpacity(0.6);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: baseColor,

      body: Padding(
        padding: const EdgeInsets.all(5.0),

        child: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),

            child: isLoading
                ? Center(
              key: const ValueKey('loading'),

              child: NeumorphicCircle(
                backgroundColor: baseColor,
                size: 80,

                child: CircularProgressIndicator(
                  color: textColor.withOpacity(0.6),
                ),
              ),
            )

                : SingleChildScrollView(
              key: const ValueKey('loaded'),

              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [
                  const SizedBox(height: 60),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [
                      NeumorphicContainer(
                        height: 130,
                        width: 130,
                        backgroundColor: baseColor,
                        borderRadius:
                        BorderRadius.circular(30),

                        child: Center(
                          child: Image.asset(
                            "assets/yapter.png",
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),

                  Padding(
                    padding:
                    const EdgeInsets.all(15.0),

                    child: Form(
                      key: formKey,

                      child: Column(
                        children: [
                          // FIRST NAME
                          NeumorphicContainer(
                            height: 50,
                            width: double.infinity,
                            backgroundColor: baseColor,

                            isPressed:
                            _focusNode.hasFocus ||
                                controller1
                                    .text
                                    .isNotEmpty,

                            child: Padding(
                              padding:
                              const EdgeInsets
                                  .fromLTRB(
                                15,
                                0,
                                15,
                                0,
                              ),

                              child: TextFormField(
                                controller:
                                controller1,

                                focusNode:
                                _focusNode,

                                style: TextStyle(
                                  color: textColor,
                                ),

                                decoration:
                                InputDecoration(
                                  hintText:
                                  errorText
                                      .isEmpty
                                      ? "First Name"
                                      : errorText,

                                  hintStyle:
                                  TextStyle(
                                    color:
                                    errorText
                                        .isEmpty
                                        ? secondaryTextColor
                                        : Colors.red,
                                  ),

                                  border:
                                  InputBorder.none,
                                ),

                                validator: (value) {
                                  if (value == null ||
                                      value
                                          .trim()
                                          .isEmpty) {
                                    return "First Name is required!";
                                  }

                                  return null;
                                },

                                onSaved: (value) {
                                  firstName =
                                      value!.trim();
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 35),

                          // LAST NAME
                          NeumorphicContainer(
                            height: 50,
                            width: double.infinity,
                            backgroundColor: baseColor,

                            isPressed:
                            _focusNode2.hasFocus ||
                                controller2
                                    .text
                                    .isNotEmpty,

                            child: Padding(
                              padding:
                              const EdgeInsets
                                  .fromLTRB(
                                15,
                                0,
                                15,
                                0,
                              ),

                              child: TextFormField(
                                controller:
                                controller2,

                                focusNode:
                                _focusNode2,

                                style: TextStyle(
                                  color: textColor,
                                ),

                                decoration:
                                InputDecoration(
                                  hintText:
                                  errorText2
                                      .isEmpty
                                      ? "Last Name"
                                      : errorText2,

                                  hintStyle:
                                  TextStyle(
                                    color:
                                    errorText2
                                        .isEmpty
                                        ? secondaryTextColor
                                        : Colors.red,
                                  ),

                                  border:
                                  InputBorder.none,
                                ),

                                validator: (value) {
                                  if (value == null ||
                                      value
                                          .trim()
                                          .isEmpty) {
                                    return "Last Name is required!";
                                  }

                                  return null;
                                },

                                onSaved: (value) {
                                  lastName =
                                      value!.trim();
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 35),

                          // PHONE NUMBER
                          NeumorphicContainer(
                            height: 50,
                            width: double.infinity,
                            backgroundColor: baseColor,

                            isPressed:
                            _focusNode3.hasFocus ||
                                controller3
                                    .text
                                    .isNotEmpty,

                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceEvenly,

                              children: [
                                CountryCodePicker(
                                  onChanged:
                                      (country) {
                                    code = IsoCode
                                        .values
                                        .firstWhere(
                                          (e) =>
                                      e.name ==
                                          country.code,
                                    );
                                  },

                                  pickerStyle:
                                  PickerStyle.dialog,

                                  dialogBackgroundColor:
                                  baseColor,

                                  initialSelection:
                                  'PK',

                                  searchDecoration:
                                  InputDecoration(
                                    contentPadding:
                                    const EdgeInsets
                                        .all(
                                      8,
                                    ),

                                    hintText:
                                    "Search Country eg : PK or +92",

                                    hintStyle:
                                    TextStyle(
                                      fontSize: 15,
                                      color:
                                      secondaryTextColor,
                                    ),

                                    fillColor:
                                    baseColor,

                                    filled: true,

                                    border:
                                    OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius
                                          .circular(
                                        30,
                                      ),
                                      borderSide:
                                      BorderSide
                                          .none,
                                    ),
                                  ),

                                  favorite: const [
                                    'PK',
                                    'US',
                                  ],

                                  topBarPadding:
                                  const EdgeInsets
                                      .fromLTRB(
                                    20,
                                    10,
                                    15,
                                    10,
                                  ),

                                  dialogItemPadding:
                                  const EdgeInsets
                                      .fromLTRB(
                                    15,
                                    10,
                                    15,
                                    10,
                                  ),

                                  searchPadding:
                                  const EdgeInsets
                                      .fromLTRB(
                                    15,
                                    10,
                                    15,
                                    10,
                                  ),

                                  barrierColor:
                                  Colors.black54,

                                  dialogTextStyle:
                                  TextStyle(
                                    fontSize: 16,
                                    color:
                                    textColor,
                                  ),

                                  textStyle:
                                  TextStyle(
                                    color:
                                    textColor,
                                  ),
                                ),

                                VerticalDivider(
                                  width: 0.2,
                                  color:
                                  textColor
                                      .withOpacity(
                                    0.5,
                                  ),
                                  indent: 8,
                                  endIndent: 8,
                                ),

                                const SizedBox(
                                    width: 8),

                                Expanded(
                                  child:
                                  TextFormField(
                                    controller:
                                    controller3,

                                    focusNode:
                                    _focusNode3,

                                    style: TextStyle(
                                      color:
                                      textColor,
                                    ),

                                    keyboardType:
                                    TextInputType
                                        .phone,

                                    decoration:
                                    InputDecoration(
                                      hintText:
                                      "Enter Phone Number",

                                      hintStyle:
                                      TextStyle(
                                        color:
                                        secondaryTextColor,
                                      ),

                                      border:
                                      InputBorder
                                          .none,
                                    ),

                                    onSaved: (value) {
                                      final phoneNumber =
                                      PhoneNumber
                                          .parse(
                                        value!,
                                        callerCountry:
                                        code,
                                      );

                                      number =
                                          phoneNumber
                                              .international;
                                    },

                                    validator: (value) {
                                      if (value ==
                                          null ||
                                          value
                                              .trim()
                                              .isEmpty) {
                                        return "Phone number is required";
                                      }

                                      try {
                                        final phoneNumber =
                                        PhoneNumber
                                            .parse(
                                          value,
                                          callerCountry:
                                          code,
                                        );

                                        if (phoneNumber
                                            .isValid()) {
                                          return null;
                                        }

                                        return "Invalid Phone Number";
                                      } catch (e) {
                                        return "Invalid Phone Number";
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 60),

                          // REGISTER BUTTON
                          NeumorphicContainer(
                            height: 50,
                            width: 180,
                            backgroundColor: baseColor,
                            isPressed: isPressed,

                            child: ElevatedButton(
                              onPressed:
                              isLoading
                                  ? null
                                  : register,

                              style:
                              ElevatedButton
                                  .styleFrom(
                                backgroundColor:
                                Colors.transparent,
                                disabledBackgroundColor:
                                Colors.transparent,
                                shadowColor:
                                Colors.transparent,
                                elevation: 0,
                              ),

                              child: Text(
                                "Register",
                                style: TextStyle(
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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