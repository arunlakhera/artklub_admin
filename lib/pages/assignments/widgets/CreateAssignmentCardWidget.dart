import 'package:artklub_admin/model/DroppedFile.dart';
import 'package:artklub_admin/pages/coordinators/widgets/CreateCoordinatorCardWidget.dart';
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

class CreateAssignmentCardWidget extends StatefulWidget {
  const CreateAssignmentCardWidget({Key? key}) : super(key: key);

  @override
  _CreateAssignmentCardWidgetState createState() => _CreateAssignmentCardWidgetState();
}

class _CreateAssignmentCardWidgetState extends State<CreateAssignmentCardWidget> {

  final ScrollController _firstController = ScrollController();
  FirebaseServices _services = FirebaseServices();

  bool _isLoading = false;
  bool _previewFlag = false;

  String? _zoneDropDownValue;
  String? _batchDropDownValue;
  DroppedFile? assignmentImageName;

  List<String> zonesList = ['Select Zone'];
  List<String> batchesList = ['Select Batch'];

  String selectedStartDate = 'Start Date';
  String selectedEndDate = 'End Date';

  TextEditingController _assignmentDetailTextController = TextEditingController();

  String? _assignmentImageUrl, _assignmentDetail, _zone, _batch;

  @override
  void initState() {
    _assignmentImageUrl = '';
    _assignmentDetail = '';
    _zone = '';
    _batch = '';

    getAllZones();
    getBatches();

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

  Future<void> getBatches() async {
    try {
      setState(() {
        _isLoading = true;
        EasyLoading.show(status: 'Loading...');
      });

      Stream<QuerySnapshot> querySnapshot =
      _services.batches.where('active', isEqualTo: true).snapshots();

      await querySnapshot.forEach((batchesSnapshot) {
        batchesSnapshot.docs.forEach((snap) {
          print(snap.data());
          print(snap.get('name'));
          var snapBatch = snap.get('name');

          batchesList.add(snapBatch);
        });

        setState(() {
          if (batchesList.length < 1) {
            _batchDropDownValue = batchesList[0];
            _batch = _batchDropDownValue;
          } else {
            _batchDropDownValue = batchesList[0];
            _batch = _batchDropDownValue;
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
              this.assignmentImageName = fileName;
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
        color: Colors.grey.shade200,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          alignment: Alignment.center,
          child: Stack(
            children: [
              ListView(
                children: [
                  Column(
                    children: [
                      Text('Assignment', style: AppStyles.tableHeaderStyle,),
                      _buildAssignmentDetailsText(),
                      _buildZoneText(),
                      _buildBatchText(),
                      _buildStartDateText(),
                      _buildEndDateText(),
                    ],
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
                    setState(() {

                      bool checkFields = true;
                      var msg;

                      if(assignmentImageName == null && (_assignmentDetail == null || _assignmentDetail!.isEmpty)){
                        checkFields = false;
                        msg = 'Please provide either Assignment Photo or Assignment Detail';
                      }else if(_zone == 'Select Zone'){
                        checkFields = false;
                        msg = 'Please select Zone';
                      }else if(_batch == 'Select Batch'){
                        checkFields = false;
                        msg = 'Please select Batch';
                      }else if(selectedStartDate == 'Start Date'){
                        checkFields = false;
                        msg = 'Please select Start Date';
                      }else if(selectedStartDate == 'End Date'){
                        checkFields = false;
                        msg = 'Please select End Date';
                      }

                      if(checkFields){
                        _previewFlag = true;
                      }else{
                        AppWidgets().showScaffoldMessage(context: context, msg: msg);
                      }

                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Preview',
                    style: AppStyles.buttonStyleWhite,
                  ),
                ),
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
            child: !_previewFlag ?
            Center(child: Text('Preview Assignment Details here', style: AppStyles.tableHeaderStyle,),)
                : Stack(
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
                            'Assignment',
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
                                fileName: assignmentImageName),
                          ),

                          Container(
                            alignment: Alignment.bottomLeft,
                            width: 270,
                            child: _cardField(label: '', value: _assignmentDetail.toString()),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _cardField(label: 'Assignment ID', value: _zone.toString()),
                    ),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _cardField(label: 'Zone', value: _zone.toString()),
                          _cardField(label: 'Batch', value: _batch.toString()),
                          _cardField(label: 'Start Date', value: selectedStartDate.toString()),
                          _cardField(label: 'End Date', value: selectedEndDate.toString()),
                        ],
                      ),
                    )

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
                      _createAssignment();
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

  // SECTION FIELDS
  _buildAssignmentDetailsText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        borderOnForeground: true,
        child: TextFormField(
          maxLines: 5,
          onSaved: (val) => _assignmentDetail = val!,
          onChanged: (value) {
            setState(() {
              _assignmentDetail = value;
            });
          },
          controller: _assignmentDetailTextController,
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
            labelText: "Details",
            labelStyle: AppStyles().getTitleStyle(
                titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.black),
            hintText: 'Enter Assignment Details',
            hintStyle: AppStyles().getTitleStyle(
                titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.grey.shade700),
            prefixIcon: Icon(
              Icons.article,
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
  _buildBatchText() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.only(top: 5, left: 10, right: 10),
        child: Material(
          elevation: 5,
          color: Colors.grey.shade200,
          borderOnForeground: true,
          child: DropdownButton(
            value: _batchDropDownValue,
            isExpanded: true,
            underline: Container(
              color: Colors.grey.shade200,
            ),
            borderRadius: BorderRadius.circular(10),
            icon: Container(
                padding: EdgeInsets.only(left: 10),
                child: Icon(Icons.keyboard_arrow_down)),
            items: batchesList.map((String items) {
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
            onChanged: (_zone == 'Select Zone') ? null :(newValue) {
              setState(() {
                _batchDropDownValue = newValue.toString();
                _batch = _batchDropDownValue;
              });
            },
          ),
        ),
      ),
    );
  }
  _buildStartDateText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Material(
        elevation: 5,
        color: Colors.grey.shade200,
        borderOnForeground: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                selectedStartDate.toString(),
                style: AppStyles().getTitleStyle(
                  titleWeight: FontWeight.bold,
                  titleSize: 16,
                  titleColor: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton.icon(
                icon: Icon(Icons.calendar_today_rounded),
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent,
                ),
                onPressed: (_batch == 'Select Batch') ? null :() {

                  setState(() {
                    _selectStartDate(context);
                  });

                }, // Refer step 3
                label: Text(
                  'Select Start Date',
                  style: AppStyles().getTitleStyle(
                    titleWeight: FontWeight.bold,
                    titleSize: 14,
                    titleColor: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
  _buildEndDateText() {
    return Padding(
      padding: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: Material(
        elevation: 5,
        color: Colors.grey.shade200,
        borderOnForeground: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                selectedEndDate.toString(),
                style: AppStyles().getTitleStyle(
                  titleWeight: FontWeight.bold,
                  titleSize: 16,
                  titleColor: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton.icon(
                icon: Icon(Icons.calendar_today_rounded),
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent,
                ),
                onPressed: (selectedStartDate == 'Start Date') ? null :() {

                  setState(() {
                    _selectEndDate(context);
                  });

                }, // Refer step 3
                label: Text(
                  'Select End Date',
                  style: AppStyles().getTitleStyle(
                    titleWeight: FontWeight.bold,
                    titleSize: 14,
                    titleColor: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

          ],
        ),
      ),
    );
  }

  _selectStartDate(BuildContext context) async {

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate.toString() != selectedStartDate)
      setState(() {
        selectedStartDate =  '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });

  }
  _selectEndDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(DateTime.now().year),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate.toString() != selectedEndDate)
      setState(() {
        selectedEndDate = '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
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

  Future<void> _createAssignment() async {
    // Show loading message about admin data being created
    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Creating Assignment');
    });

    try {

      if (assignmentImageName != null) {
        _assignmentImageUrl = await _services.uploadImageToStorage(
          imageName: assignmentImageName,
          imagePath: 'assignments_Image/',
          zone: DateTime.now(),
        );
      }

      await _services.assignments.doc().set({
        'active': true,
        'detail': _assignmentDetail,
        'zone': _zone,
        'batchName': _batch,
        'startDate': selectedStartDate,
        'endDate': selectedEndDate,
        'assignmentImageUrl': _assignmentImageUrl,
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
            successMessage: 'Assignment Details have been saved.');
      }).onError((error, stackTrace) {
        setState(() {
          _isLoading = false;
          EasyLoading.showError('Error Occurred. Try Again.');
        });
      });

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
      _assignmentDetailTextController.clear();
      _assignmentImageUrl = '';
      _assignmentDetail = '';
      _zone = '';

      _zoneDropDownValue = zonesList[0];
      _batchDropDownValue = batchesList[0];
      selectedStartDate = 'Start Date';
      selectedEndDate = 'End Date';

      assignmentImageName = null;

      getAllZones();
      getBatches();

    });
  }
}