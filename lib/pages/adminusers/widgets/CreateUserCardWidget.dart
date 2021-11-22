import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:artklub_admin/utilities/AppWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreateUserCardWidget extends StatefulWidget {
  const CreateUserCardWidget({Key? key}) : super(key: key);

  @override
  State<CreateUserCardWidget> createState() => _CreateUserCardWidgetState();
}

class _CreateUserCardWidgetState extends State<CreateUserCardWidget> {

  FirebaseServices _services = FirebaseServices();
  final _createAdminUserFormKey = GlobalKey<FormState>();
  bool _isVisible = false;


  String? _zoneDropDownValue;
  List<String> zonesList = ['Select Zone'];
  String? _zone;

  TextEditingController _emailIdText = TextEditingController();
  TextEditingController _passwordText = TextEditingController();

  var _emailId, _password;
  bool _obscureText = true;
  bool _isLoading = false;

  String _dropDownValue = 'Teacher';
  var _items =  ['Coordinator','Teacher','Zone Coordinator'];


  @override
  void initState() {
    _zone = '';
    getAllZones();
    super.initState();
  }

  Future<void> getAllZones() async {
    try {
      setState(() {
        _isLoading = true;
        EasyLoading.show(status: 'Loading...');
      });

      Stream<QuerySnapshot> querySnapshot =
      _services.zones.where('active', isEqualTo: true).snapshots();

      await querySnapshot.forEach((zoneSnapshot) {
        zoneSnapshot.docs.forEach((snap) {
          print(snap.data());
          print(snap.get('zoneName'));
          var snapZone = snap.get('zoneName');

          zonesList.add(snapZone);
        });

        setState(() {
          if (zonesList.length < 1) {
            _zoneDropDownValue = zonesList[0];
            _zone = _zoneDropDownValue;
          } else {
            _zoneDropDownValue = zonesList[0];
            _zone = _zoneDropDownValue;
          }

          _isLoading = false;
          EasyLoading.dismiss();
        });
      });
    } on FirebaseException catch (e) {
      print(e);

      setState(() {
        _isLoading = false;
      });

      AppWidgets().showAlertErrorWithButton(
        context: context,
        errMessage: 'Error Occurred while loading. Please try again!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Divider(thickness: 5,),

          Visibility(
            visible: !_isVisible,
            child: Card(
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

                                TextSpan(text: ' New Admin Users.'),

                              ]
                          ),
                        ),
                        SizedBox(height: 20,),

                        GestureDetector(
                          onTap: (){
                            setState(() {
                              _isVisible = !_isVisible;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                              color: AppColors.colorButtonDarkBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Create Admin User',
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
                        height: 120,
                      ),
                    }

                  ],
                ),
              ),
            ),
          ),

          Visibility(
            visible: _isVisible,
            child: Card(
              elevation: 5,
              color: AppColors.colorYellow,
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                decoration: BoxDecoration(
                    color: AppColors.colorYellow,
                    borderRadius: BorderRadius.circular(20)
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Form(
                      key: _createAdminUserFormKey,
                      child: Container(
                        child: Stack(
                          children: [
                            Positioned(
                              right: 5,
                              child: Image.asset(
                              'assets/images/notification_image.png',
                              height: 120,),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      _buildLoginEmailIdText(),
                                      SizedBox(width: 10),
                                      _buildLoginPasswordText(),

                                    ],
                                  ),

                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      _buildDropDown(),
                                      SizedBox(width: 10),
                                      _buildZoneText(),

                                    ],
                                  ),

                                  SizedBox(height: 5),
                                  _buildCreateAdminUserButton(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ),
              ),
            ),
          ),

          Divider(thickness: 5),
        ],
      ),
    );
  }
  _buildLoginEmailIdText() {

    return Expanded(

      child: Container(
        height: 45,
        width: 150,
        child: Material(
          elevation: 5,
          color: Colors.grey.shade200,
          borderOnForeground: true,

          child: TextFormField(
            onSaved: (val) => _emailId = val!,
            onChanged: (val) => _emailId = val,
            keyboardType: TextInputType.emailAddress,
            controller: _emailIdText,
            style:AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: "Email Id",
              labelStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.black),
              hintText: 'Enter your Email Id',
              hintStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.grey),
              prefixIcon: Icon(
                Icons.mail,
                color: Colors.black,
              ),

              border: InputBorder.none,

            ),
          ),
        ),
      ),
    );
  }

  _buildLoginPasswordText() {
    return Expanded(
      child: Container(
        width: 150,
        height: 45,
        child: Material(
            elevation: 5,
            color: Colors.grey.shade200,
            borderOnForeground: true,

          child: TextFormField(

            onSaved: (val) => _password = val!,
            onChanged: (val) => _password = val,
            obscureText: _obscureText,
            controller: _passwordText,
            style:AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              labelText: 'Password',
              labelStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.black),

              hintText: 'Enter your password',
              hintStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.grey),

              border: InputBorder.none,

              suffixIcon: GestureDetector(
                onTap: () {
                  if(!mounted) return;
                  setState(() {
                    _obscureText = !_obscureText;
                  },);
                },
                child:
                Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade700,),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildZoneText() {
    return Expanded(
      child: Container(
        width: 150,
        height: 45,
        child: Material(
          elevation: 5,
          color: Colors.grey.shade200,
          borderOnForeground: true,
          child: DropdownButton(
            value: _zoneDropDownValue,
            isExpanded: true,
            underline: Container(
              color: Colors.grey.shade200,
            ),
            borderRadius: BorderRadius.circular(10),
            icon: Container(
                padding: EdgeInsets.only(left: 10),
                child: Icon(Icons.keyboard_arrow_down)),
            items: zonesList.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    items,
                    style: AppStyles().getTitleStyle(
                        titleWeight: FontWeight.bold,
                        titleSize: 14,
                        titleColor: Colors.black),
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _zoneDropDownValue = newValue.toString();
                _zone = _zoneDropDownValue;
              });
            },
          ),
        ),
      ),
    );
  }

  _buildDropDown() {
    return Expanded(
      child: Container(
        width: 150,
        height: 45,
        child: Material(
          elevation: 5,
          color: Colors.grey.shade200,
          borderOnForeground: true,
          child: DropdownButton(
            value: _dropDownValue,
            isExpanded: true,
            underline: Container(
              color: Colors.grey.shade200,
            ),
            borderRadius: BorderRadius.circular(10),
            icon: Container(
                padding: EdgeInsets.only(left: 10),
                child: Icon(Icons.keyboard_arrow_down)),
            items: _items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    items,
                    style: AppStyles().getTitleStyle(
                        titleWeight: FontWeight.bold,
                        titleSize: 14,
                        titleColor: Colors.black),
                  ),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _dropDownValue = newValue.toString();
                print(_dropDownValue);
              });
            },
          ),
        ),
      ),
    );
  }
  //
  // _buildDropDown() {
  //   return Container(
  //     width: 200,
  //     height: 45,
  //     child: Material(
  //       elevation: 5,
  //       color: Colors.grey.shade200,
  //       borderOnForeground: true,
  //       child: DropdownButton(
  //         value: _dropDownValue,
  //         isExpanded: true,
  //         underline: Container(
  //           color: Colors.grey.shade200,
  //         ),
  //         borderRadius: BorderRadius.circular(10),
  //         icon: Container(
  //             padding: EdgeInsets.only(left: 10),
  //             child: Icon(Icons.keyboard_arrow_down)),
  //         items: _items.map((String items){
  //           return DropdownMenuItem(
  //             value: items,
  //             child: Text(
  //               items,
  //               style: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.black),
  //             ),
  //           );
  //         }).toList(),
  //         onChanged: (newValue){
  //           setState(() {
  //             _dropDownValue = newValue.toString();
  //             print(_dropDownValue);
  //           });
  //         },
  //       ),
  //     ),
  //   );
  // }

  _buildCreateAdminUserButton() {
    return Row(
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
          ),
          onPressed: (){
            setState(() {

              if(!_isLoading){
                if((_emailId.toString().length < 4) || (_password.toString().length < 7)){
                  AppWidgets().showAlertErrorWithButton(
                      context: context,
                      errMessage: 'Please provide valid Email Id and Password.'
                  );
                }else{
                  _createAdminUser();
                }
              }
            });

          },
          child: Text(
            'Create',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.black,
          ),
          onPressed: (){
            setState(() {
              _isVisible = false;
            });

          },
          child: Text(
            'Cancel',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _createAdminUser() async {

    if(!mounted) return;

    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Creating...');
    });

    try {

      // Create User data to save
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailId,
        password: _password,
      ).then((value){

        if(value.user!.email != null){

          // check type of user and save User data based on type
          // reset the fields after saving the data.
          String type = 't';
          if(_dropDownValue == 'Coordinator'){
            type = 'c';
            _services.createAdminUser(_emailId, _password, type, _zone)
                .whenComplete(() => _services.createCoordinator(_emailId, _password)).whenComplete(() => resetFields());
          }else if(_dropDownValue == 'Zone Coordinator'){
            type = 'zc';
            _services.createAdminUser(_emailId, _password, type, _zone)
                .whenComplete(() => _services.createZoneCoordinator(_emailId, _password)).whenComplete(() => resetFields());

          }else if(_dropDownValue == 'Teacher'){
            type = 't';
            _services.createAdminUser(_emailId, _password, type, _zone)
                .whenComplete(() => _services.createTeacher(_emailId, _password)).whenComplete(() => resetFields());
          }

          setState(() {
            EasyLoading.dismiss();
          });

          // Show Success Message to user
          return AppWidgets().showAlertSuccessWithButton(
            context: context,
            successMessage: 'User Details for $_dropDownValue has been saved.'
          );
        }

        return AppWidgets().showScaffoldMessage(context: context,msg: 'Please Try Again.');

      }).catchError((error){
        print(error);
      });

    } on FirebaseAuthException catch (e) {

      _isLoading = false;

      if (e.code == 'weak-password') {
        if(!mounted) return;
        setState(() {
          EasyLoading.dismiss();
        });
        print('The password provided is too weak.');

        AppWidgets().showAlertErrorWithButton(
          context: context,
          errMessage: 'Please provide strong Password!',
        );

      } else if (e.code == 'email-already-in-use') {
        if(!mounted) return;
        setState(() {
          EasyLoading.dismiss();
        });
        print('The account already exists for that email.');

        AppWidgets().showAlertErrorWithButton(
          context: context,
          errMessage: 'The account already exists for that email.',
        );
      }
    } catch (e) {
      print(e);
      if(!mounted) return;
      setState(() {
        EasyLoading.dismiss();
      });
      AppWidgets().showAlertErrorWithButton(
        context: context,
        errMessage: 'Error Occurred. Please try again',
      );
    }

  }

  resetFields() {
    setState(() {
      _emailIdText.clear();
      _passwordText.clear();
      _emailId = '';
      _password ='';
      _isLoading = false;
      _dropDownValue = 'Teacher';
      _zoneDropDownValue = zonesList[0];
    });
  }
}
