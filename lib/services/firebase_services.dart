import 'package:artklub_admin/utilities/AppWidgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference zones = FirebaseFirestore.instance.collection('zones');
  CollectionReference admin = FirebaseFirestore.instance.collection('admin');

  CollectionReference courses = FirebaseFirestore.instance.collection('courses');

  CollectionReference joinRequest =
  FirebaseFirestore.instance.collection('joinrequest');
  CollectionReference coordinator =
      FirebaseFirestore.instance.collection('coordinator');
  CollectionReference _zoneCoordinator =
      FirebaseFirestore.instance.collection('zonecoordinator');
  CollectionReference teacher =
      FirebaseFirestore.instance.collection('teacher');
  CollectionReference batches =
      FirebaseFirestore.instance.collection('batches');
  CollectionReference student =
      FirebaseFirestore.instance.collection('students');
  CollectionReference primaryteacher =
      FirebaseFirestore.instance.collection('primaryteacher');
  CollectionReference backupteacher =
      FirebaseFirestore.instance.collection('backupteacher');
  CollectionReference batchstudents =
      FirebaseFirestore.instance.collection('batchstudents');
  CollectionReference assignments =
  FirebaseFirestore.instance.collection('assignments');
  CollectionReference assignmentsresponse =
  FirebaseFirestore.instance.collection('assignmentsresponse');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  // SAVE DB SECTION
  Future<void> createAdminUser(emailId, password, type) async {
    await admin.doc(emailId).set({
      'emailId': emailId,
      'password': password,
      'type': type,
      'active': true,
      'createdOn': DateTime.now(),
    });
  }

  Future<void> createCoordinator(emailId, password) async {
    await coordinator.doc(emailId).set({
      'name': '',
      'emailId': emailId,
      'phoneNumber': '',
      'address': '',
      'city': '',
      'state': '',
      'zipcode': '',
      'country': '',
      'gender': '',
      'dateOfBirth': '',
      'userImageUrl': '',
      'zone': '',
      'createdOn': DateTime.now(),
      'createdBy': '',
      'updatedOn': DateTime.now(),
      'updatedBy': '',
      'active': true,
    });
  }

  Future<void> createZoneCoordinator(emailId, password) async {
    await _zoneCoordinator.doc(emailId).set({
      'name': '',
      'emailId': emailId,
      'phoneNumber': '',
      'address': '',
      'city': '',
      'state': '',
      'zipcode': '',
      'country': '',
      'gender': '',
      'dateOfBirth': '',
      'userImageUrl': '',
      'zone': '',
      'createdOn': DateTime.now(),
      'createdBy': '',
      'updatedOn': DateTime.now(),
      'updatedBy': '',
      'active': true,
    });
  }

  Future<void> createTeacher(emailId, password) async {
    await teacher.doc(emailId).set({
      'name': '',
      'emailId': emailId,
      'phoneNumber': '',
      'address': '',
      'city': '',
      'state': '',
      'zipcode': '',
      'country': '',
      'gender': '',
      'dateOfBirth': '',
      'userImageUrl': '',
      'bio': '',
      'zone': '',
      'coordinator': '',
      'createdOn': DateTime.now(),
      'createdBy': '',
      'updatedOn': DateTime.now(),
      'updatedBy': '',
      'active': true,
    });
  }

  Future<String> createZone(zoneName, country, state, city) async {
    var zoneRef = zones.doc(zoneName);
    String result = 'zone_error';

    await zoneRef
        .get()
        .then((doc) async => {
              if (doc.exists)
                {result = 'zone_exists'}
              else
                {result = 'zone_created'}
            })
        .catchError((error) {
      result = 'zone_error';
    });

    if (result == 'zone_created') {
      await zones
          .doc(zoneName)
          .set({
            'zoneName': zoneName,
            'country': country,
            'state': state,
            'city': city,
            'createdOn': DateTime.now(),
            'createdBy': '',
            'updatedOn': DateTime.now(),
            'updatedBy': '',
            'active': true,
          })
          .then((value) => {result = 'zone_created'})
          .catchError((error) => {result = 'zone_error'});
    }

    return result;
  }

  // UPDATE DB SECTION
  Future<void> updateAdminUserStatus(emailId, activeStatus) async {
    await admin
        .doc(emailId)
        .update({'active': activeStatus})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  Future<void> updateZoneStatus(zoneName, activeStatus) async {
    await zones
        .doc(zoneName)
        .update({'active': activeStatus})
        .then((value) => print("Zone Updated"))
        .catchError((error) => print("Failed to update zone: $error"));
  }

  Future<void> updateCoordinatorStatus(emailId, activeStatus) async {
    await coordinator
        .doc(emailId)
        .update({'active': activeStatus})
        .then((value) => print("Coordinator Status Updated"))
        .catchError((error) => print("Failed to update Coordinator: $error"));
  }

  Future<void> updateTeacherStatus(emailId, activeStatus) async {
    await teacher
        .doc(emailId)
        .update({'active': activeStatus})
        .then((value) => print("Teacher Status Updated"))
        .catchError((error) => print("Failed to update teacher: $error"));
  }

  Future<void> updateStudentStatus(id, activeStatus) async {
    return await student
        .doc(id)
        .update({'active': activeStatus})
        .then((value) => print("Student Status Updated"))
        .catchError((error) => print("Failed to update Student: $error"));
  }

  Future<void> updateCourseStatus(id, courseName,activeStatus) async {
    return await courses
        .doc(id)
        .update({'active': activeStatus})
        .then((value) => print("Student Status Updated"))
        .catchError((error) => print("Failed to update Student: $error"));
  }

  Future<void> updateBatchStatus(batchName, activeStatus) async {
    await batches
        .doc(batchName)
        .update({'active': activeStatus})
        .then((value) => print("Batch Status Updated"))
        .catchError((error) => print("Failed to update Batch: $error"));
  }

  Future<bool> updateBatchStudentStatus(
      batchId, studentId, activeStatus) async {

    bool status = false;

    var parentId;
    var updateResult = await batchstudents
        .where('batchId', isEqualTo: batchId)
        .where('studentId', isEqualTo: studentId)
        .limit(1)
        .get();

    updateResult.docs.forEach((element) {
      parentId = element.id;
    });

    await batchstudents.doc(parentId)
        .update({'active': activeStatus})
        .then((value){
      status = true;
      print("Batch Student Status Updated");
    })
        .catchError((error){
      status = false;
          print("Failed to update Student Batch Status: $error");
    });

    return status;
  }

  // FETCH DB SECTION
  Future<DocumentSnapshot> getAdminCredentials(id) {
    var result = admin.doc(id).get();
    return result;
  }

  Future<DocumentSnapshot> getCoordinator(id) {
    var result = coordinator.doc(id).get();
    return result;
  }

  Future<DocumentSnapshot> getTeacher(id) {
    var result = teacher.doc(id).get();
    return result;
  }

  Future<DocumentSnapshot> getStudent(id) async{
    var result = await student.doc(id).get();
    return result;
  }

  // Upload image to storage
  Future<String?> uploadImageToStorage({imageName, imagePath, zone}) async {
    String? userImageUrl;
    // dismiss loading message about image being saved

    String fileType = (imageName!.mime).replaceAll('image/', '.');

    final path = '$imagePath$zone$fileType';

    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child(path)
        .putData(imageName!.fileData)
        .whenComplete(() async {
      userImageUrl = await firebase_storage.FirebaseStorage.instance
          .ref(path)
          .getDownloadURL()
          .whenComplete(() {});
      print(userImageUrl);
    });

    return userImageUrl != null ? userImageUrl : 'NA';
  }

  Future<void> sendPasswordResetLink(context, emailId) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.sendPasswordResetEmail(email: emailId).whenComplete(() {
      AppWidgets().showAlertSuccessWithButton(
          context: context,
          successMessage: 'Password reset link has been sent to $emailId');
    }).onError((error, stackTrace) {
      AppWidgets().showAlertErrorWithButton(
          context: context,
          errMessage: 'Could not send Password Reset Link. Please try again.');
    });
  }

  // Remove Student from Batch
  Future<void> removeStudentFromBatch({id}) async{

   return await batchstudents
       .doc(id)
       .delete()
       .then((value) => print('Success'))
       .onError((error, stackTrace)=> print("Error Occurred"));

  }

  Future<void> logout(context) async {
    await FirebaseAuth.instance.signOut();
  }
}
