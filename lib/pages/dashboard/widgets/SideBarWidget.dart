import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:artklub_admin/utilities/AppWidgets.dart';
import 'package:flutter/material.dart';

class SideBarWidget extends StatefulWidget {
  const SideBarWidget({Key? key}) : super(key: key);

  @override
  _SideBarWidgetState createState() => _SideBarWidgetState();
}

class _SideBarWidgetState extends State<SideBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      child: Container(
        color: AppColors.colorLightGreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              alignment: Alignment.center,
              child: AppWidgets().logoWidget(height: 80, width: 80),
            ),

            DrawerListTile(
              title: 'Dashboard',
              icon: Icons.home,
              press: (){},
            ),

            DrawerListTile(
              title: 'Zone',
              icon: Icons.location_city,
              press: (){},
            ),

            DrawerListTile(
              title: 'Coordinators',
              icon: Icons.group,
              press: (){},
            ),

            DrawerListTile(
              title: 'Teachers',
              icon: Icons.contact_mail,
              press: (){},
            ),

            DrawerListTile(
              title: 'Batches',
              icon: Icons.timer,
              press: (){},
            ),

            DrawerListTile(
              title: 'Students',
              icon: Icons.person,
              press: (){},
            ),

            DrawerListTile(
              title: 'Payments',
              icon: Icons.payment,
              press: (){},
            ),

            Spacer(),
            
            Opacity(
              opacity: 0.7,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/mascot.png',
                  height: 80,
                  width: 80,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {

  final String title;
  final IconData icon;
  final VoidCallback press;

  const DrawerListTile({Key? key, required this.title, required this.icon, required this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(icon, color: Colors.black,),
      title: Text(
        title,
        style: AppStyles().getTitleStyle(titleWeight: FontWeight.w700, titleColor: Colors.black, titleSize: 16),
      ),
    );
  }
}

