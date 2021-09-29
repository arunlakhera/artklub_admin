import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CoordinatorsList extends StatefulWidget {
  const CoordinatorsList({Key? key}) : super(key: key);

  @override
  _CoordinatorsListState createState() => _CoordinatorsListState();
}

class _CoordinatorsListState extends State<CoordinatorsList> {

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
    _querySnapshot = _services.coordinator.snapshots();
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
                                _querySnapshot = _services.coordinator.snapshots();
                              });
                            }else{
                              setState(() {
                                _querySnapshot = _services.coordinator.where('emailId', isEqualTo: value).snapshots();
                              });
                            }

                          },
                        ),
                        trailing: IconButton(
                          onPressed: (){
                            setState(() {
                              _searchController.clear();
                              _querySnapshot = _services.coordinator.snapshots();
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
                                    'EMAIL ID',
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      _sortColumnIndex = 0;
                                      _ascending = !_ascending!;
                                      ascending = _ascending!;
                                      _querySnapshot = _services.coordinator
                                          .orderBy('emailId', descending: ascending)
                                          .snapshots();
                                    },);
                                  },
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
                                      _querySnapshot = _services.coordinator
                                          .orderBy('name', descending: ascending)
                                          .snapshots();
                                    },);
                                  },
                                ),
                                DataColumn(
                                  label: Text(
                                    'PHONE NUMBER',
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      _sortColumnIndex = 2;
                                      _ascending = !_ascending!;
                                      ascending = _ascending!;
                                      _querySnapshot = _services.coordinator
                                          .orderBy('phoneNumber', descending: ascending)
                                          .snapshots();
                                    });
                                  },
                                ),
                                DataColumn(
                                  label: Text(
                                    'CREATED ON',
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      _sortColumnIndex = 3;
                                      _ascending = !_ascending!;
                                      ascending = _ascending!;
                                      _querySnapshot = _services.coordinator
                                          .orderBy('createdOn', descending: ascending)
                                          .snapshots();
                                    },);
                                  },
                                ),
                                DataColumn(
                                  label: Text(
                                    'STATUS',
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                  onSort: (columnIndex, ascending) {
                                    setState(() {
                                      _sortColumnIndex = 4;
                                      _ascending = !_ascending!;
                                      ascending = _ascending!;
                                      _querySnapshot = _services.coordinator
                                          .orderBy('active', descending: ascending)
                                          .snapshots();
                                    },);
                                  },
                                ),
                              ],
                              rows: _coordinatorsList(snapshot.data!.docs),
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

  List<DataRow> _coordinatorsList(List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(data)).toList();
  }

  DataRow _buildListItem(DocumentSnapshot data) {
    String emailId = data.get('emailId');
    String name = data.get('name');
    String phoneNumber = data.get('phoneNumber');
    Timestamp createdOn = data.get('createdOn');
    bool active = data.get('active');

    return DataRow(cells: [
      DataCell(
        Text(
          emailId,
          style: AppStyles.tableBodyStyle,
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
          phoneNumber.isEmpty ? 'NA' : phoneNumber,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          '${createdOn.toDate().day}/${createdOn.toDate().month}/${createdOn.toDate().year}',
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
        //Text(active? 'Yes' : 'No'),
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
            updateCoordinatorStatus(emailId, status);
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

  updateCoordinatorStatus(emailId, status) async{
    await _services.updateCoordinatorStatus(emailId, status);
  }
}
