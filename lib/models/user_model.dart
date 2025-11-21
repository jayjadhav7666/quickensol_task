class UserModel {
  String? id;
  String name;
  String email;
  String phoneNumber;
  String password;


  UserModel({this.id, required this.name, required this.email, required this.phoneNumber, required this.password});


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phoneNumber: json['phoneNumber'],
    password: json['password'],
  );


  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "phoneNumber": phoneNumber,
    "password": password,
  };
}