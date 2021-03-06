
import 'package:artklub_admin/model/ScreenArguments.dart';
import 'package:artklub_admin/pages/adminusers/AdminUsersPage.dart';
import 'package:artklub_admin/pages/assignments/AssignmentsPage.dart';
import 'package:artklub_admin/pages/batches/BatchesPage.dart';
import 'package:artklub_admin/pages/courses/CoursesPage.dart';
import 'package:artklub_admin/pages/dashboard/DashboardPage.dart';
import 'package:artklub_admin/pages/HomePage.dart';
import 'package:artklub_admin/pages/SplashPage.dart';
import 'package:artklub_admin/pages/joinrequests/JoinRequestsPage.dart';
import 'package:artklub_admin/pages/notifications/NotificationsPage.dart';
import 'package:artklub_admin/pages/payments/PaymentsPage.dart';
import 'package:artklub_admin/pages/reports/ReportsPage.dart';
import 'package:artklub_admin/pages/students/StudentsPage.dart';
import 'package:artklub_admin/pages/teachers/TeachersPage.dart';
import 'package:artklub_admin/pages/zonehead/ZoneHeadPage.dart';
import 'package:artklub_admin/pages/zonemanager/ZoneManagerPage.dart';
import 'package:artklub_admin/pages/zones/ZonesPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Artklub Admin Dashboard',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: SplashPage(),
      routes: {
        HomePage.id:(context) => HomePage(title: 'Artklub Admin Dashboard'),
        SplashPage.id:(context) => SplashPage(),
        DashboardPage.id:(context) => DashboardPage(),
        CoursesPage.id:(context) => CoursesPage(),
        ZonesPage.id:(context) => ZonesPage(),
        ZoneManagerPage.id:(context) => ZoneManagerPage(),
        ZoneHeadPage.id:(context) => ZoneHeadPage(),
        JoinRequestsPage.id:(context) => JoinRequestsPage(),
        TeachersPage.id:(context) => TeachersPage(),

        BatchesPage.id:(context) => BatchesPage(),
        StudentsPage.id:(context) => StudentsPage(),
        AssignmentsPage.id:(context) => AssignmentsPage(),

        PaymentsPage.id:(context) => PaymentsPage(),
        NotificationsPage.id:(context) => NotificationsPage(),
        ReportsPage.id:(context) => ReportsPage(),
        AdminUsersPage.id:(context) => AdminUsersPage(),

    },
      builder: EasyLoading.init(),

    );
  }
}
