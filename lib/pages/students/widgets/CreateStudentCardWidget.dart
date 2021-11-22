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

class CreateStudentCardWidget extends StatefulWidget {
  const CreateStudentCardWidget({Key? key}) : super(key: key);

  @override
  _CreateStudentCardWidgetState createState() => _CreateStudentCardWidgetState();
}

class _CreateStudentCardWidgetState extends State<CreateStudentCardWidget> {
  final ScrollController _firstController = ScrollController();
  FirebaseServices _services = FirebaseServices();

  bool _isLoading = false;

  String? _zoneDropDownValue;

  List<String> zonesList = ['Select Zone'];
  var _selectedGender;
  DroppedFile? studentImageName;

  TextEditingController _studentNameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  TextEditingController _parent1NameTextController = TextEditingController();
  TextEditingController _parent1EmailIdTextController = TextEditingController();
  TextEditingController _parent1PhoneNumberTextController = TextEditingController();

  TextEditingController _parent2NameTextController = TextEditingController();
  TextEditingController _parent2EmailIdTextController = TextEditingController();
  TextEditingController _parent2PhoneNumberTextController = TextEditingController();

  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _cityTextController = TextEditingController();
  TextEditingController _zipcodeTextController = TextEditingController();
  TextEditingController _stateTextController = TextEditingController();
  TextEditingController _countryTextController = TextEditingController();

  bool _obscureText = true;

  String? _userImageUrl,
      _studentName,
      _gender,
      _zone,
      _password,

      _parent1Name,
      _parent1EmailId,
      _parent1PhoneNumber,

      _parent2Name,
      _parent2EmailId,
      _parent2PhoneNumber,

      _address,
      _city,
      _zipcode,
      _state,
      _country;

