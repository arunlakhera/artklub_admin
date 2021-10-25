import 'package:artklub_admin/common/HeaderWidget.dart';
import 'package:artklub_admin/model/ScreenArguments.dart';
import 'package:artklub_admin/pages/students/widgets/CreateStudentCardWidget.dart';
import 'package:artklub_admin/pages/students/widgets/StudentsList.dart';
import 'package:artklub_admin/services/SideBarMenu.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({Key? key}) : super(key: key);

  static const String id = 'students-page';

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {

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
        sideBar: _sideBar.sideBarMenus(context, StudentsPage.id,userType: ScreenArguments.userType),
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
              HeaderWidget(title: 'Students'),
              Divider(thickness: 5,),
              Visibility(
                visible: !_createFlag,
                child: _buildPageHeader('Create Student'),
              ),
              Visibility(
                visible: _createFlag,
                child: _buildPageHeader('View All Students'),
              ),
              Divider(thickness: 5),

              Visibility(
                visible: !_createFlag,
                child: StudentsList(),
              ),

              Visibility(
                visible: _createFlag,
                child: CreateStudentCardWidget(),
              ),
            ],
          ),
        )
    );
  }

  Widget _buildPageHeader(title){
    return Card(
      elevation: 5,
      color: AppColors.colorYellow,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.colorYellow,
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
                          ),
                        ),

                        TextSpan(text: ' and '),

                        TextSpan(
                          text: 'Manage',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        TextSpan(text: ' New Coordinators.'),

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
