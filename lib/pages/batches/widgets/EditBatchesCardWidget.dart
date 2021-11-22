import 'package:artklub_admin/model/Student.dart';
import 'package:artklub_admin/model/Teacher.dart';
import 'package:artklub_admin/pages/batches/BatchesPage.dart';
import 'package:artklub_admin/pages/batches/widgets/BatchStudentsListWidget.dart';
import 'package:artklub_admin/services/SideBarMenu.dart';
import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:artklub_admin/utilities/AppWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditBatchesCardWidget extends StatefulWidget {
  const EditBatchesCardWidget({Key? key, required this.batchId})
      : super(key: key);

  final String batchId;
  static const String id = 'editBatches-page';

  @override
  _EditBatchesCardWidgetState createState() => _EditBatchesCardWidgetState();
}

class _EditBatchesCardWidgetState extends State<EditBatchesCardWidget> {
  SideBarWidget _sideBar = SideBarWidget();
  bool _isLoading = false;
  bool _updatePrimaryFlag = false;
  bool _updateBackupFlag = false;
  bool _updateStudentFlag = false;

  final ScrollController _teacherController = ScrollController();
  final ScrollController _teacherBackupController = ScrollController();
  final ScrollController _studentController = ScrollController();

  TextEditingController _searchController = TextEditingController();
  TextEditingController _searchBackupController = TextEditingController();
  TextEditingController _searchStudentController = TextEditingController();

  FirebaseServices _services = FirebaseServices();

  String? _batchId, _zone, _course, _startDate, _endDate, _startTime, _endTime;

  String? _primaryName,
      _primaryEmailId,
      _primaryPhoneNumber,
      teacherImageUrl,
      _backupName,
      _backupEmailId,
      _backupPhoneNumber,
      teacherBackupImageUrl;

  Stream<QuerySnapshot>? _queryAllTeacherSnapshot;
  Stream<QuerySnapshot>? _queryAllStudentSnapshot;

  List<Teacher> teachersList = [];
  List<Student> studentsList = [];

  @override
  void initState() {
    _batchId = widget.batchId;
    _zone = '';
    _course = '';
    _startDate = '';
    _endDate = '';
    _startTime = '';
    _endTime = '';

    _primaryName = '';
    _primaryEmailId = '';
    _primaryPhoneNumber = '';

    _backupName = '';
    _backupEmailId = '';
    _backupPhoneNumber = '';

    _queryAllTeacherSnapshot = _services.teacher.snapshots();

    getBatch();
    getAllTeachers();
    getAllStudents();
    getPrimaryTeacher();
    getBackupTeacher();

    super.initState();
  }

