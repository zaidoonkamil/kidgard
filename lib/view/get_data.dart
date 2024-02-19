import 'dart:async';

import 'package:abdhajer/network/remote/dio_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../network/local/cache_helper.dart';
import '../widgets/constant.dart';
import '../widgets/show_toast.dart';

class GetData extends StatefulWidget {
  const GetData({super.key});

  @override
  State<GetData> createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {

  bool loading=false;
  bool loading2=false;
  Position? cl;
  double latitude = 0;
  double longitude = 0;
  double temperature = 0;

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
  //map<-----------------------------
  CameraPosition? kGooglePlex=const CameraPosition(
    target: LatLng(33.604040, 43.848570),
    zoom: 6.0,
  );
  GoogleMapController? _mapController;
  void getLatAndLong() async {
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        print('Location permissions denied by the user.');
        return;
      }
    }

    try {
      // cl = await Geolocator.getCurrentPosition();
      // latitude = cl!.latitude;
      // longitude = cl!.longitude;
      // kGooglePlex = CameraPosition(
      //   target: LatLng(latitude, longitude),
      //   zoom: 14.4746,
      // );
      setState(() {});
    } catch (e) {
      showToast(text: e.toString(), color: Colors.red);
    }
  }
  getLocationOfKid() {
    DioHelper.getData(
      url: '/v3/users/gps_project/devices/gps/resources/location',
      token: tokenL
    ).then((value) {
      if (value.data.containsKey('lat') && value.data.containsKey('lon')) {
        latitude = value.data['lat'];
        longitude = value.data['lon'];
        loading = true;
        setState(() {});
      } else {
        showToast(text: 'Invalid response format', color: Colors.red);
      }
    }).catchError((error) {
      showToast(text: error.toString(), color: Colors.red);
    });
  }

  getTemperatureOfKid() {
    DioHelper.getData(
      url: '/v3/users/gps_project/devices/gps/resources/SHT31',
      token: tokenT
    ).then((value) {
      if (value.data.containsKey('Temperature') ) {
        temperature = value.data['Temperature'];
        loading2 = true;
        setState(() {});
      } else {
        showToast(text: 'Invalid response format', color: Colors.red);
      }
    }).catchError((error) {
      showToast(text: error.toString(), color: Colors.red);
    });
  }

  @override
  void initState() {
    String token=CacheHelper.getData(key: 'token');
    getLatAndLong();
    getLocationOfKid();
    getTemperatureOfKid();
    getUserData(token);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [ primaryColor2, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Row(
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
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'current location   ',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset('assets/images/Vector (7).png'),
                        ],
                      ),
                      const SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SizedBox(
                          height: 180,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child:latitude ==0?GoogleMap(
                              mapType: MapType.hybrid,
                              initialCameraPosition: kGooglePlex!,
                              onMapCreated: (GoogleMapController controller) {
                                _mapController=controller;
                              },
                              zoomControlsEnabled: false,
                              markers:  {
                                const Marker(
                                  markerId: MarkerId("1"),
                                  position: LatLng(
                                    33.604040,
                                    43.848570 ,
                                  ),
                                  infoWindow: InfoWindow(title: 'موقع الطفل'),
                                ),
                              },
                            ):GoogleMap(
                            mapType: MapType.hybrid,
                            initialCameraPosition: kGooglePlex!,
                            onMapCreated: (GoogleMapController controller) {
                              _mapController=controller;
                            },
                            zoomControlsEnabled: false,
                            markers:  {
                               Marker(
                                markerId: const MarkerId("1"),
                                position: LatLng(
                                  latitude,
                                  longitude,
                                ),
                                infoWindow: const InfoWindow(title: 'موقع الطفل'),
                              ),
                            },
                          ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Temperature  ',
                            style: TextStyle(
                                color: primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                          Image.asset('assets/images/Vector (6).png'),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        height: 300,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/Ellipse 1.png'),
                                const SizedBox(height: 10,),
                              ],
                            ),
                            Image.asset('assets/images/Ellipse 2.png'),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(width: 80,),
                                    Image.asset('assets/images/tabler_temperature-celsius.png'),
                                  ],
                                ),
                                Text(
                                 temperature ==0? '29.2':
                                 double.parse(temperature.toString()).toStringAsFixed(1),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 30,),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}
