import 'package:artklub_admin/common/HeaderWidget.dart';
import 'package:artklub_admin/model/DroppedFile.dart';
import 'package:artklub_admin/pages/teachers/TeachersPage.dart';
import 'package:artklub_admin/pages/zonemanager/widgets/CreateZoneManagerCardWidget.dart';
import 'package:artklub_admin/services/SideBarMenu.dart';
import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:artklub_admin/utilities/AppWidgets.dart';
import 'package:artklub_admin/utilities/DroppedFileWidget.dart';
import 'package:artklub_admin/utilities/DropzoneWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EditTeacherCardWidget extends StatefulWidget {
  const EditTeacherCardWidget({Key? key, required this.emailId}) : super(key: key);

  final String emailId;
  static const String id = 'editTeacher-page';

  @override
  _EditTeacherCardWidgetState createState() => _EditTeacherCardWidgetState();
}

class _EditTeacherCardWidgetState extends State<EditTeacherCardWidget> {

  SideBarWidget _sideBar = SideBarWidget();
  bool _isLoading = false;
  bool _editFlag = false;

  final ScrollController _firstController = ScrollController();
  FirebaseServices _services = FirebaseServices();

  String? _zoneDropDownValue;

  List<String> zonesList = ['Select Zone'];
  var _selectedGender;
  DroppedFile? teacherImageName;

  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _phoneNumberTextController = TextEditingController();
  TextEditingController _emailIdTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _cityTextController = TextEditingController();
  TextEditingController _stateTextController = TextEditingController();
  TextEditingController _zipcodeTextController = TextEditingController();
  TextEditingController _countryTextController = TextEditingController();

  String? _name,
      _phoneNumber,
      _emailId,
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
    getTeacher();

