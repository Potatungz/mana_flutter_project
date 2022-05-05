class UserModel {
  String? userid;
  String? fullname;
  String? username;

  UserModel({this.userid, this.fullname, this.username});

  UserModel.fromJson(Map<String, dynamic> json) {
    userid = json['userid'];
    fullname = json['fullname'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userid'] = this.userid;
    data['fullname'] = this.fullname;
    data['username'] = this.username;
    return data;
  }
}
