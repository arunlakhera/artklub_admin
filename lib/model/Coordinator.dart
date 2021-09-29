class Coordinator{

  String name;
  String emailId;
  String phoneNumber;
  String address;
  String city;
  String state;
  String country;
  String userImageUrl;
  bool active;

  Coordinator({
    required this.name,
    required this.emailId,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.userImageUrl,
    required this.active,
  });


  // factory Coordinator.fromJson(Map<String, dynamic> json) => Coordinator(
  //   name: json["name"],
  //   emailId: json["emailId"],
  //   phoneNumber: json["phoneNumber"],
  //   address: json["address"],
  //   city: json["city"],
  //   state: json["state"],
  //   country: json["country"],
  //   userImageUrl: json["userImageUrl"],
  //   active: json["active"],
  // );

  Map<String, dynamic> toJson() => {
    "name": name,
    "emailId": emailId,
    "phoneNumber": phoneNumber,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "userImageUrl": userImageUrl,
    "active": active,
  };

}