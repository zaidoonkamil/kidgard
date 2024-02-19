import 'package:flutter/material.dart';

import '../network/local/cache_helper.dart';
import '../widgets/constant.dart';
import '../widgets/custom_button.dart';
import '../widgets/navigation/navigation.dart';
import 'home.dart';
import 'login.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  String? token;

  @override
  void initState() {
    token=CacheHelper.getData(key: 'token')??'null';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: Image.asset(
              'assets/images/Rectangle 6.png',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            width: double.maxFinite,
            height: double.maxFinite,
            color: const Color(0xFFBCE9F4).withOpacity(0.1),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'K',
                  style: TextStyle(color: primaryColor, fontSize: 32),
                ),
                Text(
                  'i',
                  style: TextStyle(color: primaryColor, fontSize: 32),
                ),
                Text(
                  'd',
                  style: TextStyle(color: primaryColor, fontSize: 32),
                ),
                Text(
                  'g',
                  style: TextStyle(color: primaryColor, fontSize: 32),
                ),
                Text(
                  'a',
                  style: TextStyle(color: primaryColor, fontSize: 32),
                ),
                Text(
                  'r',
                  style: TextStyle(color: primaryColor, fontSize: 32),
                ),
                Text(
                  'd',
                  style: TextStyle(color: primaryColor, fontSize: 32),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomBottom(
                  onTap: () {
                    if(token != 'null' ){
                      navigateAndFinish(context, const Home());
                    }else{
                      navigateAndFinish(context, const LogIn());
                    }
                  },
                  height: 40,
                  text: 'Welcome',
                  colorBottom: primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
