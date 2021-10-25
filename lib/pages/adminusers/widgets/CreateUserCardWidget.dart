import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:artklub_admin/utilities/AppWidgets.dart';
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

  TextEditingController _emailIdText = TextEditingController();
  TextEditingController _passwordText = TextEditingController();

  var _emailId, _password;
  bool _obscureText = true;
  bool _isLoading = false;

  String _dropDownValue = 'Teacher';
  var _items =  ['Coordinator','Teacher','Zone Coordinator'];

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
                height: 120,
                decoration: BoxDecoration(
                    color: AppColors.colorYellow,
                    borderRadius: BorderRadius.circular(20)
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20),
                    child: Form(
                      key: _createAdminUserFormKey,
                      child: Container(
                        child: Row(
                          children: [

                            _buildLoginEmailIdText(),
                            SizedBox(width: 20),
                            _buildLoginPasswordText(),
                            SizedBox(width: 20),
                            _buildDropDown(),
                            SizedBox(width: 20),
                            _buildCreateAdminUserButton(),

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
      child: SizedBox(
        height: 45,
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
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.green,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.green,
              ),
            ),

          ),
        ),
      ),
    );
  }

  _buildLoginPasswordText() {
    return Expanded(
      child: SizedBox(
        height: 45,
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

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.green,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Colors.green,
              ),
            ),

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
    );
  }

  _buildDropDown() {
    return Container(
      width: 200,
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(width: 1, color: Colors.grey.shade700),
            right: BorderSide(width: 1, color: Colors.grey.shade700),
            top: BorderSide(width: 1, color: Colors.grey.shade700),
            bottom: BorderSide(width: 1, color: Colors.grey.shade700),
          )
      ),
      child: DropdownButton(
        value: _dropDownValue,
        underline: Container(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        icon: Icon(Icons.keyboard_arrow_down),
        items: _items.map((String items){
          return DropdownMenuItem(
            value: items,
            child: Text(
              items,
              style: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.black),
            ),
          );
        }).toList(),
        onChanged: (newValue){
          setState(() {
            _dropDownValue = newValue.toString();
            print(_dropDownValue);
          });
        },
      ),
    );
  }

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
            _services.createAdminUser(_emailId, _password, type)
                .whenComplete(() => _services.createCoordinator(_emailId, _password)).whenComplete(() => resetFields());
          }else if(_dropDownValue == 'Zone Coordinator'){
            type = 'zc';
            _services.createAdminUser(_emailId, _password, type)
                .whenComplete(() => _services.createZoneCoordinator(_emailId, _password)).whenComplete(() => resetFields());

          }else if(_dropDownValue == 'Teacher'){
            type = 't';
            _services.createAdminUser(_emailId, _password, type)
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
    });
  }
}
