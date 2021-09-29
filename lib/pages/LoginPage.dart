import 'package:artklub_admin/pages/dashboard/DashboardPage.dart';
import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:artklub_admin/utilities/AppWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key, required this.flipLoginKey}) : super(key: key);

  GlobalKey<FlipCardState> flipLoginKey = GlobalKey<FlipCardState>();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  FirebaseServices _services = FirebaseServices();

  final _loginFormKey = GlobalKey<FormState>();
  late String _emailId, _password;

  var _emailIdTextController = TextEditingController();
  var _passwordTextController = TextEditingController();


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
      color: AppColors.colorWhite, //Colors.grey.shade900,
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
            //if(!AppResponsive.isMobile(context))
            _buildCreateAccountOption(),
            _buildLoginForm(),

          ],
        ),
      ),
    );
  }

  _buildCreateAccountOption() {
    return Container(
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
            'Welcome to ArtKlub',
            style: AppStyles.titleStyleBlack,
          ),

         // _createAccountOptionButton(),
        ],
      ),
    );
  }

  _createAccountOptionButton(){
    return Column(
      children: [
        Text(
            'Want to Register with us?'
        ),
        SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            padding: EdgeInsets.only(left: 50,right: 50),
          ),
          onPressed: (){
            widget.flipLoginKey.currentState!.toggleCard();
          },
          child: Text(
            'Create Account',
            style: AppStyles.buttonStyleWhite,
          ),
        )

      ],
    );
  }

  _buildLoginForm() {
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
              padding: EdgeInsets.only(
                  top: 10, left: 10, right: 10, bottom: 10),
              child: Text(
                'Login',
                style: AppStyles.titleStyleBlack,
              ),
            ),
            Container(
              height: 3,
              width: 25,
              color: Colors.green,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    _buildLoginEmailIdText(),
                    _buildLoginPasswordText(),
                    SizedBox(height: 50),
                    _buildLoginButton(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // if(AppResponsive.isMobile(context))
            //   _createAccountOptionButton()
          ],
        ),
      ),
    );
  }

  _buildLoginEmailIdText() {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          onSaved: (val) => _emailId = val!,
          controller: _emailIdTextController,
          validator: (val) =>
          (!val.toString().contains("@") || val!.length < 1)
              ? "Please provide valid Username"
              : null,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: "Email Id",
            labelStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.grey),
            hintText: 'Enter your Email Id',
            hintStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.grey),
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
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        child: TextFormField(
          controller: _passwordTextController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.black,
            ),
            labelText: 'Password',
            labelStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.grey),

            hintText: 'Enter your password',
            hintStyle: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.grey),

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
              Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.green,),
            ),
          ),

          onSaved: (val) => _password = val!,
          validator: (val) =>
          val
              .toString()
              .length < 7 ? "Password Is Too Short" : null,
          obscureText: _obscureText,

        ),
      ),
    );
  }

  _buildLoginButton() {
    return GestureDetector(
      onTap: (){
        !_isSubmitting ? _login():
        AppWidgets().showScaffoldMessage(context: context,msg: 'Trying to login the user. Please wait!');
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
          'Login', style: AppStyles.buttonStyleWhite,
        ),
      ),
    );
  }

  _login() {
    final _form = _loginFormKey.currentState;
    if (_form!.validate()) {
      _form.save();
      _loginUser(emailId: _emailIdTextController.text, password: _passwordTextController.text);
    }else {
      print("Form is Invalid");
    }
  }

  _loginUser({emailId, password}) async{

    if(!mounted) return;

    setState(() {
      EasyLoading.show(status: 'Logging In...');
    });

    try {

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailId,
          password: _password,
      );

      if(userCredential.user != null){

        setState(() {
          EasyLoading.dismiss();
        });

        Navigator.pushNamed(context, DashboardPage.id);

        // Navigator.push(context, MaterialPageRoute(builder: (context){
        //   return DashboardPage();
        // }));

      }else{

        setState(() {
          EasyLoading.dismiss();
        });

        AppWidgets().showAlertErrorWithButton(
          context: context,
          errMessage: 'Please provide valid Username and Password!',
        );
      }

    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        setState(() {
          EasyLoading.dismiss();
        });

        AppWidgets().showAlertErrorWithButton(
          context: context,
          errMessage: 'No user found for that email.',
        );
      } else if (e.code == 'wrong-password') {
        setState(() {
          EasyLoading.dismiss();
        });

        print('Wrong password provided for that user.');
        AppWidgets().showAlertErrorWithButton(
          context: context,
          errMessage: 'Wrong password provided for that user.',
        );
      }
    }
  }
}
