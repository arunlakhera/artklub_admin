import 'package:artklub_admin/controller/MenuController.dart';
import 'package:artklub_admin/pages/dashboard/Dashboard.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppResponsive.dart';
import 'package:artklub_admin/pages/dashboard/widgets/SideBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBarWidget(),
      key: Provider.of<MenuController>(context, listen: false).scaffoldKey,
      backgroundColor: AppColors.colorLightGreen,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              //Side Navigation Menu only show in Desktop
              if(AppResponsive.isDesktop(context))
                Expanded(child: SideBarWidget(),),

              // Main Body Part
              Expanded(
                flex: 4,
                child: Dashboard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
