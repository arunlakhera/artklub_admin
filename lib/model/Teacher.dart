import 'package:cloud_firestore/cloud_firestore.dart';

class Teacher{

  String name;
  String gender;
  String emailId;
  String phoneNumber;
  String address;
  String city;

  String state;
  String country;
  String zipcode;

  String zone;
  String userImageUrl;
  bool active;
  String createdBy;
  String updatedBy;

  Teacher({
    required this.name,
    required this.gender,
    required this.emailId,
    required this.phoneNumber,
    required this.address,
    required this.city,

    required this.state,
    required this.country,
    required this.zipcode,

    required this.zone,
    required this.userImageUrl,
    required this.active,
    required this.createdBy,
    required this.updatedBy,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    name: json["name"],
    gender: json["gender"],
    emailId: json["emailId"],
    phoneNumber: json["phoneNumber"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],

    zipcode: json["zipcode"],
    zone: json["zone"],
    userImageUrl: json["userImageUrl"],
    active: json["active"],

    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "gender": gender,
    "emailId": emailId,
    "phoneNumber": phoneNumber,

    "address": address,
    "city": city,

    "state": state,
    "country": country,
    "zipcode": zipcode,

    "zone": zone,
    "userImageUrl": userImageUrl,
    "active": active,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
  };

}