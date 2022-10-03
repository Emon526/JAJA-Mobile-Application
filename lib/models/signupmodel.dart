import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpModel {
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? password;
  String? uid;
  String? profilePhoto;
  List<String>? following;
  List<String>? followers;

  SignUpModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.phone,
    required this.uid,
    required this.profilePhoto,
    required this.followers,
    required this.following,
  });
  Map<String, dynamic> toJson() => {
        "firstname": firstname,
        "lastname": lastname,
        "email": email,
        "phone": phone,
        "password": password,
        "uid": uid,
        "profilePhoto": profilePhoto,
        "followers": followers,
        "following": following,
      };

  // static SignUpModel fromSnap(DocumentSnapshot snap) {
  //   var snapshot = snap.data() as Map<String, dynamic>;
  //   return SignUpModel(
  //     firstname: snapshot['firstname'],
  //     uid: snapshot['uid'],
  //     lastname: snapshot['lastname'],
  //     email: snapshot['email'],
  //     password: snapshot['password'],
  //     phone: snapshot['phone'],
  //     profilePhoto: snapshot['profilePhoto'],
  //   );
  // }
}
