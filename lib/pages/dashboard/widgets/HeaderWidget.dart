import 'package:artklub_admin/controller/MenuController.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppResponsive.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          if (!AppResponsive.isDesktop(context))
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: Provider.of<MenuController>(context, listen: false)
                  .controlMenu,
            ),
          Text(
            'Dashboard',
            style: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 30,
              titleColor: Colors.black,
            ),
          ),

          if (!AppResponsive.isMobile(context))...{
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(
                color: AppColors.colorLightGreen,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Hyderabad',
                style: AppStyles().getTitleStyle(
                    titleColor: Colors.black,
                    titleSize: 14,
                    titleWeight: FontWeight.w800),
              ),
            ),
          }

        ],
      ),
    );
  }
}
