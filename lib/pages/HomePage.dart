
import 'package:artklub_admin/pages/LoginPage.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {

  HomePage({Key? key, required this.title}) : super(key: key);

  static const String id = 'home-page';

  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final Future<FirebaseApp> _initialization;

  GlobalKey<FlipCardState> _flipCardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {

    super.initState();
    _initialization = Firebase.initializeApp();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: Provider.of<MenuController>(context, listen: false).scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading:Container(),
        title: Text(
          'Artklub Admin Dashboard',
          style: AppStyles.titleStyleWhite,
        ),
      ),
      body: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Connection Failed',
              ),
            );
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return  Center(
              child: Container(
                height: 500,
                width: 800,
                child:
                LoginPage(flipLoginKey: _flipCardKey),
                // FlipCard(
                //   key: _flipCardKey,
                //   flipOnTouch: false,
                //   direction: FlipDirection.HORIZONTAL,
                //   front: LoginPage(flipLoginKey: _flipCardKey),
                //   back: RegisterPage(flipRegisterKey: _flipCardKey),
                // ),
              ),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

    );
  }
}