    super.initState();
  }

  Future<void> getAllZones() async{

    try{

      setState(() {
        _isLoading = true;
        EasyLoading.show(status: 'Loading...');
      });

      Stream<QuerySnapshot> querySnapshot = _services.zones.where('active', isEqualTo: true).snapshots();

      await querySnapshot.forEach((zoneSnapshot) {

        zoneSnapshot.docs.forEach((snap) {

          var snapZone = snap.get('zoneName');
          zonesList.add(snapZone);
        });

        setState(() {

          if(zonesList.length < 1){
            _zoneDropDownValue = zonesList[0];
            _zone = _zoneDropDownValue;
          }else{
            _zoneDropDownValue = zonesList[0];
            _zone = _zoneDropDownValue;
          }

          _isLoading = false;
          EasyLoading.dismiss();
        });
      });

    }on FirebaseException catch (e) {
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

  Future<void> getTeacher() async{

    try{

      setState(() {
        _isLoading = true;
        EasyLoading.show(status: 'Loading...');
      });

      final result = await _services.getTeacher(widget.emailId).whenComplete((){
        setState(() {
          _isLoading = false;
          EasyLoading.dismiss();
        });
      });

      setState(() {

        _name = result.get('name');
        _phoneNumber = result.get('phoneNumber');
        _emailId = result.get('emailId');
        _gender = result.get('gender');
        _address = result.get('address');
        _city = result.get('city');
        _state = result.get('state');
        _country = result.get('country');
        _zipcode = result.get('zipcode');
        _zone = result.get('zone');
        userImageUrl = result.get('userImageUrl');

        _nameTextController.text = _name!;
        _phoneNumberTextController.text = _phoneNumber!;
        _emailIdTextController.text = _emailId!;
        //_passwordTextController.text = result.get('password');
        _addressTextController.text = _address!;
        _cityTextController.text = _city!;
        _stateTextController.text = _state!;
        _countryTextController.text = _country!;
        _zipcodeTextController.text = _zipcode!;
        _zoneDropDownValue = (_zone!.isNotEmpty ? _zone! : 'Select Zone');

        if(_gender == 'Male'){
          _selectedGender = Gender.Male.toString();
        }else if(_gender == 'Female'){
          _selectedGender = Gender.Female.toString();
        }

      });

    }on FirebaseException catch (e) {
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
        sideBar: _sideBar.sideBarMenus(context, TeachersPage.id),
        body: Container(
          alignment: Alignment.topLeft,
          margin: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
          padding: const EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: AppColors.colorBackground,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              Divider(thickness: 5),
              HeaderWidget(title: 'Edit Teacher'),
              Divider(thickness: 5,),
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
                      onPressed: (){
                        _services.sendPasswordResetLink(context, _emailId);
                      },
                      child: Text('Send Password Reset Link', style: AppStyles.buttonStyleWhite,),
                    ),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          onPressed: () {
                            Navigator.popAndPushNamed(context, TeachersPage.id);
                          },
                          icon: Icon(Icons.cancel, color: Colors.white),
                          label: Text('Cancel', style: AppStyles.buttonStyleWhite,),
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
                          label: Text('Edit', style: AppStyles.buttonStyleWhite,),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(thickness: 5,),

              editTeacherCard(),
            ],
          ),
        )
    );
  }

  Widget editTeacherCard(){
    return Expanded(
      child: _isLoading ? Center(child: CircularProgressIndicator(),) :LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
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
            color: Colors.grey.shade200,//Color(0xffB8D8BA),
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
              :DropzoneWidget(onDroppedFile: (fileName) => setState(() {
            this.teacherImageName = fileName;
            userImageUrl = '';
          }),),
        ),
      ),
    );
  }

  _buildDetailCardSection(){
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
            color: Colors.grey.shade200,//Color(0xffB8D8BA),
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
                            margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: userImageUrl!.isNotEmpty ? Image.network(userImageUrl!, height: 120, width: 120,)
                                :DroppedFileWidget(fileName: teacherImageName),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _cardField(label: 'Name',value: _name.toString()),
                                  _cardField(label: 'Phone Number',value: _phoneNumber.toString()),
                                  _cardField(label: 'Gender',value: _gender.toString()),
                                ],
                              ),
                            ),
                          )

                        ],
                      ),
                    ),
                    SizedBox(height: 5),

                    Container(
                      padding: EdgeInsets.only(left: 5,right: 5, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _cardField(label: 'Email Id',value: _emailId.toString()),
                          _cardField(label: 'Address',value: _address.toString()),
                          _cardField(label: 'City',value: _city.toString()),
                          _cardField(label: 'State',value: _state.toString()),
                          _cardField(label: 'ZipCode/PinCode',value: _zipcode.toString()),
                          _cardField(label: 'Country',value: _country.toString()),
                          _cardField(label: 'Zone',value: _zone.toString()),

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
                        onPressed: (){
                          _updateTeacher();
                        },
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Save',
                          style: AppStyles.buttonStyleWhite,
                        ),
                      )
                  ),
                ),
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
          enabled: _editFlag,
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
          enabled: _editFlag,
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
          readOnly: true,
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
              titleColor: Colors.grey.shade200,
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
          underline: Container(color: Colors.grey.shade200,),
          borderRadius: BorderRadius.circular(10),
          icon: Container(padding: EdgeInsets.only(left: 10),child: Icon(Icons.keyboard_arrow_down)),
          items: zonesList.map((String items){
            return DropdownMenuItem(
              value: items,
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  items,
                  style: AppStyles().getTitleStyle(titleWeight: FontWeight.bold,titleSize: 14,titleColor: Colors.black),
                ),
              ),
            );
          }).toList(),
          onChanged: !_editFlag ? null :(newValue){
            setState(() {
              _zoneDropDownValue = newValue.toString();
              _zone = _zoneDropDownValue;
            });
          },
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
                  onChanged: !_editFlag? null : (value) {
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
                  onChanged: !_editFlag ? null : (value) {
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
          enabled: _editFlag,
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
        enabled: _editFlag,
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
        enabled: _editFlag,
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
        enabled: _editFlag,
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

  Future<void> _updateTeacher() async {

    // Show loading message about admin data being created
    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Updating');
    });

    if(teacherImageName != null) {
      userImageUrl = await _services.uploadImageToStorage(
        imageName: teacherImageName,
        imagePath: 'teachers_Image/',
        zone: _zone,
      );
    }

    await _services.teacher.doc(_emailId).update(
        {
          'name': _name,
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
          'updatedOn':DateTime.now(),
          'updatedBy':'',
        }
    ).whenComplete((){
      setState(() {
        _isLoading = false;
        _editFlag = false;
        EasyLoading.dismiss();
      });

      // Show Success Message to user
      return AppWidgets().showAlertSuccessWithButton(
          context: context,
          successMessage: 'Teacher Details have been saved.'
      );
    }).onError((error, stackTrace){
      setState(() {
        _isLoading = false;
        EasyLoading.showError('Error Occurred. Try Again.');
      });
    });
  }

}