import 'dart:async';

import 'package:artklub_admin/pages/dashboard/DashboardPage.dart';
import 'package:artklub_admin/pages/HomePage.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  static const String id = 'splash-page';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  late Timer _timer;

  @override
  void initState() {

    super.initState();

    _timer = Timer(
      Duration(seconds: 2),
          (){
            FirebaseAuth.instance
                .authStateChanges()
                .listen((User? user) {
              if (user == null) {

                Navigator.pushNamed(context, HomePage.id);
                //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => HomePage(title: 'Artklub Admin Dashboard',)));

              } else {

                Navigator.pushNamed(context, DashboardPage.id);
                //Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => DashboardPage()));
              }
            });
          },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/mascot.png', height: 60, width: 60,),
          SizedBox(height: 20,),
          Text(
            'Loading...',
            style: AppStyles.titleStyleBlack,
          ),
        ],
      ),
    );
  }
}
