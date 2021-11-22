import 'package:artklub_admin/model/ScreenArguments.dart';
import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileCardWidget extends StatefulWidget {
  const ProfileCardWidget({Key? key}) : super(key: key);

  @override
  State<ProfileCardWidget> createState() => _ProfileCardWidgetState();
}

class _ProfileCardWidgetState extends State<ProfileCardWidget> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseServices _services = FirebaseServices();

  String? adminName, adminZone, adminImageUrl;
  Timestamp? createdOn;

  bool _isLoading = false;

  Future<void> getAdminName()async{

    setState(() {
      _isLoading = true;
    });

    var adminEmailId = _auth.currentUser!.email;
    var adminType;
    var adminActive;

    await _services.admin.doc(adminEmailId).get().then((value){
      adminType = value.get('type');
      adminActive = value.get('active');
      createdOn = value.get('createdOn');
    });

    if(adminType == 'a'){
      adminName = 'Admin';
      adminZone = 'All Zones';

      ScreenArguments.updateUser(adminEmailId!, adminType, adminZone!, adminActive);

      setState(() {
        _isLoading = false;
      });
    }else if(adminType == 'c'){
      setState(() {
        _isLoading = true;
      });

      await _services.coordinator.doc(adminEmailId).get().then((value){
        setState(() {
          adminName = value.get('name');
          adminZone = value.get('zone');
          adminImageUrl = value.get('userImageUrl');

          if(adminName!.isEmpty){
            adminName = 'Coordinator';
          }
          if(adminZone!.isEmpty){
            adminZone = 'Not Assigned';
          }
          if(adminImageUrl!.isEmpty){
            adminImageUrl = 'NA';
          }
          ScreenArguments.updateUser(adminEmailId!, adminType, adminZone!, adminActive);


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
    }else if(adminType == 't'){
      setState(() {
        _isLoading = true;
      });
      await _services.teacher.doc(adminEmailId).get().then((value){
        setState(() {
          adminName = value.get('name');
          adminZone = value.get('zone');
          adminImageUrl = value.get('userImageUrl');

          if(adminName!.isEmpty){
            adminName = 'Teacher';
          }
          if(adminZone!.isEmpty){
            adminZone = 'Not Assigned';
          }
          if(adminImageUrl!.isEmpty){
            adminImageUrl = 'NA';
          }
          ScreenArguments.updateUser(adminEmailId!, adminType, adminZone!, adminActive);

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
  }

  @override
  void initState() {
    adminImageUrl = 'NA';
    getAdminName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading? Center(child: CircularProgressIndicator(),)
        :Card(
      elevation: 5,
        color: Colors.teal,
          child: Container(
          decoration: BoxDecoration(
              color: AppColors.colorNotificationWidget,
              borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(10),
          child: Column(
              children: [
                Row(
                  children: [
                    (adminImageUrl == 'NA' || adminImageUrl!.isEmpty || adminImageUrl == null) ?
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      child: Image.asset('assets/images/mascot.png',),
                    )
                        :CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        adminImageUrl!,
                      ),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          adminName!.toUpperCase(),
                          style: AppStyles().getTitleStyle(
                            titleSize: 14,
                            titleColor: Colors.grey.shade50,
                            titleWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          adminZone!,
                          style: AppStyles().getTitleStyle(
                            titleSize: 12,
                            titleColor: Colors.grey.shade50,
                            titleWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),

                  ],
                ),

                Divider(
                  thickness: 0.5,
                  color: AppColors.colorYellow,
                ),

                profileListWidget('Joined Date','${createdOn!.toDate().day}/${createdOn!.toDate().month}/${createdOn!.toDate().year}'),
                profileListWidget('Zone',adminZone),
              ],
          ),
    ),
        );
  }

  Widget profileListWidget(text, value){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              text,
              style:AppStyles().getTitleStyle(
            titleSize: 12,
            titleColor: Colors.grey.shade100,
            titleWeight: FontWeight.w300,
          )),
          Text(
            value,
            style: AppStyles().getTitleStyle(
              titleSize: 14,
              titleWeight: FontWeight.bold,
              titleColor: Colors.grey.shade50,
            ),
          )
        ],
      ),
    );
  }
}
