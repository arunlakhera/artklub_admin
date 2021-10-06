import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ZonesList extends StatefulWidget {
  const ZonesList({Key? key}) : super(key: key);

  @override
  _ZonesListState createState() => _ZonesListState();
}

class _ZonesListState extends State<ZonesList> {
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
    _querySnapshot = _services.zones.snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
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
                        hintText: 'Search for Zone',
                        hintStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          setState(() {
                            _querySnapshot = _services.zones.snapshots();
                          });
                        } else {
                          setState(() {
                            _querySnapshot = _services.zones
                                .where('zoneName', isEqualTo: value.toUpperCase())
                                .snapshots();
                          });
                        }
                      },
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          _querySnapshot = _services.zones.snapshots();
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
                          print(snapshot.error);
                          return Text('Something Went Wrong! Please Try Again');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                'Zone',
                                style: AppStyles.tableHeaderStyle,
                              ),
                              onSort: (columnIndex, ascending) {
                                setState(
                                  () {
                                    _sortColumnIndex = 0;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.zones
                                        .orderBy('zoneName',
                                            descending: ascending)
                                        .snapshots();
                                  },
                                );
                              },
                            ),
                            DataColumn(
                              label: Text(
                                'State',
                                style: AppStyles.tableHeaderStyle,
                              ),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  _sortColumnIndex = 2;
                                  _ascending = !_ascending!;
                                  ascending = _ascending!;
                                  _querySnapshot = _services.zones
                                      .orderBy('state', descending: ascending)
                                      .snapshots();
                                });
                              },
                            ),
                            DataColumn(
                              label: Text(
                                'City',
                                style: AppStyles.tableHeaderStyle,
                              ),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  _sortColumnIndex = 2;
                                  _ascending = !_ascending!;
                                  ascending = _ascending!;
                                  _querySnapshot = _services.zones
                                      .orderBy('city', descending: ascending)
                                      .snapshots();
                                });
                              },
                            ),
                            DataColumn(
                              label: Text(
                                'Country',
                                style: AppStyles.tableHeaderStyle,
                              ),
                              onSort: (columnIndex, ascending) {
                                setState(() {
                                  _sortColumnIndex = 2;
                                  _ascending = !_ascending!;
                                  ascending = _ascending!;
                                  _querySnapshot = _services.zones
                                      .orderBy('country', descending: ascending)
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
                                setState(
                                  () {
                                    _sortColumnIndex = 3;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.zones
                                        .orderBy('createdOn',
                                            descending: ascending)
                                        .snapshots();
                                  },
                                );
                              },
                            ),
                            DataColumn(
                              label: Text(
                                'STATUS',
                                style: AppStyles.tableHeaderStyle,
                              ),
                              onSort: (columnIndex, ascending) {
                                setState(
                                  () {
                                    _sortColumnIndex = 4;
                                    _ascending = !_ascending!;
                                    ascending = _ascending!;
                                    _querySnapshot = _services.zones
                                        .orderBy('active',
                                            descending: ascending)
                                        .snapshots();
                                  },
                                );
                              },
                            ),
                          ],
                          rows: _zonesList(snapshot.data!.docs),
                        );
                      }),
                ),
              ),
            ],
          );
  }

  List<DataRow> _zonesList(List<DocumentSnapshot> snapshot) {
    return snapshot.map((data) => _buildListItem(data)).toList();
  }

  DataRow _buildListItem(DocumentSnapshot data) {
    String zoneName = data.get('zoneName');
    String state = data.get('state');
    String city = data.get('city');
    String country = data.get('country');
    Timestamp createdOn = data.get('createdOn');
    bool active = data.get('active');

    return DataRow(cells: [
      DataCell(
        Text(
          zoneName,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          state,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          city,
          style: AppStyles.tableBodyStyle,
        ),
      ),
      DataCell(
        Text(
          country,
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
              changeStatus(context, zoneName, !active);
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

  changeStatus(context, zoneName, status) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: "Warning!",
      desc:
          'You are about to change the status for $zoneName to ${status ? 'Active' : 'Inactive'}',
      buttons: [
        DialogButton(
          child: Text(
            "Update",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            updateZoneStatus(zoneName, status);
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

  updateZoneStatus(zoneName, status) async {
    await _services.updateZoneStatus(zoneName, status);
  }
}
