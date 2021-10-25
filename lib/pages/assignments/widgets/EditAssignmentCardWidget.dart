import 'package:artklub_admin/common/HeaderWidget.dart';
import 'package:artklub_admin/model/DroppedFile.dart';
import 'package:artklub_admin/model/Student.dart';
import 'package:artklub_admin/pages/assignments/AssignmentsPage.dart';
import 'package:artklub_admin/pages/coordinators/widgets/CreateCoordinatorCardWidget.dart';
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
import 'package:google_fonts/google_fonts.dart';

class EditAssignmentCardWidget extends StatefulWidget {
  const EditAssignmentCardWidget(
      {Key? key, required this.batchName, required this.assignmentId})
      : super(key: key);

  final String batchName, assignmentId;

  @override
  _EditAssignmentCardWidgetState createState() =>
      _EditAssignmentCardWidgetState();
}

class _EditAssignmentCardWidgetState extends State<EditAssignmentCardWidget> {
  SideBarWidget _sideBar = SideBarWidget();

  final ScrollController _studentController = ScrollController();
  final ScrollController _firstController = ScrollController();
  FirebaseServices _services = FirebaseServices();

  TextEditingController _searchStudentController = TextEditingController();

  bool _isLoading = false;
  bool showDataFlag = false;
  int? selectedIndex = -1;

  String? selectedStudentName,
      selectedGender,
      selectedZone,
      selectedParent1Name,
      selectedParent1EmailId,
      selectedParent1PhoneNumber,
      selectedAssignmentResponseUrl,
      selectedParent2Name,
      selectedParent2EmailId,
      selectedParent2PhoneNumber,
      selectedStatus;

  DroppedFile? assignmentImageName;
  String? _studentsDropDownValue, _selectedStudent;
  List<Student> batchStudentsList = [];
  QuerySnapshot? _querySnapshot;

  String? _assignmentImageUrl, _detail, _batchName, _zone, _startDate, _endDate;

  @override
  void initState() {
    _assignmentImageUrl = '';
    _detail = '';
    _batchName = '';
    _zone = '';
    _startDate = '';
    _endDate = '';
    _selectedStudent = '';
    selectedStatus = 'NA';

    getAssignment();
    getBatchStudents();
    super.initState();
  }

