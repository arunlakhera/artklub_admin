import 'package:artklub_admin/model/DroppedFile.dart';
import 'package:artklub_admin/pages/zonemanager/widgets/CreateZoneManagerCardWidget.dart';
import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:artklub_admin/utilities/AppWidgets.dart';
import 'package:artklub_admin/utilities/DroppedFileWidget.dart';
import 'package:artklub_admin/utilities/DropzoneWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreateTeachersCardWidget extends StatefulWidget {
  const CreateTeachersCardWidget({Key? key}) : super(key: key);

  @override
  _CreateTeachersCardWidgetState createState() => _CreateTeachersCardWidgetState();
}

class _CreateTeachersCardWidgetState extends State<CreateTeachersCardWidget> {
  final ScrollController _firstController = ScrollController();
  FirebaseServices _services = FirebaseServices();

  bool _isLoading = false;

  String? _zoneDropDownValue;

  List<String> zonesList = ['Select Zone'];
  var _selectedGender;
  DroppedFile? teacherImageName;

  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _phoneNumberTextController = TextEditingController();
  TextEditingController _emailIdTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _cityTextController = TextEditingController();
  TextEditingController _stateTextController = TextEditingController();
  TextEditingController _zipcodeTextController = TextEditingController();
  TextEditingController _countryTextController = TextEditingController();

  bool _obscureText = true;

  String? _name,
      _phoneNumber,
      _emailId,
      _password,
      _gender,
      _address,
      _city,
      _state,
      _country,
      _zipcode,
      _zone,
      userImageUrl;

