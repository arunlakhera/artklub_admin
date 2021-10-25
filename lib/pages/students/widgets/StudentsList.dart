import 'package:artklub_admin/pages/students/widgets/EditStudentCardWidget.dart';
import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class StudentsList extends StatefulWidget {
  const StudentsList({Key? key}) : super(key: key);

  @override
  _StudentsListState createState() => _StudentsListState();
}

class _StudentsListState extends State<StudentsList> {

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
    _querySnapshot = _services.student.snapshots();

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
                            hintText: 'Search for Email Id',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value){
                            if(value.isEmpty){
                              setState(() {
                                _querySnapshot = _services.student.snapshots();
                              });
                            }else{
                              setState(() {
                                _querySnapshot = _services.student.where('parent1EmailId', isEqualTo: value).snapshots();
                              });
                            }

                          },
                        ),
                        trailing: IconButton(
                          onPressed: (){
                            setState(() {
                              _searchController.clear();
                              _querySnapshot = _services.student.snapshots();
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
                                  'NAME',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 0;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.teacher
                                        .orderBy('name', descending: ascending)
                                        .snapshots();
                                  },);
                                },
                              ),
                              DataColumn(
                                label: Text(
                                  'PARENT EMAIL ID [1]',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 0;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.student
                                        .orderBy('parent1EmailId', descending: ascending)
                                        .snapshots();
                                  },);
                                },
                              ),

                              DataColumn(
                                label: Text(
                                  'PARENT PHONE NUMBER [1]',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 2;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.student
                                        .orderBy('parent1PhoneNumber', descending: ascending)
                                        .snapshots();
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text(
                                  'ZONE',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 3;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.student
                                        .orderBy('zone', descending: ascending)
                                        .snapshots();
                                  });
                                },
                              ),
                              DataColumn(
                                label: Text(
                                  'STATUS',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 5;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.student
                                        .orderBy('active', descending: ascending)
                                        .snapshots();
                                  },);
                                },
                              ),
                              DataColumn(
                                label: Text(
                                  'Action',
                                  style: AppStyles.tableHeaderStyle,
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 5;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.student
                                        .orderBy('active', descending: ascending)
                                        .snapshots();
                                  },);
                                },
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

    String userImageUrl = data.get('studentPhotoURL');
    String name = data.get('studentName');
    String emailId = data.get('parent1EmailId');
    String phoneNumber = data.get('parent1PhoneNumber');
    String zone = data.get('zone');
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
          child: (userImageUrl.isEmpty || userImageUrl == 'NA') ? Icon(Icons.person, color: Colors.grey,)//Text('No Image',style: AppStyles().getTitleStyle(titleSize: 10, titleColor: Colors.black,titleWeight: FontWeight.bold ),)//Placeholder(fallbackWidth: 20, fallbackHeight: 20, strokeWidth: 1, color: Colors.red,)
              :Image.network(userImageUrl,fit: BoxFit.fill,),
        ),
      ),
      DataCell(
        Text(
          name.isEmpty ? 'NA' : name,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          emailId,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          phoneNumber.isEmpty ? 'NA' : phoneNumber,
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
        Container(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              changeStatus(context, emailId, !active);
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
                return EditStudentCardWidget(emailId: emailId,);
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