  Future<void> getBatch() async {
    try {
      setState(() {
        _isLoading = true;
        EasyLoading.show(status: 'Checking...');
      });

      final QuerySnapshot result = await _services.batches
          .where('name', isEqualTo: widget.batchId)
          .limit(1)
          .get();

      result.docs.forEach((batchSnapshot) {
        setState(() {
          _batchId = batchSnapshot.get('name');
          _zone = batchSnapshot.get('zone');
          _course = batchSnapshot.get('courses');
          _startDate = batchSnapshot.get('startDate');
          _endDate = batchSnapshot.get('endDate');
          _startTime = batchSnapshot.get('startTime');
          _endTime = batchSnapshot.get('endTime');
        });
      });

      setState(() {
        _isLoading = false;
        EasyLoading.dismiss();
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

  Future<void> getAllTeachers() async {
    try {
      teachersList.clear();

      setState(() {
        _isLoading = true;
        EasyLoading.show(status: 'Loading...');
      });

      _queryAllTeacherSnapshot =
          _services.teacher.where('active', isEqualTo: true).snapshots();

      await _queryAllTeacherSnapshot!.forEach((teacherSnapshot) {
        teacherSnapshot.docs.forEach((snap) {
          Teacher teacher = Teacher(
            name: snap.get('name'),
            gender: snap.get('gender'),
            emailId: snap.get('emailId'),
            phoneNumber: snap.get('phoneNumber'),
            address: snap.get('address'),
            city: snap.get('city'),
            state: snap.get('state'),
            country: snap.get('country'),
            zipcode: snap.get('zipcode'),
            zone: snap.get('zone'),
            userImageUrl: snap.get('userImageUrl'),
            active: snap.get('active'),
            createdBy: snap.get('createdBy'),
            updatedBy: snap.get('updatedBy'),
          );

          setState(() {
            teachersList.add(teacher);
            _isLoading = false;
            EasyLoading.dismiss();
          });
        });
      }).whenComplete(() {
        setState(() {
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

  Future<void> getAllStudents() async {

    try {
      studentsList.clear();

      setState(() {
        _isLoading = true;
        EasyLoading.show(status: 'Loading...');
      });

      _queryAllStudentSnapshot =
          _services.student.where('active', isEqualTo: true).snapshots();

      await _queryAllStudentSnapshot!.forEach((studentSnapshot) {

        if(studentSnapshot.size > 0) {
          studentSnapshot.docs.forEach((snap) {
            Student student = Student(
              active: snap.get('active'),
              parent1EmailId: snap.get('parent1EmailId'),
              parent1Name: snap.get('parent1Name'),
              parent1PhoneNumber: snap.get('parent1PhoneNumber'),
              parent2EmailId: snap.get('parent2EmailId'),
              parent2Name: snap.get('parent2Name'),
              parent2PhoneNumber: snap.get('parent2PhoneNumber'),
              studentDOB: snap.get('studentDOB'),
              studentGender: snap.get('studentGender'),
              studentId: snap.get('studentId'),
              studentName: snap.get('studentName'),
              studentPhotoURL: snap.get('studentPhotoURL'),
              timestamp: snap.get('timestamp'),
              zone: snap.get('zone'),
            );

            setState(() {
              studentsList.add(student);
              _isLoading = false;
              EasyLoading.dismiss();
            });
          });
        }else{
          setState(() {
            _isLoading = false;
            EasyLoading.dismiss();
          });
        }

      }).whenComplete(() {
        setState(() {
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

    try {
      studentsList.clear();

      setState(() {
        _isLoading = true;
        EasyLoading.show(status: 'Loading...');
      });

      _queryAllStudentSnapshot =
          _services.student.where('active', isEqualTo: true).snapshots();

      await _queryAllStudentSnapshot!.forEach((studentSnapshot) {
        studentSnapshot.docs.forEach((snap) {
          Student student = Student(
            active: snap.get('active'),
            parent1EmailId: snap.get('parent1EmailId'),
            parent1Name: snap.get('parent1Name'),
            parent1PhoneNumber: snap.get('parent1PhoneNumber'),
            parent2EmailId: snap.get('parent2EmailId'),
            parent2Name: snap.get('parent2Name'),
            parent2PhoneNumber: snap.get('parent2PhoneNumber'),
            studentDOB: snap.get('studentDOB'),
            studentGender: snap.get('studentGender'),
            studentId: snap.get('studentId'),
            studentName: snap.get('studentName'),
            studentPhotoURL: snap.get('studentPhotoURL'),
            timestamp: snap.get('timestamp'),
            zone: snap.get('zone'),
          );

          setState(() {
            studentsList.add(student);
            _isLoading = false;
            EasyLoading.dismiss();
          });
        });
      }).whenComplete(() {
        setState(() {
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

  Future<void> getPrimaryTeacher() async {
    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Loading...');
    });

    final queryPrimaryTeacherSnap =
        await _services.primaryteacher.where('active', isEqualTo: true).get();

    queryPrimaryTeacherSnap.docs.forEach((primaryTeacherSnap) async {
      if (primaryTeacherSnap.id == _batchId) {

        final result =
            await _services.getTeacher(primaryTeacherSnap.get('teacherId'));

        setState(() {
          _primaryName = result.get('name');
          _primaryPhoneNumber = result.get('phoneNumber');
          _primaryEmailId = result.get('emailId');
          teacherImageUrl = result.get('userImageUrl');

          setState(() {
            _isLoading = false;
            EasyLoading.dismiss();
          });
        });
      } else {
        _primaryName = '';
        _primaryPhoneNumber = '';
        teacherImageUrl = '';
        _primaryEmailId = '';

        setState(() {
          _isLoading = false;
          EasyLoading.dismiss();
        });
      }
    });
  }

  Future<void> getBackupTeacher() async {
    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Loading...');
    });

    final queryBackupTeacherSnap =
        await _services.backupteacher.where('active', isEqualTo: true).get();

    queryBackupTeacherSnap.docs.forEach((backupTeacherSnap) async {
      if (backupTeacherSnap.id == _batchId) {
        final result =
            await _services.getTeacher(backupTeacherSnap.get('teacherId'));

        setState(() {
          _backupName = result.get('name');
          _backupPhoneNumber = result.get('phoneNumber');
          _backupEmailId = result.get('emailId');
          teacherBackupImageUrl = result.get('userImageUrl');

          setState(() {
            _isLoading = false;
            EasyLoading.dismiss();
          });
        });
      } else {
        _backupName = '';
        _backupPhoneNumber = '';
        _backupEmailId = '';
        teacherBackupImageUrl = '';

        setState(() {
          _isLoading = false;
          EasyLoading.dismiss();
        });
      }
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
        sideBar: _sideBar.sideBarMenus(context, BatchesPage.id),
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
                              _batchId.toString(),
                              style: AppStyles.titleStyleBlack,
                            )
                          ],
                        ),
                        Text(
                          'BATCH NAME',
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
                        Navigator.popAndPushNamed(context, BatchesPage.id);
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
              Divider(
                thickness: 5,
              ),
              _buildPageHeader(),
              Divider(
                thickness: 5,
              ),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _buildAssignToBatchCardSection(),
              _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : _buildStudentListCardSection(),
            ],
          ),
        ),
    );
  }

  Widget _buildPageHeader() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.colorYellow,
      ),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBatchDetailField(
                          title: 'ZONE', value: _zone.toString().toUpperCase()),
                      SizedBox(width: 30),
                      _buildBatchDetailField(
                          title: 'COURSE',
                          value: _course.toString().toUpperCase()),
                    ],
                  ),
                  SizedBox(width: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBatchDetailField(
                          title: 'START DATE', value: _startDate.toString()),
                      SizedBox(width: 30),
                      _buildBatchDetailField(
                          title: 'END DATE', value: _endDate.toString()),
                    ],
                  ),
                  SizedBox(width: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBatchDetailField(
                          title: 'START TIME', value: _startTime.toString()),
                      SizedBox(width: 30),
                      _buildBatchDetailField(
                          title: 'END TIME', value: _endTime.toString()),
                    ],
                  ),
                ],
              )
            ],
          ),
          if (MediaQuery.of(context).size.width >= 615) ...{
            Spacer(),
            Image.asset(
              'assets/images/coordinator.png',
              height: 80,
            ),
          }
        ],
      ),
    );
  }

