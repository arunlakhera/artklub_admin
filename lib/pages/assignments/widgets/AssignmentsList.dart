import 'package:artklub_admin/pages/assignments/widgets/EditAssignmentCardWidget.dart';
import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AssignmentsList extends StatefulWidget {
  const AssignmentsList({Key? key}) : super(key: key);

  @override
  _AssignmentsListState createState() => _AssignmentsListState();
}

class _AssignmentsListState extends State<AssignmentsList> {

  final ScrollController _firstController = ScrollController();

  FirebaseServices _services = FirebaseServices();

  int? _sortColumnIndex;
  bool? _ascending;
  Stream<QuerySnapshot>? _querySnapshot;
  TextEditingController _searchController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    _ascending = false;
    _sortColumnIndex = 0;
    _querySnapshot = _services.assignments.snapshots();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Center(child: CircularProgressIndicator()) :Expanded(
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
                            hintText: 'Search for Assignment',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value){
                            if(value.isEmpty){
                              setState(() {
                                _querySnapshot = _services.assignments.snapshots();
                              });
                            }else{
                              setState(() {
                                _querySnapshot = _services.assignments.where('detail', isEqualTo: value).snapshots();
                              });
                            }

                          },
                        ),
                        trailing: IconButton(
                          onPressed: (){
                            setState(() {
                              _searchController.clear();
                              _querySnapshot = _services.assignments.snapshots();
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
                              ),
                              DataColumn(
                                label: Text(
                                  'DETAIL',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'ZONE',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'BATCH',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'END DATE',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'ACTIVE',
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
                            rows: _assignmentsList(snapshot.data!.docs),
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

  List<DataRow> _assignmentsList(List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(data)).toList();
  }

  DataRow _buildListItem(DocumentSnapshot data) {

    String assignmentId = data.id;
    String assignmentImageUrl = data.get('assignmentImageUrl');
    String detail = data.get('detail');
    String zone = data.get('zone');
    String batchName = data.get('batchName');
    String endDate = data.get('endDate');

    bool active = data.get('active');

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
          child: (assignmentImageUrl.isEmpty || assignmentImageUrl == 'NA') ? Icon(Icons.person, color: Colors.grey,)//Text('No Image',style: AppStyles().getTitleStyle(titleSize: 10, titleColor: Colors.black,titleWeight: FontWeight.bold ),)//Placeholder(fallbackWidth: 20, fallbackHeight: 20, strokeWidth: 1, color: Colors.red,)
              :Image.network(assignmentImageUrl,fit: BoxFit.fill,),
        ),
      ),
      DataCell(
        Text(
          detail.isEmpty ? 'NA' : detail,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          zone.isEmpty ? 'NA' : zone,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          batchName.isEmpty ? 'NA' : batchName,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          endDate.isEmpty ? 'NA' : endDate,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Container(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              //changeStatus(context, batchId, !active);
            },
            style: ElevatedButton.styleFrom(
              primary: active ? Colors.green : Colors.grey,
            ),
            child: Text(
              active ? 'Active' : 'Inactive',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),

      DataCell(
          IconButton(
            icon: Icon(Icons.remove_red_eye),
            splashColor: Colors.green,
            hoverColor: AppColors.colorLightGreen,
            tooltip: 'View',
            splashRadius: 20,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return EditAssignmentCardWidget(batchName: batchName ,assignmentId: assignmentId,);
              }));
            },
          )
      ),

    ]);
  }

  changeStatus(context, emailId, status) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Warning!",
      desc: 'You are about to change the status for $emailId to ${status ? 'Active' : 'Inactive'}',
      buttons: [
        DialogButton(
          child: Text(
            "Update",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            updateStudentStatus(emailId, status);
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

  updateStudentStatus(emailId, status) async{

    setState(() {
      _querySnapshot = _services.student.snapshots();

      isLoading = true;
      EasyLoading.show(status: 'Loading...');
    });

    await _services.student
        .where('parent1EmailId', isEqualTo: emailId)
        .get().then((value){
      value.docs.forEach((element) {

        _services.updateStudentStatus(element.id, status).then((value){

          setState(() {
            _querySnapshot = _services.student.snapshots();
            isLoading = false;
            EasyLoading.dismiss();
          });
        }).onError((error, stackTrace){
          print('Error');
          setState(() {
            isLoading = false;
            EasyLoading.dismiss();
          });
        });

      });
    });

    await _services.updateStudentStatus(emailId, status);
  }
}
