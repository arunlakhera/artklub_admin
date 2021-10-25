import 'package:artklub_admin/services/firebase_services.dart';
import 'package:artklub_admin/utilities/AppStyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'package:vertical_barchart/vertical-legend.dart';

class SummaryCardWidget extends StatefulWidget {
  const SummaryCardWidget({Key? key}) : super(key: key);

  @override
  _SummaryCardWidgetState createState() => _SummaryCardWidgetState();
}

class _SummaryCardWidgetState extends State<SummaryCardWidget> {

  FirebaseServices _services = FirebaseServices();

  String? _totalStudentsCount,
      _totalBatchesCount,
      _totalTeachersCount,
      _totalJoinRequestsCount;

  bool _isLoading = false;

  List<String> coursesList = ['Rookie','Innovator','Imaginator','Dexter','Adept'];
  int _rookieBatchesCount = 0, _innovatorBatchesCount = 0, _imaginatorBatchesCount = 0,
      _dexterBatchesCount = 0, _adeptBatchesCount = 0;

  int _rookieStudentCount = 0, _innovatorStudentCount = 0, _imaginatorStudentCount = 0,
      _dexterStudentCount = 0, _adeptStudentCount = 0;

  List<VBarChartModel> batchPerCourseBarData = [];
  List<VBarChartModel> studentsPerCourseBarData = [];

  // List<VBarChartModel> bardata = [
  //   VBarChartModel(
  //     index: 0,
  //     label: "Rookie",
  //     colors: [Colors.orange, Colors.deepOrange],
  //     jumlah: 20,
  //     tooltip: "20 Pcs",
  //     description: Text(
  //       "Most selling fruit last week",
  //       style: TextStyle(fontSize: 10),
  //     ),
  //   ),
  //   VBarChartModel(
  //     index: 1,
  //     label: "Innovator",
  //     colors: [Colors.orange, Colors.deepOrange],
  //     jumlah: 55,
  //     tooltip: "55 Pcs",
  //     description: Text(
  //       "Most selling fruit this week",
  //       style: TextStyle(fontSize: 10),
  //     ),
  //   ),
  //   VBarChartModel(
  //     index: 2,
  //     label: "Imaginator",
  //     colors: [Colors.teal, Colors.indigo],
  //     jumlah: 12,
  //     tooltip: "12 Pcs",
  //   ),
  //   VBarChartModel(
  //     index: 3,
  //     label: "Dexter",
  //     colors: [Colors.teal, Colors.indigo],
  //     jumlah: 5,
  //     tooltip: "5 Pcs",
  //   ),
  //   VBarChartModel(
  //     index: 4,
  //     label: "Adept",
  //     colors: [Colors.orange, Colors.deepOrange],
  //     jumlah: 15,
  //     tooltip: "15 Pcs",
  //   ),
  // ];

  @override
  void initState() {
    _totalStudentsCount = '0';
    _totalBatchesCount = '0';
    _totalTeachersCount = '0';
    _totalJoinRequestsCount = '0';

    _rookieBatchesCount = 0;
    _innovatorBatchesCount = 0;
    _imaginatorBatchesCount = 0;
    _dexterBatchesCount = 0;
    _adeptBatchesCount = 0;

    _rookieStudentCount = 0;
    _innovatorStudentCount = 0;
    _imaginatorStudentCount = 0;
    _dexterStudentCount = 0;
    _adeptStudentCount = 0;

    getStudentsCount();
    getTeachersCount();
    getJoinRequestsCount();
    getBatchesCount();
    getCourseBatchesCount();
    getCourseStudentsCount();

    super.initState();
  }

