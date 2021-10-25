import 'package:artklub_admin/common/HeaderWidget.dart';
import 'package:artklub_admin/model/DroppedFile.dart';
import 'package:artklub_admin/pages/coordinators/widgets/CreateCoordinatorCardWidget.dart';
import 'package:artklub_admin/pages/students/StudentsPage.dart';
import 'package:artklub_admin/services/SideBarMenu.dart';
import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:artklub_admin/utilities/AppWidgets.dart';
import 'package:artklub_admin/utilities/DroppedFileWidget.dart';
import 'package:artklub_admin/utilities/DropzoneWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditStudentCardWidget extends StatefulWidget {
  const EditStudentCardWidget({Key? key, required this.emailId})
      : super(key: key);

  final String emailId;

  @override
  _EditStudentCardWidgetState createState() => _EditStudentCardWidgetState();
}

class _EditStudentCardWidgetState extends State<EditStudentCardWidget> {
  SideBarWidget _sideBar = SideBarWidget();

  final ScrollController _firstController = ScrollController();
  FirebaseServices _services = FirebaseServices();

  bool _isLoading = false;
  bool _editFlag = false;

  String? _zoneDropDownValue;

  List<String> zonesList = ['Select Zone'];
  var _selectedGender;
  DroppedFile? studentImageName;

  TextEditingController _studentNameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();

  TextEditingController _parent1NameTextController = TextEditingController();
  TextEditingController _parent1EmailIdTextController = TextEditingController();
  TextEditingController _parent1PhoneNumberTextController =
      TextEditingController();

  TextEditingController _parent2NameTextController = TextEditingController();
  TextEditingController _parent2EmailIdTextController = TextEditingController();
  TextEditingController _parent2PhoneNumberTextController =
      TextEditingController();

  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _cityTextController = TextEditingController();
  TextEditingController _zipcodeTextController = TextEditingController();
  TextEditingController _stateTextController = TextEditingController();
  TextEditingController _countryTextController = TextEditingController();

  String? _userImageUrl,
      _studentName,
      _studentGender,
      _zone,
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
    _studentGender = '';
    _selectedGender = '';
    _zone = '';

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
    getStudent();

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

