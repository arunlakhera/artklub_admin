import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppResponsive.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentListWidget extends StatefulWidget {
  const StudentListWidget({Key? key}) : super(key: key);

  @override
  _StudentListWidgetState createState() => _StudentListWidgetState();
}

class _StudentListWidgetState extends State<StudentListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,//AppColors.colorLightGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Students',
                style: AppStyles().getTitleStyle(
                  titleWeight: FontWeight.bold,
                  titleColor: AppColors.colorBlack,
                  titleSize: 20,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.colorYellow,
                  borderRadius: BorderRadius.circular(100),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Text(
                  'View All',
                  style: AppStyles().getTitleStyle(
                    titleSize: 16,
                    titleColor: Colors.black,
                    titleWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 0.5,
            color: AppColors.colorLightGrey,
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              /// Table Header
              TableRow(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ))),
                  children: [

                    if(AppResponsive.isDesktop(context))...{
                      tableHeader('Name'),
                      tableHeader('Zone'),
                      tableHeader('Course'),
                      tableHeader('Batch'),
                    }else if(AppResponsive.isTablet(context))...{
                      tableHeader('Name'),
                      tableHeader('Zone'),
                      tableHeader('Course'),
                    }else...{
                      tableHeader('Name'),
                    }

                  ]),

              /// Table Data
              tableRow(
                context,
                studentName: 'Anshul Jain',
                studentImage: 'mascot',
                zoneName: 'Hyderabad',
                courseName: 'Rookie',
                batchName: 'ROO-160321',
              ),

              tableRow(
                context,
                studentName: 'Joy Sharma',
                studentImage: 'mascot',
                zoneName: 'Bangalore',
                courseName: 'Rookie',
                batchName: 'ROO-260521',
              ),

              tableRow(
                context,
                studentName: 'Kapil Pandey',
                studentImage: 'mascot',
                zoneName: 'Hyderabad',
                courseName: 'Innovator',
                batchName: 'INN-060721',
              ),

              tableRow(
                context,
                studentName: 'Zena Kuber',
                studentImage: 'mascot',
                zoneName: 'Bangalore',
                courseName: 'Rookie',
                batchName: 'ROO-160321',
              ),
            ],
          ),

          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing 4 out of 4 results.'
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget tableHeader(text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Text(
        text,
        style: AppStyles().getTitleStyle(
          titleWeight: FontWeight.bold,
          titleColor: AppColors.colorBlack,
          titleSize: 16,
        ),
      ),
    );
  }

  TableRow tableRow(context,
      {studentName, studentImage, zoneName, courseName, batchName}) {
    return TableRow(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(
                    'assets/images/${studentImage}.png',
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(studentName),
              ],
            ),
          ),

          if(AppResponsive.isDesktop(context))...{
            Text(zoneName),
            Text(courseName),
            Text(batchName),
          }else if(AppResponsive.isTablet(context))...{
            Text(zoneName),
            Text(courseName),
          }


        ]);
  }
}
