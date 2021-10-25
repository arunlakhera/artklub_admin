import 'package:artklub_admin/common/HeaderWidget.dart';
import 'package:artklub_admin/model/ScreenArguments.dart';
import 'package:artklub_admin/pages/zones/widgets/CreateZonesCardWidget.dart';
import 'package:artklub_admin/pages/zones/widgets/ZonesList.dart';
import 'package:artklub_admin/services/SideBarMenu.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class ZonesPage extends StatefulWidget {
  const ZonesPage({Key? key}) : super(key: key);

  static const String id = 'zones-page';

  @override
  State<ZonesPage> createState() => _ZonesPageState();
}

class _ZonesPageState extends State<ZonesPage> {
  SideBarWidget _sideBar = SideBarWidget();
  final ScrollController _firstController = ScrollController();

  @override
  Widget build(BuildContext context) {

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
      sideBar: _sideBar.sideBarMenus(context, ZonesPage.id,userType: ScreenArguments.userType),
      body: Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: AppColors.colorBackground,
          borderRadius: BorderRadius.circular(30),
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: Scrollbar(
                controller: _firstController,
                child: ListView(
                  controller: _firstController,
                  children: [
                    HeaderWidget(title: 'Zones'),
                    // Create New Admin User
                    CreateZonesCardWidget(),
                    // List of Admin Users
                    ZonesList(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