  @override
  void initState() {
    _name = '';
    _phoneNumber = '';
    _emailId = '';
    _password = '';
    _gender = '';
    _address = '';
    _city = '';
    _state = '';
    _country = '';
    _zipcode = '';
    _zone = '';
    _selectedGender = '';
    userImageUrl = '';

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
    return Expanded(
      child: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              width: constraints.maxWidth,
              child: Scrollbar(
                controller: _firstController,
                showTrackOnHover: true,
                child: ListView(
                  children: [
                    Row(
                      children: [
                        _buildImageCardSection(),
                        _buildDetailCardSection(),
                        _buildSummaryCardSection(),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  _buildImageCardSection() {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 5,
        color: Colors.grey.shade200,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.grey.shade200, //Color(0xffB8D8BA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropzoneWidget(
            onDroppedFile: (fileName) => setState(() {
              this.teacherImageName = fileName;
            }),
          ),
        ),
      ),
    );
  }

  _buildDetailCardSection() {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 5,
        color: Colors.grey.shade200, //Color(0xffBD9DBBC),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          alignment: Alignment.center,
          child: ListView(
            children: [
              Column(
                children: [
                  _buildNameText(),
                  _buildPhoneNumberText(),
                  _buildGenderText(),
                  _buildEmailIdText(),
                  _buildPasswordText(),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildZoneText(),
                        ),
                      ],
                    ),
                  ),
                  _buildAddressText(),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 2),
                            child: _buildCityText(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(left: 2, right: 10),
                            child: _buildZipCodeText(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 2),
                            child: _buildStateText(),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(left: 2, right: 10),
                            child: _buildCountryText(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildSummaryCardSection() {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 5,
        color: Colors.grey.shade200,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.grey.shade200, //Color(0xffB8D8BA),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            margin: EdgeInsets.all(3),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Teacher Details',
                            style: AppStyles.tableHeaderStyle,
                          ),
                          Container(
                            width: 25,
                            height: 2,
                            color: Colors.green,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 3),
                            padding: EdgeInsets.symmetric(
                                vertical: 2, horizontal: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DroppedFileWidget(
                                fileName: teacherImageName),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _cardField(
                                      label: 'Name', value: _name.toString()),
                                  _cardField(
                                      label: 'Phone Number',
                                      value: _phoneNumber.toString()),
                                  _cardField(
                                      label: 'Gender',
                                      value: _gender.toString()),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.only(
                          left: 5, right: 5, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _cardField(
                              label: 'Email Id', value: _emailId.toString()),
                          _cardField(
                              label: 'Address', value: _address.toString()),
                          _cardField(label: 'City', value: _city.toString()),
                          _cardField(label: 'State', value: _state.toString()),
                          _cardField(
                              label: 'ZipCode/PinCode',
                              value: _zipcode.toString()),
                          _cardField(
                              label: 'Country', value: _country.toString()),
                          _cardField(label: 'Zone', value: _zone.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () {
                        _createTeacher(context);
                      },
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Create',
                        style: AppStyles.buttonStyleWhite,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildNameText() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        borderOnForeground: true,
        child: TextFormField(
          onSaved: (val) => _name = val!,
          onChanged: (value) {
            setState(() {
              _name = value;
            });
          },
          controller: _nameTextController,
          validator: (val) =>
          (val!.length < 2) ? "Please provide valid Name" : null,
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          style: AppStyles().getTitleStyle(
            titleWeight: FontWeight.bold,
            titleSize: 14,
            titleColor: Colors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            //Color(0xffB4CEB3),//Colors.grey.shade900,
            labelText: "Name",
            labelStyle: AppStyles().getTitleStyle(
                titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.black),
            hintText: 'Enter Name',
            hintStyle: AppStyles().getTitleStyle(
                titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.grey.shade700),
            prefixIcon: Icon(
              Icons.person,
              color: Colors.green,
              size: 15,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffB4CEB3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildPhoneNumberText() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        child: TextFormField(
          onSaved: (val) => _phoneNumber = val!,
          onChanged: (value) {
            setState(() {
              _phoneNumber = value;
            });
          },
          controller: _phoneNumberTextController,
          validator: (val) =>
          (val!.length < 10) ? "Please provide valid Phone Number" : null,
          keyboardType: TextInputType.phone,
          style: AppStyles().getTitleStyle(
            titleWeight: FontWeight.bold,
            titleSize: 14,
            titleColor: Colors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            //Color(0xffB4CEB3),
            labelText: "Phone Number",
            labelStyle: AppStyles().getTitleStyle(
                titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.black),
            hintText: 'Enter Phone Number',
            hintStyle: AppStyles().getTitleStyle(
                titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.grey.shade700),
            prefixIcon: Icon(
              Icons.phone,
              color: Colors.green,
              size: 15,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffB4CEB3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildEmailIdText() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        child: TextFormField(
          onSaved: (val) => _emailId = val!,
          onChanged: (value) {
            setState(() {
              _emailId = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          controller: _emailIdTextController,
          style: AppStyles().getTitleStyle(
            titleWeight: FontWeight.bold,
            titleSize: 14,
            titleColor: Colors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            //Color(0xffB4CEB3),
            labelText: "Email Id [required]",
            labelStyle: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 14,
              titleColor: Colors.black,
            ),
            hintText: 'Enter Email Id',
            hintStyle: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 14,
              titleColor: Colors.grey.shade700,
            ),
            prefixIcon: Icon(
              Icons.mail,
              color: Colors.green,
              size: 15,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffB4CEB3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildZoneText() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
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
    );
  }

  _buildPasswordText() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        child: TextFormField(
          onSaved: (val) => _password = val!,
          validator: (val) =>
          val.toString().length < 7 ? "Password Is Too Short" : null,
          obscureText: _obscureText,
          onChanged: (value) {
            setState(() {
              _password = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          controller: _passwordTextController,
          style: AppStyles().getTitleStyle(
            titleWeight: FontWeight.bold,
            titleSize: 14,
            titleColor: Colors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            //Color(0xffB4CEB3),
            labelText: 'Password [required]',
            labelStyle: AppStyles().getTitleStyle(
                titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.black),

            hintText: 'Enter password',
            hintStyle: AppStyles().getTitleStyle(
                titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.grey),

            prefixIcon: Icon(
              Icons.lock,
              color: Colors.green,
              size: 15,
            ),

            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffB4CEB3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),

            suffixIcon: GestureDetector(
              onTap: () {
                if (!mounted) return;
                setState(
                      () {
                    _obscureText = !_obscureText;
                  },
                );
              },
              child: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.green,
                size: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildGenderText() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Material(
        elevation: 5,
        color: Colors.grey.shade200, //Color(0xffB4CEB3),
        borderOnForeground: true,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ListTile(
                title: Text(
                  'Female',
                  style: AppStyles().getTitleStyle(
                    titleWeight: FontWeight.bold,
                    titleSize: 14,
                    titleColor: Colors.black,
                  ),
                ),
                leading: Radio(
                  value: Gender.Female.toString(),
                  overlayColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.colorLightGreen),
                  fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.pink),
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value.toString();
                      _gender = 'Female';
                    });
                  },
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListTile(
                title: Text(
                  'Male',
                  style: AppStyles().getTitleStyle(
                    titleWeight: FontWeight.bold,
                    titleSize: 14,
                    titleColor: Colors.black,
                  ),
                ),
                leading: Radio(
                  overlayColor: MaterialStateColor.resolveWith(
                          (states) => AppColors.colorLightGreen),
                  fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.blue),
                  value: Gender.Male.toString(),
                  groupValue: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value.toString();
                      _gender = 'Male';
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAddressText() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        child: TextFormField(
          onSaved: (val) => _address = val!,
          onChanged: (value) {
            setState(() {
              _address = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          controller: _addressTextController,
          style: AppStyles().getTitleStyle(
            titleWeight: FontWeight.bold,
            titleSize: 14,
            titleColor: Colors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            //Color(0xffB4CEB3),
            labelText: "Address",
            labelStyle: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 14,
              titleColor: Colors.black,
            ),
            hintText: 'Enter address',
            hintStyle: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 14,
              titleColor: Colors.grey.shade700,
            ),
            prefixIcon: Icon(
              Icons.pin_drop,
              color: Colors.green,
              size: 15,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xffB4CEB3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildCityText() {
    return Material(
      elevation: 5,
      color: Color(0xffB4CEB3),
      borderOnForeground: true,
      child: TextFormField(
        onSaved: (val) => _city = val!,
        onChanged: (value) {
          setState(() {
            _city = value;
          });
        },
        keyboardType: TextInputType.emailAddress,
        controller: _cityTextController,
        style: AppStyles().getTitleStyle(
          titleWeight: FontWeight.bold,
          titleSize: 14,
          titleColor: Colors.black,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          //Color(0xffB4CEB3),
          labelText: "City",
          labelStyle: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 14,
              titleColor: Colors.black),
          hintText: 'Enter City Name',
          hintStyle: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 14,
              titleColor: Colors.grey.shade700),
          prefixIcon: Icon(
            Icons.location_city,
            color: Colors.green,
            size: 15,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffB4CEB3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  _buildZipCodeText() {
    return Material(
      elevation: 5,
      color: Color(0xffB4CEB3),
      borderOnForeground: true,
      child: TextFormField(
        onSaved: (val) => _zipcode = val!,
        onChanged: (value) {
          setState(() {
            _zipcode = value;
          });
        },
        keyboardType: TextInputType.emailAddress,
        controller: _zipcodeTextController,
        style: AppStyles().getTitleStyle(
          titleWeight: FontWeight.bold,
          titleSize: 14,
          titleColor: Colors.black,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          //Color(0xffB4CEB3),
          labelText: "ZipCode",
          labelStyle: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 14,
              titleColor: Colors.black),
          hintText: 'Enter ZipCode',
          hintStyle: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 14,
              titleColor: Colors.grey.shade700),
          prefixIcon: Icon(
            Icons.pin,
            color: Colors.green,
            size: 15,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffB4CEB3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  _buildStateText() {
    return Material(
      elevation: 5,
      color: Color(0xffB4CEB3),
      borderOnForeground: true,
      child: TextFormField(
        onSaved: (val) => _state = val!,
        onChanged: (value) {
          setState(() {
            _state = value;
          });
        },
        keyboardType: TextInputType.emailAddress,
        controller: _stateTextController,
        style: AppStyles().getTitleStyle(
          titleWeight: FontWeight.bold,
          titleSize: 14,
          titleColor: Colors.black,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          //Color(0xffB4CEB3),
          labelText: "State",
          labelStyle: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 14,
              titleColor: Colors.black),
          hintText: 'Enter State Name',
          hintStyle: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 14,
              titleColor: Colors.grey.shade700),
          prefixIcon: Icon(
            Icons.map,
            color: Colors.green,
            size: 15,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffB4CEB3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  _buildCountryText() {
    return Material(
      elevation: 5,
      color: Color(0xffB4CEB3),
      borderOnForeground: true,
      child: TextFormField(
        onChanged: (value) {
          setState(() {
            _country = value;
          });
        },
        keyboardType: TextInputType.emailAddress,
        controller: _countryTextController,
        style: AppStyles().getTitleStyle(
          titleWeight: FontWeight.bold,
          titleSize: 14,
          titleColor: Colors.black,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
          //Color(0xffB4CEB3),
          labelText: "Country",
          labelStyle: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 14,
              titleColor: Colors.black),
          hintText: 'Enter Country Name',
          hintStyle: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 14,
              titleColor: Colors.grey.shade700),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xffB4CEB3),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  _cardField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.grey.shade200,
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 2),
          child: Text(
            value.toString().toUpperCase(),
            style: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 12,
              titleColor: Colors.black,
            ),
          ),
        ),
        Container(
          color: Colors.grey.shade200,
          padding: EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
          child: Text(
            label,
            style: AppStyles().getTitleStyle(
              titleWeight: FontWeight.bold,
              titleSize: 10,
              titleColor: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  _createTeacher(context) async {
    var statusMessage = '';
    bool _checkFlag = true;

    if (_emailId == null || _emailId!.isEmpty) {
      _checkFlag = false;
      statusMessage = 'EMAIL_EMPTY';
    }

    if (_password == null || _password!.isEmpty) {
      _checkFlag = false;
      statusMessage = 'PASSWORD_EMPTY';
    }

    print(statusMessage);

    if (!_checkFlag) {
      AppWidgets().showAlertErrorWithButton(
          context: context,
          errMessage: 'Please provide valid Email Id & Password');
    } else {
      await _createAdminUser();

      print('SAVE DATA');
    }
  }

  Future<void> _createAdminUser() async {
    // Show loading message about admin data being created
    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Creating Admin Details');
    });

    try {
      // Create User data to save
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailId!,
        password: _password!,
      )
          .then((value) async {
        if (value.user!.email != null) {
          setState(() {
            _isLoading = false;
            EasyLoading.dismiss();
          });

          // Save Teacher data in Admin Table

          setState(() {
            _isLoading = true;
            EasyLoading.show(status: 'Creating Teachers Details');
          });

          String type = 't';
          _services
              .createAdminUser(_emailId, _password, type, _zone)
              .whenComplete(() async {
            if (teacherImageName != null) {
              userImageUrl = await _services.uploadImageToStorage(
                imageName: teacherImageName,
                imagePath: 'teachers_Image/',
                zone: _zone,
              );
            }

            await _services.teacher.doc(_emailId).set({
              'name': _name,
              'emailId': _emailId,
              'phoneNumber': _phoneNumber,
              'address': _address,
              'city': _city,
              'state': _state,
              'zipcode': _zipcode,
              'country': _country,
              'gender': _gender,
              'dateOfBirth': '',
              'userImageUrl': userImageUrl,
              'zone': _zone,
              'createdOn': DateTime.now(),
              'createdBy': '',
              'updatedOn': DateTime.now(),
              'updatedBy': '',
              'active': true,
            }).whenComplete(() {
              resetFields();

              setState(() {
                _isLoading = false;
                EasyLoading.dismiss();
              });

              // Show Success Message to user
              return AppWidgets().showAlertSuccessWithButton(
                  context: context,
                  successMessage: 'Teacher Details have been saved.');
            }).onError((error, stackTrace) {
              setState(() {
                _isLoading = false;
                EasyLoading.showError('Error Occurred. Try Again.');
              });
            });
          }).onError((error, stackTrace) {
            if (!mounted) return;
            setState(() {
              _isLoading = false;
              EasyLoading.showError('Error Occurred. Try Again.');
            });
          });
        }
      }).catchError((error) {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          EasyLoading.showError('Error Occurred. Try Again.');
        });
        print(error);
      });
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        EasyLoading.dismiss();
      });

      if (e.code == 'weak-password') {
        print('The password provided is too weak.');

        AppWidgets().showAlertErrorWithButton(
          context: context,
          errMessage: 'Please provide strong Password!',
        );
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');

        AppWidgets().showAlertErrorWithButton(
          context: context,
          errMessage: 'The account already exists for that email.',
        );
      }
    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() {
        _isLoading = false;
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
      _nameTextController.clear();
      _phoneNumberTextController.clear();
      _emailIdTextController.clear();
      _passwordTextController.clear();
      _addressTextController.clear();
      _cityTextController.clear();
      _stateTextController.clear();
      _zipcodeTextController.clear();
      _countryTextController.clear();

      _name = '';
      _phoneNumber = '';
      _emailId = '';
      _password = '';
      _gender = '';
      _address = '';
      _city = '';
      _state = '';
      _country = '';
      _zipcode = '';
      _zone = '';
      _selectedGender = '';
      userImageUrl = '';
      teacherImageName = null;
    });
  }
}