class UserModel {
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? password;
  String? uid;
  String? profilePhoto;
  List? following;
  List? followers;
  List? recordings;

  UserModel({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.phone,
    required this.uid,
    required this.profilePhoto,
    required this.followers,
    required this.following,
    required this.recordings,
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
        "recordings": recordings,
      };
}
