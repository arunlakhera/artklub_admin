import 'package:artklub_admin/pages/dashboard/DashboardPage.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppResponsive.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:artklub_admin/utilities/AppWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key, required this.flipRegisterKey}) : super(key: key);

  GlobalKey<FlipCardState> flipRegisterKey = GlobalKey<FlipCardState>();

  @override
  _RegisterPageState createState() => _RegisterPageState();
}


class _RegisterPageState extends State<RegisterPage> {

  CollectionReference users = FirebaseFirestore.instance.collection('admin');

  final _registerFormKey = GlobalKey<FormState>();
  late String _name,_phoneNumber,_emailId, _password;

  bool _obscureText = true;
  bool _isSubmitting = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: AppColors.colorWhite,//Colors.grey.shade900,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(3),
        child: Row(
          children: [
            if(!AppResponsive.isMobile(context))
              _buildLoginOption(),
            _buildRegisterForm(),
          ],
        ),
      ),
    );
  }

  _buildLoginOption(){
    return  Container(
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.colorLightGreen,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppWidgets().logoWidget(height: 100, width: 100),

          Text(
            'Get Started',
            style: AppStyles.titleStyleBlack,
          ),

         _loginAccountOptionButton(),

        ],
      ),
    );
  }

  _loginAccountOptionButton(){
    return  Column(
      children: [
        Text('Already have Account?', style: AppStyles().getTitleStyle(titleColor: Colors.black,titleSize: 12, titleWeight: FontWeight.bold),),
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            padding: EdgeInsets.only(left: 50,right: 50),
          ),
          onPressed: (){
            !_isSubmitting ? widget.flipRegisterKey.currentState!.toggleCard() :
            AppWidgets().showScaffoldMessage(context: context,msg: 'User is being created. Please wait!');
          },
          child: Text(
            'Login',
            style: AppStyles.buttonStyleWhite,
          ),
        ),
      ],
    );
  }

  _buildRegisterForm(){
    return Expanded(
      child: Container(
        width: 480,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.colorWhite,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Text(
                'Create',
                style: AppStyles.titleStyleBlack,
              ),
            ),
            Container(
              height: 3,
              width: 25,
              color: Colors.green,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
              child: Form(
                key: _registerFormKey,
                child: Column(
                  children: [

                    _buildLoginNameText(),
                    _buildLoginPhoneNumberText(),
                    _buildLoginEmailIdText(),
                    _buildLoginPasswordText(),
                    SizedBox(height: 20),
                    _buildCreateButton(),
                    SizedBox(height: 20),

                    if(AppResponsive.isMobile(context))
                      _loginAccountOptionButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildLoginNameText() {

    return Padding(
      padding: EdgeInsets.only(left: 10,right: 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          onSaved: (val) => _name = val!,
          validator: (val) => (val!.length < 2) ? "Please provide valid Name" : null,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: "Name",
            labelStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.grey),
            hintText: 'Enter your Name',
            hintStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.grey),
            prefixIcon: Icon(
              Icons.person,
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
  _buildLoginPhoneNumberText() {

    return Padding(
      padding: EdgeInsets.only(top: 10,left: 10,right: 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          onSaved: (val) => _phoneNumber = val!,
          validator: (val) => (val!.length < 10) ? "Please provide valid Phone Number" : null,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: "Phone Number",
            labelStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.grey),
            hintText: 'Enter your Phone Number',
            hintStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.grey),
            prefixIcon: Icon(
              Icons.phone,
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
  _buildLoginEmailIdText() {

    return Padding(
      padding: EdgeInsets.only(top: 10,left: 10,right: 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          onSaved: (val) => _emailId = val!,
          validator: (val) => (!val.toString().contains("@") || val!.length < 1) ? "Please provide valid Username" : null,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: "Email Id",
            labelStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.grey),
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
    return Padding(
      padding: EdgeInsets.only(top: 10 ,left: 10,right: 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(

          onSaved: (val) => _password = val!,
          validator: (val) => val.toString().length < 7 ? "Password Is Too Short" : null,
          obscureText: _obscureText,

          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.black,
            ),
            labelText: 'Password',
            labelStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.grey),

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
              Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.green,),
            ),
          ),


        ),
      ),
    );
  }

  _buildCreateButton() {
    return GestureDetector(
      onTap: (){
        !_isSubmitting ?
        _create():
        AppWidgets().showScaffoldMessage(context: context,msg: 'User is being created. Please wait!');
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.05,
        margin: EdgeInsets.only(left: 10, right: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Create', style: AppStyles.buttonStyleWhite,
        ),
      ),
    );
  }

  _create() {
    final _form = _registerFormKey.currentState;
    if (_form!.validate()) {
      _form.save();
      _registerUser();
    } else {
      print("Form is Invalid");
      _isSubmitting = false;
    }
  }


  Future<void> _registerUser() async {

    if(!mounted) return;
    setState(() {
      _isSubmitting = true;
      EasyLoading.show(status: 'Creating User...');
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailId,
          password: _password,
      );

      if(userCredential.user!.email != null){

        if(!mounted) return;

        setState(() {
          EasyLoading.dismiss();
        });

        print(userCredential);
        print(userCredential.user!.uid);
        print(userCredential.user!.email);
        print(userCredential.user!.phoneNumber);

        Navigator.pushNamed(context, DashboardPage.id);
        // Navigator.push(context, MaterialPageRoute(builder: (context){
        //   return DashboardPage();
        // }));

      }else{
        if(!mounted) return;
        setState(() {
          EasyLoading.dismiss();
        });

        AppWidgets().showAlertErrorWithButton(
          context: context,
          errMessage: 'Could not register user. Please try again!',
        );

      }

      _isSubmitting = false;

    } on FirebaseAuthException catch (e) {

      _isSubmitting = false;

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
        errMessage: 'Error Occured. Please try again',
      );
    }

  }


}
