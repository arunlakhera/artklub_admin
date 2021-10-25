
import 'package:artklub_admin/pages/batches/widgets/EditBatchesCardWidget.dart';
import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BatchesList extends StatefulWidget {
  const BatchesList({Key? key}) : super(key: key);

  @override
  _BatchesListState createState() => _BatchesListState();
}

class _BatchesListState extends State<BatchesList> {

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
    _querySnapshot = _services.batches.snapshots();

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
                            hintText: 'Search for Batch Name',
                            hintStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value){
                            if(value.isEmpty){
                              setState(() {
                                _querySnapshot = _services.batches.snapshots();
                              });
                            }else{
                              setState(() {
                                _querySnapshot = _services.batches.where('name', isEqualTo: value).snapshots();
                              });
                            }

                          },
                        ),
                        trailing: IconButton(
                          onPressed: (){
                            setState(() {
                              _searchController.clear();
                              _querySnapshot = _services.batches.snapshots();
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
                                    _querySnapshot = _services.batches
                                        .orderBy('name', descending: ascending)
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
                                    _querySnapshot = _services.batches
                                        .orderBy('zone', descending: ascending)
                                        .snapshots();
                                  },);
                                },
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'COURSE',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 2;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.batches
                                        .orderBy('course', descending: ascending)
                                        .snapshots();
                                  });
                                },
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'START DATE',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 3;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.batches
                                        .orderBy('startDate', descending: ascending)
                                        .snapshots();
                                  });
                                },
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'START TIME',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 4;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.batches
                                        .orderBy('startTime', descending: ascending)
                                        .snapshots();
                                  },);
                                },
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'STATUS',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                ),
                                onSort: (columnIndex, ascending) {
                                  setState(() {
                                    _sortColumnIndex = 5;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.batches
                                        .orderBy('active', descending: ascending)
                                        .snapshots();
                                  },);
                                },
                              ),
                              DataColumn(
                                label: Expanded(
                                  child: Text(
                                    'ACTION',
                                    overflow: TextOverflow.ellipsis,
                                    style: AppStyles.tableHeaderStyle,
                                  ),
                                ),
                              ),
                            ],
                            rows: _batchesList(snapshot.data!.docs),
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

  List<DataRow> _batchesList(List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(data)).toList();
  }

  DataRow _buildListItem(DocumentSnapshot data) {

    String batchId = data.get('name');
    String zone = data.get('zone');
    String course = data.get('course');
    String startDate = data.get('startDate');
    String startTime = data.get('startTime');
    String endTime = data.get('endTime');

    bool active = data.get('active');

    return DataRow(cells: [

      DataCell(
        Text(
          batchId,
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
          course,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          startDate,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          startTime + ' - ' + endTime ,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Container(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              changeStatus(context, batchId, !active);
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
            tooltip: 'View',
            splashColor: Colors.green,
            hoverColor: AppColors.colorLightGreen,
            splashRadius: 20,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return EditBatchesCardWidget(batchId: batchId);
              }));
            },
          )
      ),

    ]);
  }

  changeStatus(context, batchName, status) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Warning!",
      desc: 'You are about to change the status for $batchName to ${status ? 'Active' : 'Inactive'}',
      buttons: [
        DialogButton(
          child: Text(
            "Update",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            await _services.updateBatchStatus(batchName, status);
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

}
