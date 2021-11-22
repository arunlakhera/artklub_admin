import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:artklub_admin/utilities/AppWidgets.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreateZonesCardWidget extends StatefulWidget {
  const CreateZonesCardWidget({Key? key}) : super(key: key);

  @override
  _CreateZonesCardWidgetState createState() => _CreateZonesCardWidgetState();
}

class _CreateZonesCardWidgetState extends State<CreateZonesCardWidget> {

  FirebaseServices _services = FirebaseServices();
  final _createZoneFormKey = GlobalKey<FormState>();
  bool _isVisible = false;
  bool _isLoading = false;

  String countryValue = "Country";
  String stateValue = "State";
  String cityValue = "City";
  String zoneName = '';

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();

    return Container(
      child: _isLoading? Center(child: CircularProgressIndicator(),) :Column(
        children: [
          Divider(thickness: 5,),

          Visibility(
            visible: !_isVisible,
            child: Card(
              elevation: 5,
              color: AppColors.colorNotificationWidget,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.colorNotificationWidget,
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

                                TextSpan(text: ' Zones.'),

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
                              'Create Zone',
                              style: AppStyles().getTitleStyle(titleSize: 14, titleColor: AppColors.colorWhite, titleWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if(MediaQuery.of(context).size.width >= 615)...{
                      Spacer(),
                      Icon(
                        Icons.location_pin,
                        color: AppColors.colorWhite,
                        size: 120,
                      )
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
                decoration: BoxDecoration(
                    color: AppColors.colorYellow,
                    borderRadius: BorderRadius.circular(20)
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: EdgeInsets.only(left: 20, right: 20,top: 10, bottom: 10),
                    child: Form(
                      key: _createZoneFormKey,
                      child: Container(
                        child: Row(
                          children: [

                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    child: CSCPicker(
                                      key: _cscPickerKey,
                                      showStates: true,
                                      showCities: true,

                                      currentCountry: countryValue,
                                      currentState: stateValue,
                                      currentCity: cityValue,

                                      countrySearchPlaceholder: "Country",
                                      stateSearchPlaceholder: "State",
                                      citySearchPlaceholder: "City",

                                      ///labels for dropdown
                                      countryDropdownLabel: "*Country",
                                      stateDropdownLabel: "*State",
                                      cityDropdownLabel: "*City",

                                      dropdownDecoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10),
                                        ),
                                        color: Colors.white,
                                        border:
                                        Border.all(color: Colors.grey.shade300, width: 1),
                                      ),

                                      ///triggers once country selected in dropdown
                                      onCountryChanged: (value) {
                                        setState(() {
                                          ///store value in country variable
                                          countryValue = value;
                                        });
                                      },

                                      ///triggers once state selected in dropdown
                                      onStateChanged: (value) {
                                        setState(() {
                                          ///store value in state variable
                                          stateValue = value!;
                                        });
                                      },

                                      ///triggers once city selected in dropdown
                                      onCityChanged: (value) {
                                        setState(() {
                                          ///store value in city variable
                                          cityValue = value!;
                                          zoneName = cityValue.replaceAll(' ', '_').toUpperCase();
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey.shade300,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Zone : ',
                                              style: AppStyles.tableHeaderStyle,
                                            ),
                                            Text(
                                              zoneName,
                                              style: AppStyles.tableBodyStyle,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.black,
                                              ),
                                              onPressed: (){
                                                setState(() {
                                                  _isVisible = !_isVisible;
                                                });
                                              },
                                              child: Text(
                                                'Cancel',
                                                style: AppStyles.buttonStyleWhite,
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.black,
                                              ),
                                              onPressed: (){
                                                if(zoneName.isNotEmpty){
                                                  _createZone();
                                                }else{
                                                  AppWidgets()
                                                      .showAlertWarningWithButton(
                                                      context: context,
                                                      warnMessage: 'Please Select City Name to create Zone.',
                                                  );
                                                }
                                              },
                                              child: Text(
                                                'Create',
                                                style: AppStyles.buttonStyleWhite,
                                              ),
                                            )
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 25),

                            if(MediaQuery.of(context).size.width >= 615)...{
                              Spacer(),
                              Icon(
                                Icons.location_pin,
                                color: Colors.green,
                                size: 120,
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

  Future<void> _createZone() async {

    if(!mounted) return;

    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Creating...');
    });

    try {

      var result = await _services.createZone(zoneName, countryValue, stateValue, cityValue).whenComplete((){
        setState(() {
          _isLoading = false;
          EasyLoading.dismiss();
        });
      });

      if(result == 'zone_exists'){
        AppWidgets().showAlertWarningWithButton(
          context: context,
          warnMessage: '$zoneName Zone already exists.',
        );
      }else if(result == 'zone_created'){
        AppWidgets().showAlertSuccessWithButton(
          context: context,
          successMessage: '$zoneName Zone Created.',
        );
      }else{
        AppWidgets().showAlertErrorWithButton(
          context: context,
          errMessage: 'Error Occurred. Please try again.',
        );
      }


    } on FirebaseException catch (e) {

      setState(() {
        _isLoading = false;
        EasyLoading.dismiss();
      });
      print(e);
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

}

