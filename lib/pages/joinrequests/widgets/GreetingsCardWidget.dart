import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:flutter/material.dart';

class GreetingsCardWidget extends StatefulWidget {
  const GreetingsCardWidget({Key? key}) : super(key: key);

  @override
  State<GreetingsCardWidget> createState() => _GreetingsCardWidgetState();
}

class _GreetingsCardWidgetState extends State<GreetingsCardWidget> {

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
      color: AppColors.colorYellow,
      child: _isLoading ? Center(child: CircularProgressIndicator(),)
          :Container(
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

                Text(
                  'You have $numberOfRequests Pending Join Requests.',
                  style: AppStyles.titleStyleBlack,
                ),

              ],
            ),
            if(MediaQuery.of(context).size.width >= 615)...{
              Spacer(),
              Image.asset(
                'assets/images/notification_image.png',
                height: 100,
              ),
            }

          ],
        ),
      ),
    );
  }
}
