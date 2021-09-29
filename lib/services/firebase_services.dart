import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices{

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference zones = FirebaseFirestore.instance.collection('zones');
  CollectionReference admin = FirebaseFirestore.instance.collection('admin');
  CollectionReference coordinator = FirebaseFirestore.instance.collection('coordinator');
  CollectionReference _zoneCoordinator = FirebaseFirestore.instance.collection('zonecoordinator');
  CollectionReference _teacher = FirebaseFirestore.instance.collection('teacher');
  CollectionReference _student = FirebaseFirestore.instance.collection('student');
  CollectionReference _batches = FirebaseFirestore.instance.collection('batches');


  // SAVE DB SECTION
  Future<void> createAdminUser(emailId, password, type) async{

    await admin.doc(emailId).set({
      'emailId': emailId,
      'password': password,
      'type': type,
      'active': true,
      'createdOn': DateTime.now(),
    });
  }

  Future<void> createCoordinator(emailId, password) async{

    await coordinator.doc(emailId).set(
        {
          'name': '',
          'emailId': emailId,
          'phoneNumber': '',
          'address': '',
          'city': '',
          'state': '',
          'zipcode':'',
          'country': '',
          'gender':'',
          'dateOfBirth':'',
          'userImageUrl': '',
          'zone':'',
          'createdOn':DateTime.now(),
          'createdBy':'',
          'updatedOn':DateTime.now(),
          'updatedBy':'',
          'active': true,
        }
    );
  }

  Future<void> createZoneCoordinator(emailId, password) async{

    await _zoneCoordinator.doc(emailId).set(
        {
          'name': '',
          'emailId': emailId,
          'phoneNumber': '',
          'address': '',
          'city': '',
          'state': '',
          'zipcode':'',
          'country': '',
          'gender':'',
          'dateOfBirth':'',
          'userImageUrl': '',
          'zone':'',
          'createdOn':DateTime.now(),
          'createdBy':'',
          'updatedOn':DateTime.now(),
          'updatedBy':'',
          'active': true,
        }
    );
  }

  Future<void> createTeacher(emailId, password) async{

    await _teacher.doc(emailId).set(
        {
          'name': '',
          'emailId': emailId,
          'phoneNumber': '',
          'address': '',
          'city': '',
          'state': '',
          'zipcode':'',
          'country': '',
          'gender':'',
          'dateOfBirth':'',
          'userImageUrl': '',
          'bio':'',
          'zone':'',
          'coordinator':'',
          'createdOn':DateTime.now(),
          'createdBy':'',
          'updatedOn':DateTime.now(),
          'updatedBy':'',
          'active': true,
        }
    );
  }

  Future<String> createZone(zoneName, country, state, city) async{

    var zoneRef = zones.doc(zoneName);
    String result = 'zone_error';

    await zoneRef.get().then((doc) async => {
      if(doc.exists){
        result = 'zone_exists'
      }else{
        result = 'zone_created'
      }
    }).catchError((error){
      result = 'zone_error';
    });

    if(result == 'zone_created'){
      await zones.doc(zoneName).set(
          {
            'zoneName': zoneName,
            'country': country,
            'state': state,
            'city': city,
            'createdOn':DateTime.now(),
            'createdBy':'',
            'updatedOn':DateTime.now(),
            'updatedBy':'',
            'active': true,
          })
          .then((value) => {result = 'zone_created'})
          .catchError((error) => {result = 'zone_error'});
    }

    return result;

  }

  // UPDATE DB SECTION
  Future<void> updateAdminUserStatus(emailId, activeStatus) async{

   await admin.doc(emailId)
        .update({'active': activeStatus})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

  }

  Future<void> updateZoneStatus(zoneName, activeStatus) async{

    await zones.doc(zoneName)
        .update({'active': activeStatus})
        .then((value) => print("Zone Updated"))
        .catchError((error) => print("Failed to update zone: $error"));

  }

  Future<void> updateCoordinatorStatus(emailId, activeStatus) async{

    await coordinator.doc(emailId)
        .update({'active': activeStatus})
        .then((value) => print("Zone Updated"))
        .catchError((error) => print("Failed to update zone: $error"));

  }


  // FETCH DB SECTION
  Future<DocumentSnapshot> getAdminCredentials(id){
    var result = admin.doc(id).get();
    return result;
  }



  Future<void> logout(context) async {
    await FirebaseAuth.instance.signOut();
  }

}