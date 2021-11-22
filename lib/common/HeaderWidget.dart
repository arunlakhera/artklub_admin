import 'package:artklub_admin/model/ScreenArguments.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppResponsive.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

class HeaderWidget extends StatefulWidget {
  HeaderWidget({Key? key, required this.title}) : super(key: key);
  String title;

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
          Text(
            widget.title,
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
                color: AppColors.colorYellow,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                ScreenArguments.userZone,
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