  _buildBatchDetailField({
    title,
    value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              value.toString(),
              style: AppStyles.tableHeaderStyle,
            )
          ],
        ),
        Text(
          title,
          style: AppStyles.tableBodyStyle,
        ),
      ],
    );
  }

  _buildAssignToBatchCardSection() {
    return Card(
      elevation: 5,
      color: Colors.grey.shade200,
      child: Container(
        height: 200,
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            !_updatePrimaryFlag
                ? _buildPrimaryTeacherCard()
                : _buildPrimaryTeacherList(),
            !_updateBackupFlag
                ? _buildBackupTeacherCard()
                : _buildBackupTeacherList(),
            !_updateStudentFlag ? _buildStudentCard() : _buildStudentList(),
          ],
        ),
      ),
    );
  }

  _buildPrimaryTeacherCard() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
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
                child: (_primaryEmailId == null || _primaryEmailId!.isEmpty)
                    ? Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Primary Teacher Not Assigned',
                              style: AppStyles.tableBodyStyle,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _updatePrimaryFlag = true;
                                });
                              },
                              child: Text(
                                'Assign',
                                style: AppStyles.buttonStyleWhite,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        children: [
                          Column(
                            children: [
                              Center(
                                child: Text(
                                  'Primary Teacher',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: 2,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade300,
                                    ),
                                    child: Center(
                                      child: (teacherImageUrl == null ||
                                              teacherImageUrl!.isEmpty)
                                          ? Text(
                                              'No Image',
                                              style: AppStyles.tableBodyStyle,
                                            )
                                          : CircleAvatar(
                                        radius: 60, backgroundImage: NetworkImage(teacherImageUrl!,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (_primaryName == null ||
                                                  _primaryName!.isEmpty)
                                              ? 'Not Available'
                                              : _primaryName.toString(),
                                          style: AppStyles.tableBodyStyle,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          _primaryEmailId.toString(),
                                          style: AppStyles.tableBodyStyle,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          (_primaryPhoneNumber == null ||
                                                  _primaryPhoneNumber!.isEmpty)
                                              ? 'Not Available'
                                              : _primaryPhoneNumber.toString(),
                                          style: AppStyles.tableBodyStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  //widget.cardKey.currentState!.toggleCard();
                                  _updatePrimaryFlag = true;
                                });
                              },
                              child: Text(
                                'Update',
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
  }

  _buildPrimaryTeacherList() {
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
            controller: _teacherController,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _updatePrimaryFlag = false;
                  });
                },
                child: Text(
                  'Go Back',
                  style: AppStyles.tableBodyStyle,
                ),
              ),
              Container(
                height: 45,
                alignment: Alignment.center,
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 3, right: 3),
                      height: 45,
                      child: Icon(
                        Icons.search,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 3, right: 3),
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: _searchController,
                          style: AppStyles().getTitleStyle(
                            titleSize: 12,
                            titleColor: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search for Email Id',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                _queryAllTeacherSnapshot =
                                    _services.teacher.snapshots();
                              });
                            } else {
                              setState(() {
                                List<Teacher> selectedTeacher = [];
                                teachersList.forEach((element) {
                                  if (element.emailId.contains(value)) {
                                    selectedTeacher.add(element);
                                    return;
                                  }
                                });
                                teachersList = selectedTeacher;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          //_querySnapshot = _services.teacher.snapshots();
                          getAllTeachers();
                        });
                      },
                      icon: Icon(
                        Icons.cancel,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                itemCount: teachersList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 15,
                      backgroundImage:
                          NetworkImage(teachersList[index].userImageUrl),
                    ),
                    title: Text(
                      teachersList[index].emailId,
                      style: AppStyles().getTitleStyle(
                        titleSize: 12,
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        showAlert(
                          title: 'Assign Teacher',
                          desc: 'You are about to assign Primary Teacher',
                          emailId: teachersList[index].emailId,
                          type: 'primary',
                        );
                      },
                      child: Text('Add'),
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

  _buildBackupTeacherCard() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
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
                child: (_backupEmailId == null || _backupEmailId!.isEmpty)
                    ? Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Backup Teacher Not Assigned',
                              style: AppStyles.tableBodyStyle,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  _updateBackupFlag = true;
                                });
                              },
                              child: Text(
                                'Assign',
                                style: AppStyles.buttonStyleWhite,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Stack(
                        children: [
                          Column(
                            children: [
                              Center(
                                child: Text(
                                  'Backup Teacher',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                              ),
                              Center(
                                child: Container(
                                  height: 2,
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    height: 120,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade300,
                                    ),
                                    child: Center(
                                      child: (teacherBackupImageUrl == null ||
                                              teacherBackupImageUrl!.isEmpty)
                                          ? Text(
                                              'No Image',
                                              style: AppStyles.tableBodyStyle,
                                            )
                                          : CircleAvatar(
                                        radius: 60, backgroundImage: NetworkImage(teacherBackupImageUrl!,),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 5, right: 5),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          (_backupName == null ||
                                                  _backupName!.isEmpty)
                                              ? 'Not Available'
                                              : _backupName.toString(),
                                          style: AppStyles.tableBodyStyle,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          _backupEmailId.toString(),
                                          style: AppStyles.tableBodyStyle,
                                        ),
                                        SizedBox(height: 3),
                                        Text(
                                          (_backupPhoneNumber == null ||
                                                  _backupPhoneNumber!.isEmpty)
                                              ? 'Not Available'
                                              : _backupPhoneNumber.toString(),
                                          style: AppStyles.tableBodyStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          Positioned(
                            bottom: 1,
                            right: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _updateBackupFlag = true;
                                });
                              },
                              child: Text(
                                'Update',
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
  }

  _buildBackupTeacherList() {
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
            controller: _teacherBackupController,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _updateBackupFlag = false;
                  });
                },
                child: Text(
                  'Go Back',
                  style: AppStyles.tableBodyStyle,
                ),
              ),
              Container(
                height: 45,
                alignment: Alignment.center,
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 3, right: 3),
                      height: 45,
                      child: Icon(
                        Icons.search,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 3, right: 3),
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: _searchBackupController,
                          style: AppStyles().getTitleStyle(
                            titleSize: 12,
                            titleColor: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search for Email Id',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                _queryAllTeacherSnapshot =
                                    _services.teacher.snapshots();
                              });
                            } else {
                              setState(() {
                                List<Teacher> selectedTeacher = [];
                                teachersList.forEach((element) {
                                  if (element.emailId.contains(value)) {
                                    selectedTeacher.add(element);
                                    return;
                                  }
                                });
                                teachersList = selectedTeacher;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _searchBackupController.clear();
                          //_querySnapshot = _services.teacher.snapshots();
                          getAllTeachers();
                        });
                      },
                      icon: Icon(
                        Icons.cancel,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                itemCount: teachersList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 15,
                      backgroundImage:
                          NetworkImage(teachersList[index].userImageUrl),
                    ),
                    title: Text(
                      teachersList[index].emailId,
                      style: AppStyles().getTitleStyle(
                        titleSize: 12,
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        showAlert(
                          title: 'Assign Backup Teacher',
                          desc: 'You are about to assign Backup Teacher',
                          emailId: teachersList[index].emailId,
                          type: 'backup',
                        );
                      },
                      child: Text('Add'),
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

  _buildStudentCard() {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Expanded(
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
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Assign Student to Batch',
                        style: AppStyles.tableBodyStyle,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _updateStudentFlag = true;
                          });
                        },
                        child: Text(
                          'Assign',
                          style: AppStyles.buttonStyleWhite,
                        ),
                      ),
                    ],
                  ),
                ),
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
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _updateStudentFlag = false;
                  });
                },
                child: Text(
                  'Go Back',
                  style: AppStyles.tableBodyStyle,
                ),
              ),
              Container(
                height: 45,
                alignment: Alignment.center,
                margin: EdgeInsets.all(2),
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 3, right: 3),
                      height: 45,
                      child: Icon(
                        Icons.search,
                        size: 20,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.only(left: 3, right: 3),
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: _searchStudentController,
                          style: AppStyles().getTitleStyle(
                            titleSize: 12,
                            titleColor: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search for Email Id',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {
                                _queryAllStudentSnapshot =
                                    _services.student.snapshots();
                              });
                            } else {
                              setState(() {
                                List<Student> selectedStudent = [];
                                studentsList.forEach((element) {
                                  if (element.parent1EmailId.contains(value)) {
                                    selectedStudent.add(element);
                                    return;
                                  }
                                });
                                studentsList = selectedStudent;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {

                          _searchStudentController.clear();
                          getAllStudents();
                        });
                      },
                      icon: Icon(
                        Icons.cancel,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.builder(
                itemCount: studentsList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 15,
                      backgroundImage:
                          NetworkImage(studentsList[index].studentPhotoURL),
                    ),
                    title: Text(
                      studentsList[index].parent1EmailId,
                      style: AppStyles().getTitleStyle(
                        titleSize: 12,
                      ),
                    ),
                    trailing: TextButton(
                      onPressed: () async {

                        final QuerySnapshot result = await _services.batchstudents
                            .where('studentId', isEqualTo: studentsList[index].parent1EmailId)
                            .where('batchId',isEqualTo: _batchId)
                            .limit(1)
                            .get().whenComplete(() {
                          setState(() {
                            _isLoading = false;
                            EasyLoading.dismiss();
                          });
                        });
                        final List<DocumentSnapshot> documents = result.docs;

                        if(documents.length > 0){
                          AppWidgets().showScaffoldMessage(context: context,msg: 'Student already added');
                        }else{
                          showAlert(
                            title: 'Assign Student',
                            desc: 'You are about to assign Student to Batch',
                            emailId: studentsList[index].parent1EmailId,
                            type: 'student',
                          );
                        }


                      },
                      child: Text('Add'),
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

  _buildStudentListCardSection() {
    //print(_batchId);
    return BatchStudentsListWidget(batchId: _batchId);
  }

  void showAlert({title, desc, emailId, type}) {
    Alert(
        context: context,
        type: AlertType.info,
        title: title,
        desc: desc,
        style: AlertStyle(
          titleStyle: AppStyles.tableHeaderStyle,
          descStyle: AppStyles.tableBodyStyle,
        ),
        buttons: [
          DialogButton(
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: AppStyles.buttonStyleWhite,
            ),
          ),
          DialogButton(
            color: Colors.black,
            onPressed: () {
              if (type == 'primary') {
                _services.primaryteacher.doc(_batchId).set({
                  'teacherId': emailId,
                  'active': true,
                }).whenComplete(() {
                  setState(() {
                    _updatePrimaryFlag = false;
                  });

                  getPrimaryTeacher();
                  Navigator.pop(context);
                });
              } else if (type == 'backup') {
                _services.backupteacher.doc(_batchId).set({
                  'teacherId': emailId,
                  'active': true,
                }).whenComplete(() {
                  setState(() {
                    _updateBackupFlag = false;
                  });

                  getBackupTeacher();
                  Navigator.pop(context);
                });
              } else if (type == 'student') {

                // Check if email Id already added

                _services.batchstudents.doc().set({
                  'batchId': _batchId,
                  'studentId': emailId,
                  'active': true,
                }).whenComplete(() {
                  setState(() {
                    _updateStudentFlag = false;
                  });

                  getBatchStudents();
                  Navigator.pop(context);
                });
              }

            },
            child: Text(
              'Assign',
              style: AppStyles.buttonStyleWhite,
            ),
          ),
        ]).show();
  }

  Future<bool> doesStudentAlreadyExist(String? emailId) async {

    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Checking...');
    });

    final QuerySnapshot result = await _services.batchstudents
        .where('studentId', isEqualTo: emailId)
        .limit(1)
        .get().whenComplete(() {
      setState(() {
        _isLoading = false;
        EasyLoading.dismiss();
      });
    });
    final List<DocumentSnapshot> documents = result.docs;
    int docLen = documents.length;
    return docLen > 0 ? true : false;
  }
}