  // Get count of total Students
  Future<void> getStudentsCount() async{

    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Loading');
    });

    await _services.student.get().then((value){

      if(value.docs.isEmpty){
       setState(() {
         _totalStudentsCount = '0';
       });
      }else{
        setState(() {
          _totalStudentsCount = value.docs.length.toString();
        });
      }
    }).whenComplete(() => setState(() {
      _isLoading = false;
      EasyLoading.dismiss();
    }));

  }

  // Get count of total Teachers
  Future<void> getTeachersCount() async{

    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Loading');
    });

    await _services.teacher.get().then((value){

      if(value.docs.isEmpty){
        setState(() {
          _totalTeachersCount = '0';
        });
      }else{
        setState(() {
          _totalTeachersCount = value.docs.length.toString();
        });
      }
    }).whenComplete(() => setState(() {
      _isLoading = false;
      EasyLoading.dismiss();
    }));

  }

  // Get count of total Requests
  Future<void> getJoinRequestsCount() async{

    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Loading');
    });

    await _services.joinRequest.get().then((value){

      if(value.docs.isEmpty){
        setState(() {
          _totalJoinRequestsCount = '0';
        });
      }else{
        setState(() {
          _totalJoinRequestsCount = value.docs.length.toString();
        });
      }
    }).whenComplete(() => setState(() {
      _isLoading = false;
      EasyLoading.dismiss();
    }));

  }

  // Get count of total Batches
  Future<void> getBatchesCount() async{

    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Loading');
    });

    await _services.batches.get().then((value){

      if(value.docs.isEmpty){
        setState(() {
          _totalBatchesCount = '0';
        });
      }else{
        setState(() {
          _totalBatchesCount = value.docs.length.toString();
        });
      }
    }).whenComplete(() => setState(() {
      _isLoading = false;
      EasyLoading.dismiss();
    }));

  }

  // Get Course Batch counts
  Future<void> getCourseBatchesCount() async{

    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Loading');
    });
    await _services.batches.get().then((value){

      value.docs.forEach((element) {

        if(element.get('course') == 'Rookie'){
          _rookieBatchesCount++;
        }else if(element.get('course') == 'Innovator'){
          _innovatorBatchesCount++;
        }else if(element.get('course') == 'Imaginator'){
          _imaginatorBatchesCount++;
        }else if(element.get('course') == 'Dexter'){
          _dexterBatchesCount++;
        }else if(element.get('course') == 'Adept'){
          _adeptBatchesCount++;
        }

      });

      setState(() {
        batchPerCourseBarData.add(
          VBarChartModel(
            index: 0,
            label: "Rookie",
            colors: [Colors.orange, Colors.deepOrange],
            jumlah: _rookieBatchesCount.toDouble(),
            tooltip: _rookieBatchesCount.toString(),
            description: Text(
              'Total Batches for Course',
              style: AppStyles.tableBodyStyle,
            ),
          ),
        );
        batchPerCourseBarData.add(
          VBarChartModel(
            index: 0,
            label: "Innovator",
            colors: [Colors.orange, Colors.deepOrange],
            jumlah: _innovatorBatchesCount.toDouble(),
            tooltip: _innovatorBatchesCount.toString(),
            description: Text(
              'Total Batches for Course',
              style: AppStyles.tableBodyStyle,
            ),
          ),
        );
        batchPerCourseBarData.add(
          VBarChartModel(
            index: 0,
            label: "Imagniator",
            colors: [Colors.orange, Colors.deepOrange],
            jumlah: _imaginatorBatchesCount.toDouble(),
            tooltip: _imaginatorBatchesCount.toString(),
            description: Text(
              'Total Batches for Course',
              style: AppStyles.tableBodyStyle,
            ),
          ),
        );
        batchPerCourseBarData.add(
          VBarChartModel(
            index: 0,
            label: "Dexter",
            colors: [Colors.orange, Colors.deepOrange],
            jumlah: _dexterBatchesCount.toDouble(),
            tooltip: _dexterBatchesCount.toString(),
            description: Text(
              'Total Batches for Course',
              style: AppStyles.tableBodyStyle,
            ),
          ),
        );
        batchPerCourseBarData.add(
          VBarChartModel(
            index: 0,
            label: "Adept",
            colors: [Colors.orange, Colors.deepOrange],
            jumlah: _adeptBatchesCount.toDouble(),
            tooltip: _adeptBatchesCount.toString(),
            description: Text(
              'Total Batches for Course',
              style: AppStyles.tableBodyStyle,
            ),
          ),
        );
      });
    }).whenComplete((){
      setState(() {
        _isLoading = false;
        EasyLoading.dismiss();
      });
    });
  }

  Future<void> getCourseStudentsCount() async{

    setState(() {
      _isLoading = true;
      EasyLoading.show(status: 'Loading Batch');
    });

    final result = _services.batchstudents.snapshots();
    int roo=0,inn=0,ima=0,dex=0,ade=0;

    result.forEach((snapshot) {

      snapshot.docs.forEach((snap) {
        var courseId = snap.get('batchId').toString().substring(4,7);

        if(courseId == 'ROO'){

          _rookieStudentCount++;
        }else if(courseId == 'INN'){

          _innovatorStudentCount++;
        }else if(courseId == 'IMA'){

          _imaginatorStudentCount++;
        }else if(courseId == 'DEX'){

          _dexterStudentCount++;
        }else if(courseId == 'ADE'){

          _adeptStudentCount++;
        }

      });

      setState(() {
        studentsPerCourseBarData.add(
          VBarChartModel(
            index: 0,
            label: "Rookie",
            colors: [Colors.orange, Colors.deepOrange],
            jumlah: _rookieStudentCount.toDouble(),
            tooltip: _rookieStudentCount.toString(),
            description: Text(
              'Total Students in Course',
              style: AppStyles.tableBodyStyle,
            ),
          ),
        );
        studentsPerCourseBarData.add(
          VBarChartModel(
            index: 0,
            label: "Innovator",
            colors: [Colors.orange, Colors.deepOrange],
            jumlah: _innovatorStudentCount.toDouble(),
            tooltip: _innovatorStudentCount.toString(),
            description: Text(
              'Total Students in Course',
              style: AppStyles.tableBodyStyle,
            ),
          ),
        );
        studentsPerCourseBarData.add(
          VBarChartModel(
            index: 0,
            label: "Imagniator",
            colors: [Colors.orange, Colors.deepOrange],
            jumlah: _imaginatorStudentCount.toDouble(),
            tooltip: _imaginatorStudentCount.toString(),
            description: Text(
              'Total Students in Course',
              style: AppStyles.tableBodyStyle,
            ),
          ),
        );
        studentsPerCourseBarData.add(
          VBarChartModel(
            index: 0,
            label: "Dexter",
            colors: [Colors.orange, Colors.deepOrange],
            jumlah: _dexterStudentCount.toDouble(),
            tooltip: _dexterStudentCount.toString(),
            description: Text(
              'Total Students in Course',
              style: AppStyles.tableBodyStyle,
            ),
          ),
        );
        studentsPerCourseBarData.add(
          VBarChartModel(
            index: 0,
            label: "Adept",
            colors: [Colors.orange, Colors.deepOrange],
            jumlah: _adeptStudentCount.toDouble(),
            tooltip: _adeptStudentCount.toString(),
            description: Text(
              'Total Students in Course',
              style: AppStyles.tableBodyStyle,
            ),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading? Center(child: CircularProgressIndicator(),)
        :Container(
      child: Column(
        children: [
          Row(
            children: [
              _cardWidget(title:'Total Students', value: _totalStudentsCount, ringColor: Colors.green),
              _cardWidget(title:'Total Teachers', value: _totalTeachersCount, ringColor: Colors.blue),
              _cardWidget(title:'Total Batches', value: _totalBatchesCount, ringColor: Colors.yellow),
              _cardWidget(title:'Total Requests', value: _totalJoinRequestsCount, ringColor: Colors.pink),
            ],
          ),

          Row(
            children: [
              barChartWidget(barData: batchPerCourseBarData, title: 'Batches Per Course'),
              barChartWidget(barData: studentsPerCourseBarData, title: 'Students Per Course'),
            ],
          ),

        ],
      ),
    );
  }

  Widget barChartWidget({barData, title}){
    return Expanded(
      flex:1,
      child: Card(
        elevation: 5,
        child: Container(
          height: 300,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          child: VerticalBarchart(
            maxX: 55,
            data: barData,
            showLegend: true,
            alwaysShowDescription: true,
            showBackdrop: true,
            legend: [
              Vlegend(
                isSquare: false,
                color: Colors.orange,
                text: title,
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _cardWidget({title, value, ringColor}){
    return Expanded(
      flex: 1,
      child: Card(
        elevation: 5,
        color: Colors.grey.shade100,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: ringColor,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade50,
                    child: Text(
                      value,
                      style: AppStyles().getTitleStyle(
                        titleSize: 35,
                        titleColor: Colors.blue.shade900,
                        titleWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                title,
                style: AppStyles.tableHeaderStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
