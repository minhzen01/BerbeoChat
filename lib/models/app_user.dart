class AppUser {
  String? uid;
  String? displayName;
  String? email;
  String? photoUrl;

  AppUser({this.uid, this.displayName, this.email, this.photoUrl});

  AppUser.fromJson(Map<String, dynamic> json) {
    uid = json["uid"];
    displayName = json["display_name"];
    email = json["email"];
    photoUrl = json["photo_url"];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data["uid"] = uid;
    data["display_name"] = displayName;
    data["email"] = email;
    data["photo_url"] = photoUrl;
    return data;
  }
}
