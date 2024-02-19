import 'package:abdhajer/view/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../network/local/cache_helper.dart';
import '../widgets/constant.dart';
import '../widgets/custom_form_field.dart';
import '../widgets/navigation/navigation.dart';
import '../widgets/show_toast.dart';
import 'home.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static TextEditingController userNameController = TextEditingController();
  static TextEditingController passwordController = TextEditingController();
  static bool isValidationPassed = false;

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  Future<void> signInWithEmailAndPassword(String email, String password,context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: LogIn.userNameController.text,
        password: LogIn.passwordController.text,
      );
      CacheHelper.saveData(key: 'token',value: userCredential.user!.uid.toString());
      navigateAndFinish(context, const Home());
    } catch (e) {
      showToast(text: e.toString(), color: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
    Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Image.asset('assets/images/Rectangle 6.png',fit: BoxFit.fill,),
          ),
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color:  const Color(0xFFBCE9F4).withOpacity(0.6),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: LogIn.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 50,),
                      Text('Kidgard',style: TextStyle(color: primaryColor,fontSize: 56),),
                      Text('Stay connected Stay Safe',style: TextStyle(color: primaryColor,fontSize: 16),),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomFormField(
                        icon: const Icon(Icons.email_outlined),
                        hintText: 'example@gmail.com',
                        label: 'Email',
                        validationPassed: LogIn.isValidationPassed,
                        controller: LogIn.userNameController,
                        textInputType: TextInputType.text,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            LogIn.isValidationPassed = true;
                            setState(() {

                            });
                            return 'please input email';
                          }
                        },
                      ),
                      const SizedBox(height: 20,),
                      CustomFormField(
                        icon: const Icon(Icons.remove_red_eye_outlined),
                        hintText: 'write the password',
                        label: 'password',
                        validationPassed: LogIn.isValidationPassed,
                        controller: LogIn.passwordController,
                        textInputType: TextInputType.text,
                        validate: (String? value) {
                          if (value!.isEmpty) {
                            LogIn.isValidationPassed = true;
                            setState(() {});
                            return 'please input password';
                          }
                        },
                      ),
                      const SizedBox(height: 60,),
                      GestureDetector(
                        onTap: (){
                          if (LogIn.formKey.currentState!.validate()) {
                            signInWithEmailAndPassword(
                                LogIn.userNameController.text,
                                LogIn.passwordController.text,
                                context,
                            );
                          }
                        },
                        child: Container(
                          width: 120,
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
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
                              Text('Log In',style: TextStyle(color: primaryColor,fontSize: 12,fontWeight: FontWeight.bold),),
                              const SizedBox(width: 8,),
                              Icon(Icons.done_outline_rounded,color: primaryColor,size: 16,)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  GestureDetector(
                    onTap: (){
                      navigateTo(context, const Register());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('dont have an account ? ',style: TextStyle(color: primaryColor,fontSize: 16,fontWeight: FontWeight.bold),),
                        Text('create account',style: TextStyle(color: Colors.red.shade300,fontSize: 16,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
    );
  }
}