  Future<void> getAssignment() async {
    try {
      setState(() {
        _isLoading = true;
        EasyLoading.show(status: 'Loading...');
      });

      Stream<DocumentSnapshot> assignmentSnapshot =
          _services.assignments.doc(widget.assignmentId).snapshots();

      await assignmentSnapshot.forEach((element) {
        setState(() {
          _assignmentImageUrl = element.get('assignmentImageUrl');
          _detail = element.get('detail');
          _batchName = element.get('batchName');
          _zone = element.get('zone');
          _startDate = element.get('startDate');
          _endDate = element.get('endDate');

          _isLoading = false;
          EasyLoading.dismiss();
        });
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

  Future<void> getBatchStudents() async {
    List<String> batchList = [];

    setState(() {
      batchStudentsList.clear();
      batchList.clear();
      _isLoading = true;
      EasyLoading.show(status: 'Loading...');
    });

    _querySnapshot = await _services.batchstudents
        .where('batchId', isEqualTo: widget.batchName)
        .get();

    _querySnapshot!.docs.forEach((snapshot) {
      final result = _services.student.doc(snapshot.get('studentId')).get();

      result.then((value) {
        Student student = Student(
          active: value.get('active'),
          parent1Name: value.get('parent1Name'),
          parent1EmailId: value.get('parent1EmailId'),
          parent1PhoneNumber: value.get('parent1PhoneNumber'),
          parent2Name: value.get('parent2Name'),
          parent2EmailId: value.get('parent2EmailId'),
          parent2PhoneNumber: value.get('parent2PhoneNumber'),
          studentName: value.get('studentName'),
          studentPhotoURL: value.get('studentPhotoURL'),
          studentGender: value.get('studentGender'),
          studentDOB: value.get('studentDOB'),
          studentId: value.get('studentId'),
          zone: value.get('zone'),
          timestamp: value.get('timestamp'),
        );

        setState(() {
          batchStudentsList.add(student);
        });
      });
    });
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
      sideBar: _sideBar.sideBarMenus(context, AssignmentsPage.id),
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
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.colorWhite,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _batchName.toString(),
                            style: AppStyles.titleStyleBlack,
                          )
                        ],
                      ),
                      Text(
                        'BATCH',
                        style: AppStyles.tableBodyStyle,
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () {
                      //Navigator.pop(context);
                      Navigator.popAndPushNamed(context, AssignmentsPage.id);
                    },
                    icon: Icon(Icons.cancel, color: Colors.white),
                    label: Text(
                      'Cancel',
                      style: AppStyles.buttonStyleWhite,
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 5),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _assignmentImageUrl!.isNotEmpty
                        ? Image.network(
                            _assignmentImageUrl!,
                            height: 120,
                            width: 120,
                            fit: BoxFit.fill,
                          )
                        : DroppedFileWidget(fileName: assignmentImageName),
                  ),
                  SizedBox(width: 20),
                  Container(
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _cardField(
                          label: 'Details',
                          value: _detail.toString(),
                        ),
                        _cardField(
                          label: 'Zone',
                          value: _zone.toString(),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _cardField(
                          label: 'Start Date',
                          value: _startDate.toString(),
                        ),
                        _cardField(
                          label: 'End Date',
                          value: _endDate.toString(),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            Divider(thickness: 5),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.grey.shade300,
                      ),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: 3, right: 3, top: 2, bottom: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade200,
                            ),
                            child: Text(
                              'STUDENTS',
                              style: AppStyles.tableHeaderStyle,
                            ),
                          ),
                          _buildStudentList(),
                        ],
                      ),
                    ),
                  ),
                  !showDataFlag?
                  Expanded(
                    flex: 2,
                    child: Card(
                      elevation: 5,
                      color: Colors.grey.shade200,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Students Assignment Details will be shown here.',
                            style: AppStyles.tableHeaderStyle,
                          ),
                        ),
                      ),
                    ),
                  ):_buildSummaryCardSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildStudentList() {
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 5,
        color: Colors.grey.shade200,
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListView(
            controller: _studentController,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: [
              ListView.builder(
                itemCount: batchStudentsList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.only(top: 2),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: selectedIndex == index ? AppColors.colorYellow: Colors.grey.shade100,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                        });

                        loadStudentAssignmentDetail(
                          index: index,
                          studentEmailId: batchStudentsList[index].parent1EmailId,
                          assignmentId: widget.assignmentId.toString(),
                        );
                      },
                      child: ListTile(
                        mouseCursor: MouseCursor.defer,
                        leading: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                              batchStudentsList[index].studentPhotoURL),
                        ),
                        title: Text(
                          batchStudentsList[index].studentName,
                          style: AppStyles.tableBodyStyle,
                        ),
                        subtitle: Text(
                          batchStudentsList[index].parent1EmailId,
                          style: AppStyles().getTitleStyle(
                            titleSize: 14,
                            titleColor: Colors.black,
                            titleWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Summary Details
  _buildSummaryCardSection() {

    return Expanded(
      flex: 2,
      child: Card(
        elevation: 5,
        color: Colors.grey.shade200,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            margin: EdgeInsets.all(3),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
            child: _isLoading? Center(child: CircularProgressIndicator(),)
                : ListView(
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
                        'Assignment Details',
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
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          margin: EdgeInsets.symmetric(
                              vertical: 3, horizontal: 3),
                          padding: EdgeInsets.symmetric(
                              vertical: 2, horizontal: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: selectedAssignmentResponseUrl!.isNotEmpty
                              ? Image.network(selectedAssignmentResponseUrl!,fit: BoxFit.fill,)
                              : DroppedFileWidget(
                                  fileName: assignmentImageName),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _cardField(
                                  label: 'Name',
                                  value: selectedStudentName.toString()),
                              _cardField(
                                  label: 'Gender',
                                  value: selectedGender.toString()),
                              _cardField(
                                  label: 'Parent Name [1]', value: selectedParent1Name.toString()),
                              _cardField(
                                  label: 'Parent Email ID [1]', value: selectedParent1EmailId.toString()),
                              _cardField(
                                  label: 'Parent Phone Number [1]',
                                  value: selectedParent1PhoneNumber.toString().isEmpty ? 'NA' :selectedParent1PhoneNumber.toString(),
                              ),
                              _cardField(
                                  label: 'Parent Name [2]', value: selectedParent2Name.toString().isEmpty ? 'NA' :selectedParent2Name.toString()),
                              _cardField(
                                  label: 'Parent Email ID [2]', value: selectedParent2EmailId.toString().isEmpty ? 'NA' :selectedParent2EmailId.toString()),
                              _cardField(
                                label: 'Parent Phone Number [2]',
                                value: selectedParent2PhoneNumber.toString().isEmpty ? 'NA' :selectedParent2PhoneNumber.toString(),
                              ),

                              _cardField(
                                label: 'Assignment Id',
                                value: widget.assignmentId.toString(),
                              ),
                              Spacer(),

                              Container(
                                margin: EdgeInsets.only(left: 10,bottom: 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: selectedStatus.toString() == 'Submitted'? Colors.green :Colors.red
                                  ),
                                  onPressed: (){},
                                  child: Text(
                                    selectedStatus.toString(),
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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

  Future<void> loadStudentAssignmentDetail({index, studentEmailId, assignmentId}) async{

    setState(() {
      showDataFlag = true;
      _isLoading = true;
      EasyLoading.show(status: 'Loading Assignment Detail');
    });

    await _services.assignmentsresponse
        .where('assignmentId', isEqualTo: widget.assignmentId.toString())
        .where('studentId', isEqualTo: studentEmailId)
        .get().then((snapshot){

          if(snapshot.docs.isEmpty){

            print('EMPTY');

            setState(() {
              selectedAssignmentResponseUrl = '';
              selectedStudentName = batchStudentsList[index].studentName;
              selectedGender = batchStudentsList[index].studentGender;
              selectedZone = batchStudentsList[index].zone;
              selectedParent1Name = batchStudentsList[index].parent1Name;
              selectedParent1EmailId = batchStudentsList[index].parent1EmailId;
              selectedParent1PhoneNumber = batchStudentsList[index].parent1PhoneNumber;
              selectedParent2Name = batchStudentsList[index].parent2Name;
              selectedParent2EmailId = batchStudentsList[index].parent2EmailId;
              selectedParent2PhoneNumber = batchStudentsList[index].parent2PhoneNumber;
              selectedStatus = 'Pending';
            });
          }else{

            print('NOT EMPTY');
            snapshot.docs.forEach((snap) {
              setState(() {
                selectedAssignmentResponseUrl = snap.get('assignmentResponseUrl');
                selectedStudentName = batchStudentsList[index].studentName;
                selectedGender = batchStudentsList[index].studentGender;
                selectedZone = batchStudentsList[index].zone;
                selectedParent1EmailId = batchStudentsList[index].parent1EmailId;
                selectedParent1Name = batchStudentsList[index].parent1Name;
                selectedParent1PhoneNumber = batchStudentsList[index].parent1PhoneNumber;
                selectedParent2Name = batchStudentsList[index].parent2Name;
                selectedParent2EmailId = batchStudentsList[index].parent2EmailId;
                selectedParent2PhoneNumber = batchStudentsList[index].parent2PhoneNumber;
                selectedStatus = 'Submitted';
              });
            });
          }

    }).whenComplete((){
      setState(() {
        _isLoading = false;
        EasyLoading.dismiss();
      });
    });

  }
}
