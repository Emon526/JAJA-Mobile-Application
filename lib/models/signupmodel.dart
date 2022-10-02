import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpModel {
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? password;
  String? uid;
  String? profilePhoto;

  SignUpModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.phone,
    required this.uid,
    this.profilePhoto = "iiyvhj",
  });
  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "password": password,
        "uid": uid,
        "profilePhoto": profilePhoto,
      };

  static SignUpModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return SignUpModel(
      firstname: snapshot['firstname'],
      uid: snapshot['uid'],
      lastname: snapshot['lastname'],
      email: snapshot['email'],
      password: snapshot['password'],
      phone: snapshot['phone'],
      profilePhoto: snapshot['profilePhoto'],
    );
  }
}
