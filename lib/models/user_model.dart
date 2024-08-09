class UserModel {
  final int? userId;
  final String userName;
  final String lastName;
  final String firstName;
  final String phoneContact;
  final String password;
  final String userType;

  UserModel({
    this.userId,
    required this.userName,
    this.lastName = "",
    this.firstName = "",
    this.phoneContact = "",
    required this.password,
    this.userType = "SITE",
  });

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        userId: json["user_id"],
        userName: json["username"],
        lastName: json["lastname"],
        firstName: json["firstname"],
        phoneContact: json["phonecontact"],
        password: json["password"],
        userType: json["usertype"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "username": userName,
        "lastname": lastName,
        "firstname": firstName,
        "phonecontact": phoneContact,
        "password": password,
        "usertype": userType,
      };
}
