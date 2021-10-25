import 'package:artklub_admin/pages/HomePage.dart';
import 'package:artklub_admin/pages/adminusers/AdminUsersPage.dart';
import 'package:artklub_admin/pages/assignments/AssignmentsPage.dart';
import 'package:artklub_admin/pages/batches/BatchesPage.dart';
import 'package:artklub_admin/pages/coordinators/CoordinatorsPage.dart';
import 'package:artklub_admin/pages/dashboard/DashboardPage.dart';
import 'package:artklub_admin/pages/joinrequests/JoinRequestsPage.dart';
import 'package:artklub_admin/pages/notifications/NotificationsPage.dart';
import 'package:artklub_admin/pages/payments/PaymentsPage.dart';
import 'package:artklub_admin/pages/reports/ReportsPage.dart';
import 'package:artklub_admin/pages/students/StudentsPage.dart';
import 'package:artklub_admin/pages/teachers/TeachersPage.dart';
import 'package:artklub_admin/pages/zones/ZonesPage.dart';
import 'package:artklub_admin/utilities/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:google_fonts/google_fonts.dart';

class SideBarWidget{

  sideBarMenus(context, selectedRoute, {userType = 'a'}){
    return SideBar(
      backgroundColor: AppColors.colorLightGreen,
      activeBackgroundColor: Colors.grey.shade900,
      borderColor: Colors.grey,
      textStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
        fontSize: 16,
      ),
      activeTextStyle: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        color: Colors.white,
        fontSize: 18,
      ),
      items: const [
        MenuItem(
          title: 'Dashboard',
          route: DashboardPage.id,
          icon: Icons.dashboard,
        ),
        MenuItem(
          title: 'Zones',
          route: ZonesPage.id,
          icon: Icons.location_pin,
        ),
        MenuItem(
          title: 'Coordinators',
          route: CoordinatorsPage.id,
          icon: Icons.person,
        ),
        MenuItem(
          title: 'Join Requests',
          route: JoinRequestsPage.id,
          icon: Icons.email,
        ),
        MenuItem(
          title: 'Teachers',
          route: TeachersPage.id,
          icon: Icons.account_box_outlined,
        ),
        MenuItem(
          title: 'Batches',
          route: BatchesPage.id,
          icon: Icons.timer,
        ),
        MenuItem(
          title: 'Students',
          route: StudentsPage.id,
          icon: Icons.group,
        ),
        MenuItem(
          title: 'Assignments',
          route: AssignmentsPage.id,
          icon: Icons.article,
        ),
        MenuItem(
          title: 'Payments',
          route: PaymentsPage.id,
          icon: Icons.payment,
        ),
        MenuItem(
          title: 'Notifications',
          route: NotificationsPage.id,
          icon: Icons.notifications,
        ),
        MenuItem(
          title: 'Reports',
          route: ReportsPage.id,
          icon: Icons.article,
        ),
        MenuItem(
          title: 'Admin Users',
          route: AdminUsersPage.id,
          icon: Icons.accessibility,
        ),
        MenuItem(
          title: 'Logout',
          route: HomePage.id,
          icon: Icons.settings_power,
        ),

      ],
      selectedRoute: selectedRoute,
      onSelected: (item) {
        if (item.route != null) {
          Navigator.of(context).pushNamed(item.route!);
        }
      },
      header: Container(
        height: 50,
        width: double.infinity,
        color: AppColors.colorBlack,
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Center(
            child: Text('MENU', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, letterSpacing: 2),)
        ),
      ),
      footer: Container(
        height: 80,
        width: double.infinity,
        color: AppColors.colorLightGreen,
        child: Center(
          child: Image.asset('assets/images/artklub_logo.png', height: 70, width: 70,),
        ),
      ),
    );
    // if(userType == 'a'){
    //   return SideBar(
    //     backgroundColor: AppColors.colorLightGreen,
    //     activeBackgroundColor: Colors.grey.shade900,
    //     borderColor: Colors.grey,
    //     textStyle: GoogleFonts.poppins(
    //       fontWeight: FontWeight.w600,
    //       color: Colors.grey.shade700,
    //       fontSize: 16,
    //     ),
    //     activeTextStyle: GoogleFonts.poppins(
    //       fontWeight: FontWeight.bold,
    //       color: Colors.white,
    //       fontSize: 18,
    //     ),
    //     items: const [
    //       MenuItem(
    //         title: 'Dashboard',
    //         route: DashboardPage.id,
    //         icon: Icons.dashboard,
    //       ),
    //       MenuItem(
    //         title: 'Zones',
    //         route: ZonesPage.id,
    //         icon: Icons.location_pin,
    //       ),
    //       MenuItem(
    //         title: 'Coordinators',
    //         route: CoordinatorsPage.id,
    //         icon: Icons.person,
    //       ),
    //       MenuItem(
    //         title: 'Join Requests',
    //         route: JoinRequestsPage.id,
    //         icon: Icons.email,
    //       ),
    //       MenuItem(
    //         title: 'Teachers',
    //         route: TeachersPage.id,
    //         icon: Icons.account_box_outlined,
    //       ),
    //       MenuItem(
    //         title: 'Batches',
    //         route: BatchesPage.id,
    //         icon: Icons.timer,
    //       ),
    //       MenuItem(
    //         title: 'Students',
    //         route: StudentsPage.id,
    //         icon: Icons.group,
    //       ),
    //       MenuItem(
    //         title: 'Assignments',
    //         route: AssignmentsPage.id,
    //         icon: Icons.article,
    //       ),
    //       MenuItem(
    //         title: 'Payments',
    //         route: PaymentsPage.id,
    //         icon: Icons.payment,
    //       ),
    //       MenuItem(
    //         title: 'Notifications',
    //         route: NotificationsPage.id,
    //         icon: Icons.notifications,
    //       ),
    //       MenuItem(
    //         title: 'Reports',
    //         route: ReportsPage.id,
    //         icon: Icons.article,
    //       ),
    //       MenuItem(
    //         title: 'Admin Users',
    //         route: AdminUsersPage.id,
    //         icon: Icons.accessibility,
    //       ),
    //       MenuItem(
    //         title: 'Logout',
    //         route: HomePage.id,
    //         icon: Icons.settings_power,
    //       ),
    //
    //     ],
    //     selectedRoute: selectedRoute,
    //     onSelected: (item) {
    //       if (item.route != null) {
    //         Navigator.of(context).pushNamed(item.route!);
    //       }
    //     },
    //     header: Container(
    //       height: 50,
    //       width: double.infinity,
    //       color: AppColors.colorBlack,
    //       padding: EdgeInsets.symmetric(vertical: 3),
    //       child: Center(
    //           child: Text('MENU', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, letterSpacing: 2),)
    //       ),
    //     ),
    //     footer: Container(
    //       height: 80,
    //       width: double.infinity,
    //       color: AppColors.colorLightGreen,
    //       child: Center(
    //         child: Image.asset('assets/images/artklub_logo.png', height: 70, width: 70,),
    //       ),
    //     ),
    //   );
    // }else if(userType == 'c'){
    //   return SideBar(
    //     backgroundColor: AppColors.colorLightGreen,
    //     activeBackgroundColor: Colors.grey.shade900,
    //     borderColor: Colors.grey,
    //     textStyle: GoogleFonts.poppins(
    //       fontWeight: FontWeight.w600,
    //       color: Colors.grey.shade700,
    //       fontSize: 16,
    //     ),
    //     activeTextStyle: GoogleFonts.poppins(
    //       fontWeight: FontWeight.bold,
    //       color: Colors.white,
    //       fontSize: 18,
    //     ),
    //     items: const [
    //       MenuItem(
    //         title: 'Dashboard',
    //         route: DashboardPage.id,
    //         icon: Icons.dashboard,
    //       ),
    //
    //       MenuItem(
    //         title: 'Join Requests',
    //         route: JoinRequestsPage.id,
    //         icon: Icons.email,
    //       ),
    //       MenuItem(
    //         title: 'Teachers',
    //         route: TeachersPage.id,
    //         icon: Icons.account_box_outlined,
    //       ),
    //       MenuItem(
    //         title: 'Batches',
    //         route: BatchesPage.id,
    //         icon: Icons.timer,
    //       ),
    //       MenuItem(
    //         title: 'Students',
    //         route: StudentsPage.id,
    //         icon: Icons.group,
    //       ),
    //       MenuItem(
    //         title: 'Assignments',
    //         route: AssignmentsPage.id,
    //         icon: Icons.article,
    //       ),
    //       MenuItem(
    //         title: 'Payments',
    //         route: PaymentsPage.id,
    //         icon: Icons.payment,
    //       ),
    //       MenuItem(
    //         title: 'Notifications',
    //         route: NotificationsPage.id,
    //         icon: Icons.notifications,
    //       ),
    //       MenuItem(
    //         title: 'Reports',
    //         route: ReportsPage.id,
    //         icon: Icons.article,
    //       ),
    //       MenuItem(
    //         title: 'Admin Users',
    //         route: AdminUsersPage.id,
    //         icon: Icons.accessibility,
    //       ),
    //       MenuItem(
    //         title: 'Logout',
    //         route: HomePage.id,
    //         icon: Icons.settings_power,
    //       ),
    //
    //     ],
    //     selectedRoute: selectedRoute,
    //     onSelected: (item) {
    //       if (item.route != null) {
    //         Navigator.of(context).pushNamed(item.route!);
    //       }
    //     },
    //     header: Container(
    //       height: 50,
    //       width: double.infinity,
    //       color: AppColors.colorBlack,
    //       padding: EdgeInsets.symmetric(vertical: 3),
    //       child: Center(
    //           child: Text('MENU', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, letterSpacing: 2),)
    //       ),
    //     ),
    //     footer: Container(
    //       height: 80,
    //       width: double.infinity,
    //       color: AppColors.colorLightGreen,
    //       child: Center(
    //         child: Image.asset('assets/images/artklub_logo.png', height: 70, width: 70,),
    //       ),
    //     ),
    //   );
    // }else if (userType == 't'){
    //   return SideBar(
    //     backgroundColor: AppColors.colorLightGreen,
    //     activeBackgroundColor: Colors.grey.shade900,
    //     borderColor: Colors.grey,
    //     textStyle: GoogleFonts.poppins(
    //       fontWeight: FontWeight.w600,
    //       color: Colors.grey.shade700,
    //       fontSize: 16,
    //     ),
    //     activeTextStyle: GoogleFonts.poppins(
    //       fontWeight: FontWeight.bold,
    //       color: Colors.white,
    //       fontSize: 18,
    //     ),
    //     items: const [
    //
    //       MenuItem(
    //         title: 'Batches',
    //         route: BatchesPage.id,
    //         icon: Icons.timer,
    //       ),
    //       MenuItem(
    //         title: 'Students',
    //         route: StudentsPage.id,
    //         icon: Icons.group,
    //       ),
    //       MenuItem(
    //         title: 'Assignments',
    //         route: AssignmentsPage.id,
    //         icon: Icons.article,
    //       ),
    //
    //       MenuItem(
    //         title: 'Notifications',
    //         route: NotificationsPage.id,
    //         icon: Icons.notifications,
    //       ),
    //
    //       MenuItem(
    //         title: 'Logout',
    //         route: HomePage.id,
    //         icon: Icons.settings_power,
    //       ),
    //
    //     ],
    //     selectedRoute: selectedRoute,
    //     onSelected: (item) {
    //       if (item.route != null) {
    //         Navigator.of(context).pushNamed(item.route!);
    //       }
    //     },
    //     header: Container(
    //       height: 50,
    //       width: double.infinity,
    //       color: AppColors.colorBlack,
    //       padding: EdgeInsets.symmetric(vertical: 3),
    //       child: Center(
    //           child: Text('MENU', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green, letterSpacing: 2),)
    //       ),
    //     ),
    //     footer: Container(
    //       height: 80,
    //       width: double.infinity,
    //       color: AppColors.colorLightGreen,
    //       child: Center(
    //         child: Image.asset('assets/images/artklub_logo.png', height: 70, width: 70,),
    //       ),
    //     ),
    //   );
    // }

  }
}