  @override
  void initState() {
    _userImageUrl = '';
    _studentName = '';
    _gender = '';
    _selectedGender = '';
    _zone = '';
    _password = '';

    _parent1Name = '';
    _parent1EmailId = '';
    _parent1PhoneNumber = '';

    _parent2Name = '';
    _parent2EmailId = '';
    _parent2PhoneNumber = '';

    _address = '';
    _city = '';
    _zipcode = '';
    _state = '';
    _country = '';

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
          ? Center(child: CircularProgressIndicator(),)
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
              this.studentImageName = fileName;
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
                  _buildStudentDetails(),
                  _buildParent1Details(),
                  _buildParent2Details(),
                  _buildAddressDetails(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildStudentDetails(){
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Material(
        elevation: 5,
        child: Column(
          children: [
            Text('Student Details', style: AppStyles.tableHeaderStyle,),
            _buildStudentNameText(),
            _buildStudentGenderText(),
            _buildZoneText(),
            _buildPasswordText(),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }

  // Student Details
  _buildStudentNameText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        borderOnForeground: true,
        child: TextFormField(
          onSaved: (val) => _studentName = val!,
          onChanged: (value) {
            setState(() {
              _studentName = value;
            });
          },
          controller: _studentNameTextController,
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
  _buildStudentGenderText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
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
  _buildZoneText() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10),
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
  _buildPasswordText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
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

  // Parent 1 Details
  _buildParent1Details(){
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Material(
        elevation: 5,
        child: Column(
          children: [
            Text('Parent 1 Details', style: AppStyles.tableHeaderStyle,),
            _buildParent1NameText(),
            _buildParent1EmailIdText(),
            _buildParent1PhoneNumberText(),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }

  _buildParent1NameText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        borderOnForeground: true,
        child: TextFormField(
          onSaved: (val) => _parent1Name = val!,
          onChanged: (value) {
            setState(() {
              _parent1Name = value;
            });
          },
          controller: _parent1NameTextController,
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
  _buildParent1EmailIdText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        child: TextFormField(
          onSaved: (val) => _parent1EmailId = val!,
          onChanged: (value) {
            setState(() {
              _parent1EmailId = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          controller: _parent1EmailIdTextController,
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
  _buildParent1PhoneNumberText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        child: TextFormField(
          onSaved: (val) => _parent1PhoneNumber = val!,
          onChanged: (value) {
            setState(() {
              _parent1PhoneNumber = value;
            });
          },
          controller: _parent1PhoneNumberTextController,
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

  // Parent 2 Details
  _buildParent2Details(){
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Material(
        elevation: 5,
        child: Column(
          children: [
            Text('Parent 2 Details', style: AppStyles.tableHeaderStyle,),
            _buildParent2NameText(),
            _buildParent2EmailIdText(),
            _buildParent2PhoneNumberText(),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }

  _buildParent2NameText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        borderOnForeground: true,
        child: TextFormField(
          onSaved: (val) => _parent2Name = val!,
          onChanged: (value) {
            setState(() {
              _parent2Name = value;
            });
          },
          controller: _parent2NameTextController,
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
  _buildParent2EmailIdText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        child: TextFormField(
          onSaved: (val) => _parent2EmailId = val!,
          onChanged: (value) {
            setState(() {
              _parent2EmailId = value;
            });
          },
          keyboardType: TextInputType.emailAddress,
          controller: _parent2EmailIdTextController,
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
  _buildParent2PhoneNumberText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        child: TextFormField(
          onSaved: (val) => _parent2PhoneNumber = val!,
          onChanged: (value) {
            setState(() {
              _parent2PhoneNumber = value;
            });
          },
          controller: _parent2PhoneNumberTextController,
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

  // Address details
  _buildAddressDetails(){
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5,left: 5, right: 5),
      child: Material(
        elevation: 5,
        child: Column(
          children: [
            Text('Address Details', style: AppStyles.tableHeaderStyle,),
            _buildAddressText(),
            Container(
              padding: EdgeInsets.only(top: 5, left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildCityText(),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 1,
                    child: _buildZipCodeText(),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5,left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildStateText(),
                  ),
                  SizedBox(width: 5),
                  Expanded(
                    flex: 1,
                    child: _buildCountryText(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }

  _buildAddressText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
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

  // Summary Details
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
                            'Student Details',
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
                                fileName: studentImageName),
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
                                      label: 'Name', value: _studentName.toString()),
                                  _cardField(
                                      label: 'Gender',
                                      value: _gender.toString()),
                                  _cardField(label: 'Zone', value: _zone.toString()),
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
                          left: 5, right: 5, top: 5,),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10,),
                            child: Text(
                              'Parent 1 Details',
                              style: AppStyles.tableBodyStyle,
                            ),
                          ),
                          _cardField(
                              label: 'Name', value: _parent1Name.toString()),
                          _cardField(
                              label: 'Email Id', value: _parent1EmailId.toString()),
                          _cardField(
                              label: 'Phone Number',
                              value: _parent1PhoneNumber.toString()),

                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5, right: 5, top: 5,),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10,),
                            child: Text(
                              'Parent 2 Details',
                              style: AppStyles.tableBodyStyle,
                            ),
                          ),
                          _cardField(
                              label: 'Name', value: _parent2Name.toString()),
                          _cardField(
                              label: 'Email Id', value: _parent2EmailId.toString()),
                          _cardField(
                              label: 'Phone Number',
                              value: _parent2PhoneNumber.toString()),

                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5, right: 5, top: 5,),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10,),
                            child: Text(
                              'Address Details',
                              style: AppStyles.tableBodyStyle,
                            ),
                          ),
                          _cardField(
                              label: 'Address', value: _address.toString()),
                          _cardField(
                              label: 'City', value: _city.toString()),
                          _cardField(
                              label: 'Zipcode',
                              value: _zipcode.toString()),
                          _cardField(
                              label: 'State',
                              value: _state.toString()),
                          _cardField(
                              label: 'Country',
                              value: _country.toString()),
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
                        _createStudent(context);
                      },
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Create',
                        style: AppStyles.buttonStyleWhite,
                      ),
                    ),
                ),
              ],
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

  _createStudent(context) async {
    var statusMessage = '';
    bool _checkFlag = true;

    if (_parent1EmailId == null || _parent1EmailId!.isEmpty) {
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
      EasyLoading.show(status: 'Creating Student Details');
    });

    try {
      // Create User data to save
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _parent1EmailId!,
        password: _password!,
      ).then((value) async {
        if (value.user!.email != null) {
          setState(() {
            _isLoading = false;
            EasyLoading.dismiss();
          });

          // Save Student data in Admin Table

          if (studentImageName != null) {
            _userImageUrl = await _services.uploadImageToStorage(
              imageName: studentImageName,
              imagePath: 'students_Image/',
              zone: _zone,
            );
          }

          await _services.student.doc(_parent1EmailId).set({
            'active': true,
            'parent1EmailId': _parent1EmailId,
            'parent1Name': _parent1Name,
            'parent1PhoneNumber': _parent1PhoneNumber,
            'parent2EmailId': _parent2EmailId,
            'parent2Name': _parent2Name,
            'parent2PhoneNumber': _parent2PhoneNumber,
            'studentDOB': '',
            'studentGender': _gender,
            'studentId': '',
            'studentName': _studentName,
            'studentPhotoURL': _userImageUrl,
            'timestamp':DateTime.now(),
            'zone': _zone,

            'address': _address,
            'city': _city,
            'state': _state,
            'zipcode': _zipcode,
            'country': _country,

            'createdOn': DateTime.now(),
            'createdBy': '',
            'updatedOn': DateTime.now(),
            'updatedBy': '',

          }).whenComplete(() {
            resetFields();

            setState(() {
              _isLoading = false;
              EasyLoading.dismiss();
            });

            // Show Success Message to user
            return AppWidgets().showAlertSuccessWithButton(
                context: context,
                successMessage: 'Student Details have been saved.');
          }).onError((error, stackTrace) {
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
      _studentNameTextController.clear();
      _passwordTextController.clear();

      _parent1NameTextController.clear();
      _parent1EmailIdTextController.clear();
      _parent1PhoneNumberTextController.clear();

      _parent2NameTextController.clear();
      _parent2EmailIdTextController.clear();
      _parent2PhoneNumberTextController.clear();

      _addressTextController.clear();
      _cityTextController.clear();
      _zipcodeTextController.clear();
      _stateTextController.clear();
      _countryTextController.clear();

      _userImageUrl = '';
      _studentName = '';
      _gender = '';
      _selectedGender = '';
      _zone = '';
      _password = '';

      _parent1Name = '';
      _parent1EmailId = '';
      _parent1PhoneNumber = '';

      _parent2Name = '';
      _parent2EmailId = '';
      _parent2PhoneNumber = '';

      _address = '';
      _city = '';
      _zipcode = '';
      _state = '';
      _country = '';
      studentImageName = null;
    });
  }
}
