
import 'package:artklub_admin/pages/students/widgets/EditStudentCardWidget.dart';
import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:artklub_admin/utilities/AppWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BatchStudentsListWidget extends StatefulWidget {
  const BatchStudentsListWidget({Key? key, required this.batchId}) : super(key: key);

  final String? batchId;

  @override
  _BatchStudentsListWidgetState createState() => _BatchStudentsListWidgetState();
}

class _BatchStudentsListWidgetState extends State<BatchStudentsListWidget> {

  final ScrollController _firstController = ScrollController();

  FirebaseServices _services = FirebaseServices();

  int? _sortColumnIndex;
  bool? _ascending;
  Stream<QuerySnapshot>? _querySnapshot;
  TextEditingController _searchController = TextEditingController();
    List<String> batchStudentsList = [];

  String? _batchId;

  bool isLoading = false;

  @override
  void initState() {
    _ascending = false;
    _sortColumnIndex = 0;
    _batchId = widget.batchId.toString();

    getBatchStudents(_batchId);

    super.initState();
  }

  Future<void> getBatchStudents(batchId) async {

    setState(() {
      batchStudentsList.clear();
      isLoading = true;
      EasyLoading.show(status: 'Loading...');
    });

    await _services.batchstudents.where('batchId',isEqualTo: batchId).get().then((value){
      value.docs.forEach((element) {
        batchStudentsList.add(element.get('studentId'));
      });
    }).whenComplete((){
      setState(() {

        if(batchStudentsList.isEmpty){
          isLoading = false;
          EasyLoading.dismiss();
        }else{
          _querySnapshot = _services.student.where('parent1EmailId', whereIn: batchStudentsList).snapshots();
          isLoading = false;
          EasyLoading.dismiss();
        }

      });
    }).onError((error, stackTrace){
      setState(() {
        print('Error Occurred: $error');
        AppWidgets().showScaffoldMessage(context: context, msg: 'Error Occurred while loading. Please try again!');
        isLoading = false;
        EasyLoading.dismiss();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ?
    Center(child: CircularProgressIndicator()) :
    Expanded(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            child: Scrollbar(
              controller: _firstController,
              child: ListView(
                controller: _firstController,
                shrinkWrap: true,
                children: [

                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width/4,
                      margin: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.search),
                        title: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search for Email Id',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value){
                            setState(() {

                              if(value.isEmpty){
                                getBatchStudents(_batchId);
                              }else{
                                _querySnapshot = _services.student.where('parent1EmailId', isEqualTo: value).snapshots();
                                 }

                            });
                          },
                        ),
                        trailing: IconButton(
                          onPressed: (){
                            setState(() {
                              _searchController.clear();
                              getBatchStudents(widget.batchId);
                            });
                          },
                          icon: Icon(Icons.cancel),
                        ),
                      ),
                    ),
                  ),

                  Card(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _querySnapshot,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something Went Wrong! Please Try Again');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if(batchStudentsList.length < 1){
                            return Center(
                              child: Text(
                                'No Student Assigned to Batch',
                                style: AppStyles.tableHeaderStyle,
                              ),
                            );
                          }

                          return DataTable(
                            showBottomBorder: true,
                            headingRowColor:
                            MaterialStateProperty.all(Colors.grey.shade300),
                            sortAscending: _ascending!,
                            sortColumnIndex: _sortColumnIndex,
                            columns: [

                              DataColumn(
                                label: Text(
                                  'PHOTO',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 0;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.student
                                        .orderBy('studentPhotoURL', descending: ascending)
                                        .snapshots();
                                  },);
                                },
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'NAME',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 0;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.student
                                        .orderBy('studentName', descending: ascending)
                                        .snapshots();
                                  },);
                                },
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'ZONE',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 0;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.student
                                        .orderBy('zone', descending: ascending)
                                        .snapshots();
                                  },);
                                },
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'PARENT NAME [1]',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 2;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.student
                                        .orderBy('parent1Name', descending: ascending)
                                        .snapshots();
                                  });
                                },
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'PARENT EMAIL [1]',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 3;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.student
                                        .orderBy('parent1EmailId', descending: ascending)
                                        .snapshots();
                                  });
                                },
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'PARENT PHONE [1]',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 4;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.student
                                        .orderBy('parent1PhoneNumber', descending: ascending)
                                        .snapshots();
                                  },);
                                },
                              ),
                              DataColumn(
                                label: Text(
                                  'REMOVE',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'ACTION',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                              ),
                            ],
                            rows: _studentsList(snapshot.data!.docs),
                          );
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _studentsList(List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(data)).toList();
  }

  DataRow _buildListItem(DocumentSnapshot data) {

    String studentImageUrl = data.get('studentPhotoURL');
    String studentName = data.get('studentName');
    String zone = data.get('zone');
    String parent1Name = data.get('parent1Name');
    String parent1EmailId = data.get('parent1EmailId');
    String parent1PhoneNumber = data.get('parent1PhoneNumber');

    return DataRow(cells: [

      DataCell(
        Container(
          margin: EdgeInsets.symmetric(vertical: 3, horizontal: 3),
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: (studentImageUrl.isEmpty || studentImageUrl == 'NA') ? Icon(Icons.person, color: Colors.grey,)
              :Image.network(studentImageUrl,fit: BoxFit.fill,),
        ),
      ),
      DataCell(
        Text(
          studentName,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          zone,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          parent1Name,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          parent1EmailId,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          parent1PhoneNumber,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Container(
          width: 100,
          child: IconButton(
            splashRadius: 20,
            splashColor: Colors.red,
            hoverColor: Colors.red.shade50,
            onPressed: (){
              Alert(
                context: context,
                type: AlertType.info,
                title: "Remove!",
                desc: 'You are about to remove student from this batch',
                buttons: [
                  DialogButton(
                    color: Colors.black,
                    child: Text(
                      "Cancel",
                      style: AppStyles.buttonStyleWhite,
                    ),
                    onPressed: () => Navigator.pop(context),
                    width: 120,
                  ),
                  DialogButton(
                    color: Colors.black,
                    child: Text(
                      "Remove",
                      style: AppStyles.buttonStyleWhite,
                    ),
                    onPressed: (){
                      deleteBatchStudent(_batchId, parent1EmailId);
                      Navigator.pop(context);
                      },
                    width: 120,
                  )

                ],
              ).show();
            },
            icon: Icon(Icons.delete, color: Colors.red,),
          ),
        ),
      ),

      DataCell(
          IconButton(
            icon: Icon(Icons.remove_red_eye),
            tooltip: 'View',
            splashColor: Colors.green,
            hoverColor: AppColors.colorLightGreen,
            splashRadius: 20,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return EditStudentCardWidget(emailId: parent1EmailId);
              }));
            },
          )
      ),

    ]);
  }

  changeStatus(context, parent1EmailId, status) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Warning!",
      desc: 'You are about to change the student status to ${status ? 'Active' : 'Inactive'}',
      buttons: [
        DialogButton(
          child: Text(
            "Update",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {

            if(await _services.updateBatchStudentStatus(_batchId, parent1EmailId , status)){
              BatchStudentsListWidget(batchId: _batchId,);
            }
            Navigator.pop(context);
          },
          width: 120,
        ),
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  deleteBatchStudent(_batchId, parent1EmailId){

    setState(() {
      isLoading = true;
      EasyLoading.show(status: 'Loading...');
    });
    /// TODO: Remove the Student from Batch
    try{

      _services.batchstudents
          .where('batchId', isEqualTo: _batchId)
          .where('studentId', isEqualTo: parent1EmailId)
          .get().then((value){
        value.docs.forEach((element) {

          _services.removeStudentFromBatch(id: element.id).then((value){

            getBatchStudents(widget.batchId);

            setState(() {
              isLoading = false;
              EasyLoading.dismiss();
            });
          }).onError((error, stackTrace){
            setState(() {
              isLoading = false;
              EasyLoading.dismiss();
            });
            print('ERROR ');
          });
        });
      });

    }catch(error){
      setState(() {
        isLoading = false;
        EasyLoading.dismiss();
      });
      print('Error Occurred while deleting.');
    }

  }
}

