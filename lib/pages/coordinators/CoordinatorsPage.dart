import 'package:artklub_admin/common/HeaderWidget.dart';
import 'package:artklub_admin/model/ScreenArguments.dart';
import 'package:artklub_admin/pages/coordinators/widgets/CoordinatorsList.dart';
import 'package:artklub_admin/pages/coordinators/widgets/CreateCoordinatorCardWidget.dart';
import 'package:artklub_admin/services/SideBarMenu.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class CoordinatorsPage extends StatefulWidget {
  const CoordinatorsPage({Key? key}) : super(key: key);

  static const String id = 'coordinators-page';

  @override
  State<CoordinatorsPage> createState() => _CoordinatorsPageState();
}

class _CoordinatorsPageState extends State<CoordinatorsPage> {

  SideBarWidget _sideBar = SideBarWidget();
  bool _createFlag = false;

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
        sideBar: _sideBar.sideBarMenus(context, CoordinatorsPage.id,userType: ScreenArguments.userType),
        body: Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: AppColors.colorBackground,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              HeaderWidget(title: 'Coordinators'),
              Divider(thickness: 5,),
              Visibility(
                visible: !_createFlag,
                child: _buildPageHeader('Create Coordinator'),
              ),
              Visibility(
                visible: _createFlag,
                child: _buildPageHeader('View All Coordinators'),
              ),
              Divider(thickness: 5),

              Visibility(
                visible: !_createFlag,
                child: CoordinatorsList(),
              ),

              Visibility(
                visible: _createFlag,
                child: CreateCoordinatorCardWidget(),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildPageHeader(title){
    return Card(
      elevation: 5,
      color: AppColors.colorNotificationWidget,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.colorNotificationWidget,
        ),
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                      style:TextStyle(fontSize: 16, color: Colors.black),
                      children: [

                        TextSpan(
                          text: 'Create',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        TextSpan(
                            text: ' and ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                        ),

                        TextSpan(
                          text: 'Manage',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                        TextSpan(
                          text: ' New Coordinators.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),

                      ]
                  ),
                ),
                SizedBox(height: 20,),

                GestureDetector(
                  onTap: (){
                    setState(() {
                      _createFlag = !_createFlag;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: AppColors.colorButtonDarkBlue,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      title,
                      style: AppStyles().getTitleStyle(titleSize: 14, titleColor: AppColors.colorWhite, titleWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            if(MediaQuery.of(context).size.width >= 615)...{
              Spacer(),
              Image.asset(
                'assets/images/coordinator.png',
                height: 120,
              ),
            }

          ],
        ),
      ),
    );
  }

}
