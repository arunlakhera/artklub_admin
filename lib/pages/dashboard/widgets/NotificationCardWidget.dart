import 'package:artklub_admin/pages/joinrequests/JoinRequestsPage.dart';
import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationCardWidget extends StatefulWidget {
  const NotificationCardWidget({Key? key}) : super(key: key);

  @override
  State<NotificationCardWidget> createState() => _NotificationCardWidgetState();
}

class _NotificationCardWidgetState extends State<NotificationCardWidget> {
  
  String? numberOfRequests;
  bool _isLoading = false;
  
  FirebaseServices _services = FirebaseServices();

  Future<void> getJoinRequests()async{

    setState(() {
      _isLoading = true;
    });

    await _services.joinRequest.where('active', isEqualTo: true).get().then((value){
      setState(() {
        numberOfRequests = value.docs.length.toString();
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
    numberOfRequests = '0';
    getJoinRequests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: AppColors.colorNotificationWidget,
      child: _isLoading ? Center(child: CircularProgressIndicator(),)
          :Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.teal,
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
                    style:TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: 'Welcome '),
                    ]
                  ),
                ),
                SizedBox(height: 10,),

                Text(
                  'You have $numberOfRequests Pending Join Requests.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade50,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 10,),

                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, JoinRequestsPage.id);
                  },
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
                height: 125,
              ),
            }

          ],
        ),
      ),
    );
  }
}
