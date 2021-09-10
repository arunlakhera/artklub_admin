import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:flutter/material.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: Image.asset(
                  'assets/images/mascot.png',
                  height: 60,
                  width: 60,
                ),
              ),
              SizedBox(width: 10),
              Column(
                children: [
                  Text(
                    'Kathy Walker',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Zone Coordinator'
                  ),
                ],
              ),

            ],
          ),

          Divider(
            thickness: 0.5,
            color: AppColors.colorBlack,
          ),

          profileListWidget('Joined Date','18-Apr-2020'),
          profileListWidget('Zone','Hyderabad'),
        ],
      ),
    );
  }

  Widget profileListWidget(text, value){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.colorBlack,
            ),
          )
        ],
      ),
    );
  }
}
