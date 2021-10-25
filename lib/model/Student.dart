import 'package:cloud_firestore/cloud_firestore.dart';

class Student{

  bool active;
  String parent1EmailId;
  String parent1Name;
  String parent1PhoneNumber;
  String parent2EmailId;
  String parent2Name;
  String parent2PhoneNumber;

  String studentDOB;
  String studentGender;
  String studentId;
  String studentName;
  String studentPhotoURL;
  Timestamp timestamp;
  String zone;

  Student({
    required this.active,

    required this.parent1EmailId,
    required this.parent1Name,
    required this.parent1PhoneNumber,
    required this.parent2EmailId,
    required this.parent2Name,
    required this.parent2PhoneNumber,

    required this.studentDOB,
    required this.studentGender,
    required this.studentId,
    required this.studentName,
    required this.studentPhotoURL,
    required this.timestamp,
    required this.zone,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    active: json["active"],
    parent1EmailId: json["parent1EmailId"],
    parent1Name: json["parent1Name"],
    parent1PhoneNumber: json["parent1PhoneNumber"],

    parent2EmailId: json["parent2EmailId"],
    parent2Name: json["parent2Name"],
    parent2PhoneNumber: json["parent2PhoneNumber"],

    studentDOB: json["studentDOB"],
    studentGender: json["studentGender"],
    studentId: json["studentId"],
    studentName: json["studentName"],
    studentPhotoURL: json["studentPhotoURL"],

    timestamp: json["timestamp"],
    zone: json["zone"],
  );

  Map<String, dynamic> toJson() => {
    "active": active,
    "parent1EmailId": parent1EmailId,
    "parent1Name": parent1Name,
    "parent1PhoneNumber": parent1PhoneNumber,

    "parent2EmailId": parent2EmailId,
    "parent2Name": parent2Name,
    "parent2PhoneNumber": parent2PhoneNumber,

    "studentDOB": studentDOB,
    "studentGender": studentGender,
    "studentId": studentId,
    "studentName": studentName,
    "studentPhotoURL": studentPhotoURL,

    "timestamp": timestamp,
    "zone": zone,
  };

}