  Future<void> getStudent() async {
    try {
      setState(() {
        _isLoading = true;
        EasyLoading.show(status: 'Loading...');
      });

      final result = await _services.getStudent(widget.emailId).whenComplete((){
        setState(() {
          _isLoading = false;
          EasyLoading.dismiss();
        });
      });

      setState(() {
        _userImageUrl = result.get('studentPhotoURL');
        _studentName = result.get('studentName');
        _studentNameTextController.text = _studentName!;

        _zone = result.get('zone');
        _zoneDropDownValue = (_zone!.isNotEmpty ? _zone! : 'Select Zone');

        _parent1Name = result.get('parent1Name');
        _parent1NameTextController.text = _parent1Name!;

        _parent1PhoneNumber = result.get('parent1PhoneNumber');
        _parent1PhoneNumberTextController.text = _parent1PhoneNumber!;

        _parent1EmailId = result.get('parent1EmailId');
        _parent1EmailIdTextController.text = _parent1EmailId!;

        _parent2Name = result.get('parent2Name');
        _parent2NameTextController.text = _parent2Name!;

        _parent2PhoneNumber = result.get('parent2PhoneNumber');
        _parent2PhoneNumberTextController.text = _parent2PhoneNumber!;

        _parent2EmailId = result.get('parent2EmailId');
        _parent2EmailIdTextController.text = _parent2EmailId!;

        _studentGender = result.get('studentGender');

        if (_studentGender == 'Male') {
          _selectedGender = Gender.Male.toString();
        } else if (_studentGender == 'Female') {
          _selectedGender = Gender.Female.toString();
        }

        _address = result.get('address');
        _addressTextController.text = _address!;

        _city = result.get('city');
        _cityTextController.text = _city!;

        _state = result.get('state');
        _stateTextController.text = _state!;
        _country = result.get('country');
        _countryTextController.text = _country!;
        _zipcode = result.get('zipcode');
        _zipcodeTextController.text = _zipcode!;

      });

    } on FirebaseException catch (e) {
      print(e);

      setState(() {
        _isLoading = false;
        EasyLoading.dismiss();
      });

      AppWidgets().showAlertErrorWithButton(
        context: context,
        errMessage: 'Error Occurred while loading. Please try again!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: AppColors.colorBlack,
      appBar: AppBar(
        backgroundColor: AppColors.colorBlack,
        iconTheme: IconThemeData(color: AppColors.colorLightGreen),
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.colorLightGreen,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Text(
            'Artklub Admin',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      sideBar: _sideBar.sideBarMenus(context, StudentsPage.id),
      body: Container(
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: const EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: AppColors.colorBackground,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          children: [
            Divider(thickness: 5),
            HeaderWidget(title: 'Edit Student'),
            Divider(thickness: 5),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                    ),
                    onPressed: () {
                      _services.sendPasswordResetLink(context, _parent1EmailId);
                    },
                    child: Text(
                      'Send Password Reset Link',
                      style: AppStyles.buttonStyleWhite,
                    ),
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          //Navigator.popAndPushNamed(context, StudentsPage.id);
                        },
                        icon: Icon(Icons.cancel, color: Colors.white),
                        label: Text(
                          'Cancel',
                          style: AppStyles.buttonStyleWhite,
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _editFlag = true;
                          });
                        },
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Text(
                          'Edit',
                          style: AppStyles.buttonStyleWhite,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(thickness: 5),
            _buildEditStudentCard()
          ],
        ),
      ),
    );
  }

  _buildEditStudentCard() {
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
          child: !_editFlag?
          Center(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'You can Update the Photo by clicking on Edit button and dropping/selecting new Photo.',
                style: AppStyles.tableHeaderStyle,
              ),
            ),
          )
              :DropzoneWidget(
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

  // Student Details
  _buildStudentDetails() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Material(
        elevation: 5,
        child: Column(
          children: [
            Text(
              'Student Details',
              style: AppStyles.tableHeaderStyle,
            ),
            _buildStudentNameText(),
            SizedBox(height: 5),
            _buildStudentGenderText(),
            SizedBox(height: 5),
            _buildZoneText(),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  _buildStudentNameText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        borderOnForeground: true,
        child: TextFormField(
          enabled: _editFlag,
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
                  onChanged: !_editFlag? null : (value) {
                    setState(() {
                      _selectedGender = value.toString();
                      _studentGender = 'Female';
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
                  onChanged: !_editFlag ? null : (value) {
                    setState(() {
                      _selectedGender = value.toString();
                      _studentGender = 'Male';
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
            onChanged: !_editFlag ? null :(newValue) {
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

  // Parent 1 Details
  _buildParent1Details() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Material(
        elevation: 5,
        child: Column(
          children: [
            Text(
              'Parent 1 Details',
              style: AppStyles.tableHeaderStyle,
            ),
            _buildParent1NameText(),
            SizedBox(height: 5),
            _buildParent1EmailIdText(),
            SizedBox(height: 5),
            _buildParent1PhoneNumberText(),
            SizedBox(height: 5),
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
          enabled: _editFlag,
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
          readOnly: true,
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
            fillColor: Colors.grey.shade400,
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
          enabled: _editFlag,
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
  _buildParent2Details() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
      child: Material(
        elevation: 5,
        child: Column(
          children: [
            Text(
              'Parent 2 Details',
              style: AppStyles.tableHeaderStyle,
            ),
            _buildParent2NameText(),
            SizedBox(height: 5),
            _buildParent2EmailIdText(),
            SizedBox(height: 5),
            _buildParent2PhoneNumberText(),
            SizedBox(height: 5),
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
          enabled: _editFlag,
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
          enabled: _editFlag,
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
            labelText: "Email Id",
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
          enabled: _editFlag,
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
  _buildAddressDetails() {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
      child: Material(
        elevation: 5,
        child: Column(
          children: [
            Text(
              'Address Details',
              style: AppStyles.tableHeaderStyle,
            ),
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
              padding: EdgeInsets.only(top: 5, left: 10, right: 10),
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
            SizedBox(
              height: 5,
            ),
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
          enabled: _editFlag,
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
        enabled: _editFlag,
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
        enabled: _editFlag,
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
        enabled: _editFlag,
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
        enabled: _editFlag,
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
                            child:_userImageUrl!.isNotEmpty ? Image.network(_userImageUrl!, height: 120, width: 120,)
                                : DroppedFileWidget(fileName: studentImageName),
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
                                      label: 'Name',
                                      value: _studentName.toString()),
                                  _cardField(
                                      label: 'Gender',
                                      value: _studentGender.toString()),
                                  _cardField(
                                      label: 'Zone', value: _zone.toString()),
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
                        left: 5,
                        right: 5,
                        top: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Text(
                              'Parent 1 Details',
                              style: AppStyles.tableBodyStyle,
                            ),
                          ),
                          _cardField(
                              label: 'Name', value: _parent1Name.toString()),
                          _cardField(
                              label: 'Email Id',
                              value: _parent1EmailId.toString()),
                          _cardField(
                              label: 'Phone Number',
                              value: _parent1PhoneNumber.toString()),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Text(
                              'Parent 2 Details',
                              style: AppStyles.tableBodyStyle,
                            ),
                          ),
                          _cardField(
                              label: 'Name', value: _parent2Name.toString()),
                          _cardField(
                              label: 'Email Id',
                              value: _parent2EmailId.toString()),
                          _cardField(
                              label: 'Phone Number',
                              value: _parent2PhoneNumber.toString()),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      padding: EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                              left: 10,
                              right: 10,
                            ),
                            child: Text(
                              'Address Details',
                              style: AppStyles.tableBodyStyle,
                            ),
                          ),
                          _cardField(
                              label: 'Address', value: _address.toString()),
                          _cardField(label: 'City', value: _city.toString()),
                          _cardField(
                              label: 'Zipcode', value: _zipcode.toString()),
                          _cardField(label: 'State', value: _state.toString()),
                          _cardField(
                              label: 'Country', value: _country.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: _editFlag,
                  child: Positioned(
                    bottom: 10,
                    right: 10,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () {
                        _updateStudent(_parent1EmailId);
                      },
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Update',
                        style: AppStyles.buttonStyleWhite,
                      ),
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
      _studentGender = '';
      _selectedGender = '';
      _zone = '';

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

  Future<void> _updateStudent(_parent1EmailId) async {
    // Show loading message about admin data being created
    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Updating');
    });

    if (studentImageName != null) {
      _userImageUrl = await _services.uploadImageToStorage(
        imageName: studentImageName,
        imagePath: 'students_Image/',
        zone: _zone,
      );
    }

    await _services.student.doc(_parent1EmailId).update({
      'active': true,
      'parent1EmailId': _parent1EmailId,
      'parent1Name': _parent1Name,
      'parent1PhoneNumber': _parent1PhoneNumber,
      'parent2EmailId': _parent2EmailId,
      'parent2Name': _parent2Name,
      'parent2PhoneNumber': _parent2PhoneNumber,
      'studentDOB': '',
      'studentGender': _studentGender,
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
      setState(() {
        _isLoading = false;
        _editFlag = false;
        EasyLoading.dismiss();
      });

      // Show Success Message to user
      return AppWidgets().showAlertSuccessWithButton(
          context: context, successMessage: 'Student Details have been saved.');
    }).onError((error, stackTrace) {
      setState(() {
        _isLoading = false;
        EasyLoading.showError('Error Occurred. Try Again.');
      });
    });
  }
}