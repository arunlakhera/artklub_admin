import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AppWidgets{

  logoWidget({var height, var width}){
    return Image(
      image: AssetImage('assets/images/artklub_logo.png'),
      height: height,
      width: width,
    );
  }

  showAlertErrorWithButton({context,errMessage}){
    return Alert(
      context: context,
      type: AlertType.error,
      title: "Error!",
      desc: errMessage,
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  showAlertWarningWithButton({context,warnMessage}){
    return Alert(
      context: context,
      type: AlertType.warning,
      title: "Warning!",
      desc: warnMessage,
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  showAlertSuccessWithButton({context,successMessage}){
    return Alert(
      context: context,
      type: AlertType.success,
      title: "Success!",
      desc: successMessage,
      buttons: [
        DialogButton(
          child: Text(
            "Ok",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  showScaffoldMessage({context, msg}){
    return ScaffoldMessenger.of(context)
        .showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(msg),
        ),
    );
  }


}