class CheckInModel {
  String? id;
  String? mId;
  String? workdate;
  String? workdateout;
  String? workin;
  String? workout;
  String? latitudeIn;
  String? longitudeIn;
  String? latitudeOut;
  String? longitudeOut;

  CheckInModel(
      {this.id,
      this.mId,
      this.workdate,
      this.workdateout,
      this.workin,
      this.workout,
      this.latitudeIn,
      this.longitudeIn,
      this.latitudeOut,
      this.longitudeOut});

  CheckInModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mId = json['m_id'];
    workdate = json['workdate'];
    workdateout = json['workdateout'];
    workin = json['workin'];
    workout = json['workout'];
    latitudeIn = json['latitude_in'];
    longitudeIn = json['longitude_in'];
    latitudeOut = json['latitude_out'];
    longitudeOut = json['longitude_out'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['m_id'] = this.mId;
    data['workdate'] = this.workdate;
    data['workdateout'] = this.workdateout;
    data['workin'] = this.workin;
    data['workout'] = this.workout;
    data['latitude_in'] = this.latitudeIn;
    data['longitude_in'] = this.longitudeIn;
    data['latitude_out'] = this.latitudeOut;
    data['longitude_out'] = this.longitudeOut;
    return data;
  }
}
