class ScreenArguments {
  // static String emailId ='';
  // static String type='';
  // static String zone='';
  // static bool active= false;
  //
  // static setArguments(String emailId, String type, String zone, bool active){
  //   emailId = emailId;
  //   type = type;
  //   zone = zone;
  //   active = active;
  // }
  //
  // static getEmailId() => emailId ;
  // static getType() => type;
  // static getZone() => zone;
  // static getActive() => active;

  static var userEmailId = '';
  static var userType ='';
  static var userZone = '';
  static var userActive = false;

  static printUser() {
    print(userEmailId);
    print(userType);
    print(userZone);
    print(userActive);
  }

  static updateUser(String emailId, String type, String zone, bool active) {
    userEmailId = emailId;
    userType = type;
    userZone = zone;
    userActive = active;
    printUser(); // this can be replaced with any static method
  }

}