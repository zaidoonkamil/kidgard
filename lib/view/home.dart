import 'package:abdhajer/view/welcome.dart';
import 'package:abdhajer/widgets/navigation/navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../network/local/cache_helper.dart';
import '../widgets/constant.dart';
import '../widgets/show_toast.dart';
import 'get_data.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void signOut(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      CacheHelper.saveData(key: 'token',value: 'null');
      navigateAndFinish(context, const WelcomePage());
    } catch (e) {
      showToast(text: e.toString(), color: Colors.red);
    }
  }

  Map<String, dynamic>? userData;
  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userSnapshot.exists) {
        userData = userSnapshot.data()!;
        return userData!;
      } else {
        print('User not found');
        return {};
      }
    } catch (e) {
      showToast(text: e.toString(), color: Colors.red);
      return {};
    }
  }

  @override
  void initState() {
    String token=CacheHelper.getData(key: 'token');
    getUserData(token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Image.asset(
                    'assets/images/Rectangle 12.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            Container(
              width: double.maxFinite,
              height: double.maxFinite,
              color: const Color(0xFFBCE9F4).withOpacity(0.1),
            ),
            SizedBox(
              width: double.maxFinite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                  Theme.of(context).cardColor,
                                  content: SizedBox(
                                    height: 120,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.end,
                                      children: [
                                        const SizedBox(height: 20,),
                                        Row(
                                          children: [
                                            Text(
                                              'Name : ',
                                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15),
                                            ),
                                            Text(
                                              userData!['name'],
                                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8,),
                                        Row(
                                          children: [
                                            Text(
                                              'Email : ',
                                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15),
                                            ),
                                            Text(
                                              userData!['email'],
                                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8,),
                                        Row(
                                          children: [
                                            Text(
                                              'Gender : ',
                                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15),
                                            ),
                                            Text(
                                              userData!['gender'],
                                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.person_outline,
                            color: primaryColor,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            signOut(context);
                          },
                          child: Icon(
                            Icons.logout,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  GestureDetector(
                    onTap: () {
                      navigateTo(context, const GetData());
                    },
                    child: Container(
                      width: 180,
                      height: 40,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.transparent,
                        border: Border.all(
                          color: primaryColor,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'get data',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
