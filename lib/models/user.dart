// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserModel {
//   String? profilePhoto;
//   String email;
//   String uid;
//   String firstname;
//   String lastname;
//   String phone;
//   String password;

//   UserModel({
//     required this.firstname,
//     required this.lastname,
//     required this.email,
//     required this.uid,
//     this.profilePhoto = '',
//     required this.password,
//     required this.phone,
//   });

//   Map<String, dynamic> toJson() => {
//         "firstname": firstname,
//         "lastname": lastname,
//         "email": email,
//         "uid": uid,
//         "profilePhoto": profilePhoto,
//         "password": password,
//         "phone": phone,
//       };

//   static UserModel fromSnap(DocumentSnapshot snap) {
//     var snapshot = snap.data() as Map<String, dynamic>;
//     return UserModel(
//       lastname: snapshot['lastname'],
//       firstname: snapshot['firstname'],
//       password: snapshot['password'],
//       phone: snapshot['phone'],
//       email: snapshot['email'],
//       uid: snapshot['uid'],
//       profilePhoto: snapshot['profilePhoto'],
//     );
//   }
// }


//               //   // ignore: unnecessary_cast
//               //   // itemCount: sn.docs.length,
//               //   //QuerySnapshot Contains the results of a query. It can contain zero or more objects
//               //   itemBuilder: (context, index) {
//               // UserModel userData = UserModel.fromSnap((snapshot.data!)[index]);
//               // // final userData = snapshot.data;
//               // // DocumentSnapshot task =
//               // //     (snapshot.data! as QuerySnapshot).docs[index];