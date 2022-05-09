import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mana_app/model/check_in_model.dart';
import 'package:mana_app/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/usermodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? userModel;
  String? userid, fullname;

  @override
  void initState() {
    super.initState();
    readData();
  }

  Future<void> readData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userid = preferences.getString("userid");
    fullname = preferences.getString("fullname");
    setState(() {});
    print("$userid");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9EBF4),
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: Color(0xff263A96),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Card(
              child: Container(
                margin: EdgeInsets.all(20.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "ชื่อ-นามสกุล",
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8D8D8D)),
                    ),
                    Text(
                      "$fullname",
                      style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff191E2F)),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "รหัสพนักงาน",
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8D8D8D)),
                    ),
                    Text("$userid",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff191E2F))),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "ตำแหน่ง",
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8D8D8D)),
                    ),
                    Text("-",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff191E2F))),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "แผนก",
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8D8D8D)),
                    ),
                    Text("-",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff191E2F))),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "ฝ่าย",
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8D8D8D)),
                    ),
                    Text("-",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff191E2F))),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "บริษัท",
                      style: TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff8D8D8D)),
                    ),
                    Text("-",
                        style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff191E2F)))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
