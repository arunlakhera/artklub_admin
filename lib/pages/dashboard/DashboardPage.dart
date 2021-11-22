
import 'package:artklub_admin/common/HeaderWidget.dart';
import 'package:artklub_admin/model/ScreenArguments.dart';
import 'package:artklub_admin/pages/dashboard/widgets/NotificationCardWidget.dart';
import 'package:artklub_admin/pages/dashboard/widgets/ProfileCardWidget.dart';
import 'package:artklub_admin/pages/dashboard/widgets/SummaryCardWidget.dart';
import 'package:artklub_admin/services/SideBarMenu.dart';
import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  static const String id = 'dashboard-page';

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  bool _isLoading = false;
  String? loggedUserEmailId, loggedUserType;
  bool? loggedUserActive;
  FirebaseServices _services = FirebaseServices();

  Future<void> getUserDetail() async{

    setState(() {
      _isLoading = true;
    });

   String? userId = FirebaseAuth.instance.currentUser!.email;
    
    await _services.admin
        .doc(userId)
        .get()
        .then((value){
          setState(() {
            loggedUserEmailId = value.get('emailId');
            loggedUserActive = value.get('active');
            loggedUserType = value.get('type');
          });

        }).whenComplete((){
          setState(() {
            _isLoading = false;
          });
        }).onError((error, stackTrace){
          setState(() {
            _isLoading = false;
          });
        });

  }

  @override
  void initState() {
    getUserDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    SideBarWidget _sideBar = SideBarWidget();
    final ScrollController _firstController = ScrollController();

    return AdminScaffold(
      backgroundColor: AppColors.colorBlack,
      appBar: AppBar(
        backgroundColor: AppColors.colorBlack,
        iconTheme: IconThemeData(color: AppColors.colorYellow),
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              color: AppColors.colorYellow,
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
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: AppColors.colorBackground,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: _isLoading? Center(child: CircularProgressIndicator(),):Column(
                      children: [
                        HeaderWidget(title: 'Dashboard',),
                        Divider(thickness: 5,),
                        Container(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: NotificationCardWidget(),
                              ),
                              Expanded(
                                flex: 1,
                                child: ProfileCardWidget(),
                              ),
                            ],
                          ),
                        ),
                        Divider(thickness: 5,),
                        SummaryCardWidget(),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      )
    );
  }
}

