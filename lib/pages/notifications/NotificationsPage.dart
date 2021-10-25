import 'package:artklub_admin/model/ScreenArguments.dart';
import 'package:artklub_admin/services/SideBarMenu.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  static const String id = 'notifications-page';


  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBar = SideBarWidget();

    return AdminScaffold(
        backgroundColor: AppColors.colorBackground,
        appBar: AppBar(
          backgroundColor: AppColors.colorBlack,
          iconTheme: IconThemeData(color: AppColors.colorLightGreen),
          title: Container(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.colorLightGreen,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              'Artklub Admin',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        sideBar: _sideBar.sideBarMenus(context, NotificationsPage.id,userType: ScreenArguments.userType),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.colorBackground,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text('Notifications'),
            ),
          ),
        )
    );
  }
}