import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

class NotificationCardWidget extends StatelessWidget {
  const NotificationCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.colorYellow,
      ),
      padding: EdgeInsets.all(20),
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
                    TextSpan(text: 'Good Morning, '),
                    TextSpan(
                      text: 'John Doe',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ]
                ),
              ),
              SizedBox(height: 10,),

              Text(
                'Today you have 9 new Join Requests.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10,),

              GestureDetector(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.colorButtonDarkBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Read More',
                    style: AppStyles().getTitleStyle(titleSize: 14, titleColor: AppColors.colorWhite, titleWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          if(MediaQuery.of(context).size.width >= 615)...{
            Spacer(),
            Image.asset(
              'assets/images/notification_image.png',
              height: 160,
            ),
          }

        ],
      ),
    );
  }
}
