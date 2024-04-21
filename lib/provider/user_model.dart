class UserModel {
  String? uid;
  String? displayName;
  String? email;
  String? isSignedIn;

  UserModel({
    this.uid,
    this.displayName,
    this.email,
  });

  //receiving data from server
  factory UserModel.formMap(map) {
    return UserModel(
      uid: map['uid'],
      displayName: map['displayName'],
      email: map['email'],
    );
  }

  // sending data to server

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'displayName': displayName,
      'email': email,
    };
  }
}
