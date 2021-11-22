import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:artklub_admin/utilities/AppWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CreateBatchesCardWidget extends StatefulWidget {

  CreateBatchesCardWidget({Key? key}) : super(key: key);

  @override
  _CreateBatchesCardWidgetState createState() => _CreateBatchesCardWidgetState();

}

class _CreateBatchesCardWidgetState extends State<CreateBatchesCardWidget> {

  final ScrollController _firstController = ScrollController();
  FirebaseServices _services = FirebaseServices();

  bool _isLoading = false;
  bool _summaryFlag = false;

  String? _batchId,_zone, _course;
  String? _zoneDropDownValue, _courseDropDownValue;
  List<String> zonesList = ['Select Zone'];
  List<String> coursesList = ['Select Course'];

  String selectedStartDate = 'Start Date';
  String selectedEndDate = 'End Date';
  String selectedStartTime = 'Start Time';
  String selectedEndTime = 'End Time';

  TextEditingController _batchIdTextController = TextEditingController();

  @override
  void initState() {
    _batchId = '';
    _zone = '';
    _course = '';

    getAllZones();
    getAllCourses();

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

  Future<void> getAllCourses() async{

    coursesList = ['Select Course','Adept','Dexter','Imaginator','Innovator','Rookie'];

    setState(() {
      if (coursesList.length < 1) {
        _courseDropDownValue = coursesList[0];
        _course = _courseDropDownValue;
      } else {
        _courseDropDownValue = coursesList[0];
        _course = _courseDropDownValue;
      }

      _isLoading = false;
      EasyLoading.dismiss();
    });

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
                        _buildDetailCardSection(),
                        _buildSummaryCardSection(),

                      ],
                    )
                  ],
                ),
              ),
            );
          },
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
          height: MediaQuery.of(context).size.height * 0.45,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          alignment: Alignment.centerLeft,
          child: ListView(
            children: [
              Column(
                children: [

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'Batch Details',
                              style: AppStyles.tableHeaderStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: Container(
                      height: 2,
                      width: 25,
                      color: Colors.green,
                    ),
                  ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildZoneText(),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildCoursesText(),
                        ),
                      ],
                    ),
                  ),
                  // Container(
                  //   child: Column(
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //         children: [
                  //           Expanded(
                  //             flex: 1,
                  //             child: _buildTeachersText(),
                  //           ),
                  //           Expanded(
                  //             flex: 1,
                  //             child: _buildTeachersBackupText(),
                  //           ),
                  //         ],
                  //       ),
                  //
                  //     ],
                  //   ),
                  // ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildStartDateText(),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildEndDateText(),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildStartTimeText(),
                        ),
                        Expanded(
                          flex: 1,
                          child: _buildEndTimeText(),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),

                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                            child: Material(
                              elevation: 5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.black
                                ),
                                onPressed: () async {


                                  if(_zone != 'Select Zone' && _course != 'Select Course'
                                      && selectedStartDate != 'Start Date' && selectedStartTime != 'Start Time'
                                      && selectedEndTime != 'End Time')
                                  {

                                    _batchId = '${_zone.toString().toUpperCase().substring(0,3)}-'
                                        '${_course.toString().toUpperCase().substring(0,3)}-'
                                        '${selectedStartDate.replaceAll('/', '')}-'
                                        '${selectedStartTime.replaceAll(':', '')}-'
                                        '${selectedEndTime.replaceAll(':', '')}';
                                    _batchIdTextController.text = _batchId.toString();

                                    if(await doesBatchAlreadyExist(_batchId)){
                                      setState(() {
                                        _summaryFlag = false;
                                      });
                                      AppWidgets().showScaffoldMessage(
                                          context: context,
                                          msg:
                                          'Batch already Exists for the courses with same timings.');
                                    }else{
                                      setState(() {
                                        _summaryFlag = true;
                                      });

                                    }

                                  }else{
                                    AppWidgets().showScaffoldMessage(context: context, msg: 'Please fill all the Fields to Preview');
                                  }

                                },
                                child: Text(
                                  'Preview',
                                  style: AppStyles.buttonStyleWhite,
                                ),
                              ),
                            ),
                          ),
                        )
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
          height: MediaQuery.of(context).size.height * 0.45,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          alignment: Alignment.centerLeft,
          child: !_summaryFlag ?
          Center(
            child: Text(
              'Batch Preview will appear here.',
              style: AppStyles.tableHeaderStyle,
            ),
          ) :
          ListView(
            children: [
              Column(
                children: [

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              'New Batch',
                              style: AppStyles.tableHeaderStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Center(
                    child: Container(
                      height: 2,
                      width: 25,
                      color: Colors.green,
                    ),
                  ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: _buildBatchId()
                        ),

                      ],
                    ),
                  ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        _buildSummaryField(title: 'Zone', value: _zone.toString().toUpperCase()),
                        _buildSummaryField(title: 'Course', value: _course.toString().toUpperCase())

                      ],
                    ),
                  ),

                  // Container(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //
                  //       _buildSummaryField(title: 'Teacher', value: _teacher.toString().toUpperCase()),
                  //       _buildSummaryField(title: 'Backup Teacher', value: _teacherBackup.toString().toUpperCase())
                  //
                  //     ],
                  //   ),
                  // ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        _buildSummaryField(title: 'Start Date', value: selectedStartDate.toString().toUpperCase()),
                        _buildSummaryField(title: 'End Date', value: selectedEndDate.toString().toUpperCase())

                      ],
                    ),
                  ),

                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [

                        _buildSummaryField(title: 'Start Time', value: selectedStartTime.toString().toUpperCase()),
                        _buildSummaryField(title: 'End Time', value: selectedEndTime.toString().toUpperCase())

                      ],
                    ),
                  ),

                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),

                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                            child: Material(
                              elevation: 5,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black
                                ),
                                onPressed: (){
                                  setState(() {
                                    _createBatch();
                                  });
                                },
                                icon: Icon(Icons.save),
                                label: Text(
                                  'Create',
                                  style: AppStyles.buttonStyleWhite,
                                ),
                              ),
                            ),
                          ),
                        )
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

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 7, minute: 15),
    );
    if (pickedTime != null)
      setState(() {
        selectedStartTime =  '${pickedTime.hour}:${pickedTime.minute}';
      });
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 7, minute: 15),
    );
    if (pickedTime != null)
      setState(() {
        selectedEndTime =  '${pickedTime.hour}:${pickedTime.minute}';
      });
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
  _buildCoursesText() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Material(
        elevation: 5,
        color: Colors.grey.shade200,
        borderOnForeground: true,
        child: DropdownButton(
          value: _courseDropDownValue,
          isExpanded: true,
          underline: Container(
            color: Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(10),
          icon: Container(
              padding: EdgeInsets.only(left: 10),
              child: Icon(Icons.keyboard_arrow_down)),
          items: coursesList.map((String items) {
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
          onChanged: (_zone == 'Select Zone')? null:(newValue) {
            setState(() {
              _courseDropDownValue = newValue.toString();
              _course = _courseDropDownValue;
            });
          },
        ),
      ),
    );
  }
  _buildStartDateText() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
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
                onPressed: (_course == 'Select Course') ? null :() {

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
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
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
                onPressed: (selectedStartDate == 'Start Date')? null : (){
                  _selectEndDate(context);
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
  _buildStartTimeText() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
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
                selectedStartTime.toString(),
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
                icon: Icon(Icons.alarm_add),
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent,
                ),
                onPressed: (selectedEndDate == 'End Date')? null :(){

                  setState(() {
                    _selectStartTime(context);
                  });
                }, // Refer step 3
                label: Text(
                  'Select Start Time',
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
  _buildEndTimeText() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
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
                selectedEndTime.toString(),
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
                icon: Icon(Icons.alarm_add),
                style: ElevatedButton.styleFrom(
                  primary: Colors.greenAccent,
                ),
                onPressed: (selectedStartTime == 'Start Time')? null :() {

                  setState(() {
                    _selectEndTime(context);
                  });
                }, // Refer step 3
                label: Text(
                  'Select End Time',
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

  _buildBatchId() {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: Material(
        elevation: 5,
        color: Color(0xffB4CEB3),
        child: TextFormField(
          controller: _batchIdTextController,
          textCapitalization: TextCapitalization.characters,
          textAlign: TextAlign.center,
          style: AppStyles().getTitleStyle(
            titleWeight: FontWeight.bold,
            titleSize: 14,
            titleColor: Colors.black,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            labelText: "Batch Id",
            labelStyle: AppStyles().getTitleStyle(
                titleWeight: FontWeight.bold,
                titleSize: 14,
                titleColor: Colors.black),
            prefixIcon: Icon(
              Icons.alarm,
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

  _buildSummaryField({title, value}){
    return Expanded(
        flex: 1,
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Material(
            elevation: 5,
            child: Column(
              children: [
                Text(
                  value,
                  style: AppStyles.tableHeaderStyle,
                ),
                Text(
                  title,
                  style: AppStyles.tableBodyStyle,
                )
              ],
            ),
          ),
        )
    );
  }

  Future<void> _createBatch() async {

      setState(() {
        _isLoading = true;
        EasyLoading.show(status: 'Saving...');
      });

      await _services.batches.doc(_batchId).set({
        'name': _batchId,
        'zone': _zone,
        'course': _course,
        'startDate': selectedStartDate,
        'endDate': selectedEndDate,
        'startTime': selectedStartTime,
        'endTime': selectedEndTime,
        'createdOn': DateTime.now(),
        'createdBy': '',
        'updatedOn': DateTime.now(),
        'updatedBy': '',
        'active': true,
      }).whenComplete(() {

        resetFields();

        setState(() {
          _summaryFlag = false;
          _isLoading = false;
          EasyLoading.dismiss();
        });

        // Show Success Message to user
        return AppWidgets().showAlertSuccessWithButton(
            context: context,
            successMessage: 'Batch Details have been saved.');
      }).onError((error, stackTrace) {
        setState(() {
          _summaryFlag = false;
          _isLoading = false;
          EasyLoading.dismiss();
          EasyLoading.showError('Error Occurred. Try Again.');
        });
      });

  }

  Future<bool> doesBatchAlreadyExist(String? name) async {

    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Checking...');
    });

    final QuerySnapshot result = await _services.batches
        .where('name', isEqualTo: _batchId)
        .limit(1)
        .get().whenComplete(() {
      setState(() {
        _isLoading = false;
        EasyLoading.dismiss();
      });
    });
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  void resetFields(){
    setState(() {
      _zone = '';
      _course = '';
      _batchId = '';

      _batchIdTextController.text ='';
      _zoneDropDownValue = zonesList[0];
      _courseDropDownValue = coursesList[0];

      getAllZones();
      getAllCourses();

      selectedStartDate = 'Start Date';
      selectedEndDate = 'End Date';
      selectedStartTime = 'Start Time';
      selectedEndTime = 'End Time';
    });

  }


}
