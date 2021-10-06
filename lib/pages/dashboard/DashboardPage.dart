
import 'package:artklub_admin/common/HeaderWidget.dart';
import 'package:artklub_admin/pages/dashboard/widgets/NotificationCardWidget.dart';
import 'package:artklub_admin/services/SideBarMenu.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  static const String id = 'dashboard-page';

  @override
  Widget build(BuildContext context) {

    SideBarWidget _sideBar = SideBarWidget();
    final ScrollController _firstController = ScrollController();

    return AdminScaffold(
      backgroundColor: AppColors.colorBlack,
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
      sideBar: _sideBar.sideBarMenus(context, DashboardPage.id),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            child: Scrollbar(
              controller: _firstController,
              child: ListView(
                controller: _firstController,
                shrinkWrap: true,
                children: [
                Container(
                    alignment: Alignment.topLeft,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: AppColors.colorBackground,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        HeaderWidget(title: 'Dashboard',),
                        NotificationCardWidget(),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      )
      // SingleChildScrollView(
      //   child: Container(
      //     alignment: Alignment.topLeft,
      //     margin: const EdgeInsets.symmetric(horizontal: 10),
      //     padding: const EdgeInsets.all(10),
      //     height: MediaQuery.of(context).size.height,
      //     decoration: BoxDecoration(
      //       color: AppColors.colorBackground,
      //       borderRadius: BorderRadius.circular(30),
      //     ),
      //     child: Column(
      //       children: [
      //         HeaderWidget(title: 'Dashboard',),
      //         NotificationCardWidget(),
      //
      //       ],
      //     ),
      //   ),
      // )

    );
  }



}

