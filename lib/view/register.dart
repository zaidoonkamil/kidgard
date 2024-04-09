import 'package:abdhajer/view/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/constant.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/navigation/navigation.dart';
import '../widgets/show_toast.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController genderController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static TextEditingController emailController = TextEditingController();
  static bool isValidationPassed = false;
  static List<String> gender = ['Mail', 'Female'];

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {


  Future<void> signUpAndSaveData(context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.
      createUserWithEmailAndPassword(
        email: Register.emailController.text,
        password: Register.passwordController.text,
      );


      await FirebaseFirestore.instance.collection('users').doc(
          userCredential.user!.uid).set({
        'name': Register.userNameController.text,
        'email': Register.emailController.text,
        'gender': Register.genderController.text,
      });
      showToast(text: 'account creation was completed successfully', color: Colors.green);
      navigateAndFinish(context, const LogIn());
    } catch (e) {
      showToast(text: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Image.asset(
              'assets/images/Rectangle 6.png', fit: BoxFit.fill,),
          ),
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: const Color(0xFFBCE9F4).withOpacity(0.6),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: Register.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100,),
                    Text('   WELCOME ... ',
                      style: TextStyle(color: primaryColor, fontSize: 26),),
                    const SizedBox(height: 120,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomFormField(
                          icon: const Icon(Icons.person_outline),
                          hintText: 'write the name of your child',
                          label: 'Name',
                          controller: Register.userNameController,
                          validationPassed: Register.isValidationPassed,
                          textInputType: TextInputType.text,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              Register.isValidationPassed = true;
                              setState(() {});
                              return 'please input email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        CustomFormField(
                          icon: const Icon(Icons.email_outlined),
                          hintText: 'example@gmail.com',
                          label: 'Email',
                          validationPassed: Register.isValidationPassed,
                          controller: Register.emailController,
                          textInputType: TextInputType.text,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              Register.isValidationPassed = true;
                              setState(() {});
                              return 'please input email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        CustomFormField(
                          icon: const Icon(
                              Icons.arrow_drop_down_circle_outlined),
                          hintText: 'choose your childe gender',
                          label: 'Gender',
                          validationPassed: Register.isValidationPassed,
                          controller: Register.genderController,
                          textInputType: TextInputType.none,
                          onTap: () {
                            showModalBottomSheet<void>(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20.0),
                                ),
                              ),
                              context: context,
                              builder: (BuildContext context) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'Gender',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor),
                                      ),
                                      const SizedBox(height: 10),
                                      Expanded(
                                        child: ListView.separated(
                                          physics:
                                          const BouncingScrollPhysics(),
                                          itemCount: Register.gender.length,
                                          separatorBuilder:
                                              (BuildContext context,
                                              int index) =>
                                          const Divider(
                                            height: 1,
                                          ),
                                          itemBuilder: (context, index) {
                                            return Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                              children: [
                                                const SizedBox(height: 10),
                                                GestureDetector(
                                                  onTap: () {
                                                    Register.genderController.text = Register.gender[index];
                                                    navigateBack(context);
                                                  },
                                                  child: Center(
                                                      child: Text(
                                                        Register.gender[index],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                            FontWeight.bold),
                                                      )),
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              Register.isValidationPassed = true;
                              setState(() {});
                              return 'please input email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20,),
                        CustomFormField(
                          icon: const Icon(Icons.remove_red_eye_outlined),
                          hintText: 'write the password',
                          label: 'password',
                          validationPassed: Register.isValidationPassed,
                          controller: Register.passwordController,
                          textInputType: TextInputType.text,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              Register.isValidationPassed = true;
                              setState(() {});
                              return 'please input password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 60,),
                        GestureDetector(
                          onTap: () {
                            if (Register.formKey.currentState!.validate()) {
                              signUpAndSaveData(context);
                            }
                          },
                          child: Container(
                            width: 120,
                            height: 40,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent,
                              border: Border.all(
                                color: primaryColor,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Sign Up', style: TextStyle(
                                    color: primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),),
                                const SizedBox(width: 8,),
                                Icon(Icons.done_outline_rounded,
                                  color: primaryColor, size: 16,)
                              ],
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
        ],
      ),
    )
    );
  }
}
