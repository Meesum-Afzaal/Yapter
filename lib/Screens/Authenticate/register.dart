import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yapter/Designs/neumorphic_container.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:yapter/Models/user.dart';
import 'package:yapter/Providers/userProvider.dart';
import 'package:yapter/Screens/Authenticate/verify.dart';
import 'package:yapter/Services/auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  Color baseColor = Color(0xFFE6EBF2);
  final Auth _auth=Auth();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  final _focusNode2 = FocusNode();
  final _focusNode3 = FocusNode();
  final controller1 = TextEditingController();
  final controller2 = TextEditingController();
  final controller3 = TextEditingController();
  IsoCode code = IsoCode.PK;

  String errorText = '';
  String errorText2 = '';
  bool isPressed = false;

  String? firstName;
  String? lastName;
  String number="";




  @override
  void initState() {
    _focusNode.addListener(() => setState(() {}));
    _focusNode2.addListener(() => setState(() {}));
    _focusNode3.addListener(() => setState(() {}));
    controller1.addListener(() => setState(() {}));
    controller2.addListener(() => setState(() {}));
    controller3.addListener(() {
      formatNumber();
      setState(() {});
    });

    super.initState();
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
      final phoneNumber = PhoneNumber.parse(text, callerCountry: code);
      final formattedNumber = phoneNumber.formatNsn();
      if (formattedNumber != text) {
        controller3.text = formattedNumber;
      }
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: baseColor,

      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NeumorphicContainer(
                      height: 130,
                      width: 130,
                      backgroundColor: baseColor,

                      borderRadius: BorderRadius.circular(30),
                      child: Center(child: Image.asset("assets/yapter.png")),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        NeumorphicContainer(
                          height: 50,
                          width: double.infinity,
                          backgroundColor: baseColor,
                          isPressed:
                              _focusNode.hasFocus ||
                              controller1.text.isNotEmpty,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: TextFormField(
                              controller: controller1,
                              focusNode: _focusNode,
                              decoration: InputDecoration(
                                hintText: errorText.isEmpty
                                    ? "First Name"
                                    : errorText,
                                hintStyle: TextStyle(
                                  color: errorText.isEmpty
                                      ? Colors.grey.shade800
                                      : Colors.red,
                                ),
                                border: InputBorder.none,
                              ),
                              validator: (val) {
                                if (val==null||val.isEmpty) {
                                  errorText = "First Name is required!";
                                }
                                return null;
                              },
                              onSaved: (val){
                                firstName=val;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 35),
                        NeumorphicContainer(
                          height: 50,
                          width: double.infinity,
                          backgroundColor: baseColor,
                          isPressed:
                              _focusNode2.hasFocus ||
                              controller2.text.isNotEmpty,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                            child: TextFormField(
                              controller: controller2,
                              focusNode: _focusNode2,

                              decoration: InputDecoration(
                                hintText: errorText2.isEmpty
                                    ? "Last Name"
                                    : errorText2,
                                hintStyle: TextStyle(
                                  color: errorText2.isEmpty
                                      ? Colors.grey.shade800
                                      : Colors.red,
                                ),
                                border: InputBorder.none,
                                
                              ),
                              validator: (val) {
                                if (val==null||val.isEmpty) {
                                  errorText2 = "Last Name is required!";
                                }
                                return null;
                              },
                              onSaved: (val){
                                lastName=val;
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 35),
                        NeumorphicContainer(
                          height: 50,
                          width: double.infinity,
                          backgroundColor: baseColor,
                          isPressed:
                              _focusNode3.hasFocus ||
                              controller3.text.isNotEmpty,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CountryCodePicker(
                                onChanged: (country) {
                                  code = IsoCode.values.firstWhere(
                                    (e) => e.name == country.code,
                                  );
                                },

                                pickerStyle: PickerStyle.dialog,
                                dialogBackgroundColor: baseColor,
                                initialSelection: 'PK',
                                searchDecoration: InputDecoration(
                                  contentPadding: EdgeInsetsGeometry.all(8),
                                  hintText: "Search Country eg : PK or +92",
                                  hintStyle: TextStyle(fontSize: 15.0),
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                favorite: ['PK','US'],
                                topBarPadding: EdgeInsets.fromLTRB(20, 10, 15, 10),
                                dialogItemPadding: EdgeInsetsGeometry.fromLTRB(15, 10, 15, 10),
                                searchPadding: EdgeInsetsGeometry.fromLTRB(15, 10, 15, 10),
                                barrierColor: Colors.black54,
                                dialogTextStyle: TextStyle(fontSize: 16.0),

                              ),
                              VerticalDivider(
                                width: 0.2,
                                color: Colors.grey.shade500,
                                indent: 8,
                                endIndent: 8,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextFormField(
                                  controller: controller3,
                                  focusNode: _focusNode3,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: "Enter Phone Number",
                                    border: InputBorder.none,
                                  ),
                                  onSaved: (num) {
                                    final phoneNumber = PhoneNumber.parse(
                                      num!,
                                      callerCountry: code,
                                    );
                                    number=phoneNumber.international;




                                  },
                                  validator: (val) {
                                    final phoneNumber = PhoneNumber.parse(
                                      val!,
                                      callerCountry: code,
                                    );
                                    if (phoneNumber.isValid()) {
                                      return null;
                                    } else {
                                      return "Invalid Phone Number";
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 60),
                        NeumorphicContainer(
                          height: 50,
                          width: 180,

                          backgroundColor: baseColor,
                          isPressed: isPressed,
                          child: ElevatedButton(
                            onPressed: () async {

                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                print(number);

                                dynamic result=await _auth.verifyOTP(number);
                                if(result!=null) {
                                  print(firstName);
                                  print(lastName);
                                  print(number);

                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) =>
                                            VerifyOTP(verificationId: result,phoneNumber: number,firstName: firstName!,lastName: lastName!)));

                                }

                              }



                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                            ),
                            child: Text(
                              "Register",
                              style: TextStyle(color: Colors.grey.shade800),
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
    );
  }
}
