import 'package:artklub_admin/controller/MenuController.dart';
import 'package:artklub_admin/pages/LoginPage.dart';
import 'package:artklub_admin/pages/RegisterPage.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MenuController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Artklub Admin Dashboard',
        theme: ThemeData(
          primaryColor: Colors.black,
        ),
        home: MyHomePage(title: 'Artklub Admin Dashboard'),
        builder: EasyLoading.init(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  GlobalKey<FlipCardState> _flipCardKey = GlobalKey<FlipCardState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Provider.of<MenuController>(context, listen: false).scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: AppStyles.titleStyleWhite,
        ),
      ),
      body: Center(
        child: Container(
          height: 500,
          width: 800,
          child: FlipCard(
            key: _flipCardKey,
            flipOnTouch: false,
            direction: FlipDirection.HORIZONTAL,
            front: LoginPage(flipLoginKey: _flipCardKey),
            back: RegisterPage(flipRegisterKey: _flipCardKey),
          ),
        ),
      ),
    );
  }
}
