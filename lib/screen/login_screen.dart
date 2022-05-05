import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mana_app/screen/home_screen.dart';
import 'package:mana_app/utility/dialog.dart';
import 'package:mana_app/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/usermodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool statusRedEye = true;
  String? username;
  String? password;

  @override
  void initState() {
    super.initState();
    checkPreference();
  }

  Future<Null> checkPreference() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? username = preferences.getString("username");
      if (username != null && username.isNotEmpty) {
        if (username == "$username") {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (context) => HomeScreen(),
          );
          Navigator.pushAndRemoveUntil(context, route, (route) => false);
        } else {
          normalDialog(context, "Error Username");
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Image.asset("asset/logocheckin.png"),
                      ),
                      SizedBox(),
                      Text(
                        "MANA",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
            Form(
              key: formKey,
              child: Container(
                padding: EdgeInsets.only(left: 30.0, right: 30.0),
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "USERNAME",
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff191E2F)),
                        )
                      ],
                    ),
                    TextFormField(
                      onChanged: (value) => username = value.trim(),
                      controller: usernameController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Insert Username';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Enter username",
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffCFD9E0))),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xff263A96))),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "PASSWORD",
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff191E2F)),
                        )
                      ],
                    ),
                    TextFormField(
                      onChanged: (value) => password = value.trim(),
                      controller: passwordController,
                      keyboardType: TextInputType.emailAddress,
                      obscureText: statusRedEye,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Insert Password';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Enter password",
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffCFD9E0))),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff263A96))),
                          suffixIcon: IconButton(
                            icon: statusRedEye
                                ? Icon(
                                    Icons.remove_red_eye,
                                    color: Color(0xffD0D0D0),
                                  )
                                : Icon(Icons.remove_red_eye_outlined,
                                    color: Color(0xffD0D0D0)),
                            onPressed: () {
                              setState(() {
                                statusRedEye = !statusRedEye;
                              });
                            },
                          )),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50.0,
                      child: TextButton(
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            primary: Colors.white,
                            backgroundColor: Color(0xff263A96)),
                        onPressed: () {
                          if ((username?.isEmpty ?? true) ||
                              (password?.isEmpty ?? true)) {
                            print("Username :$username Password: $password");
                            print("plese Insert Data");
                            normalDialog(
                                context, "กรุณาใส่ชื่อผู้ใช้งาน และรหัสผ่าน");
                          } else {
                            print("login success");

                            checkAuthen();
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Future<Null> checkAuthen() async {
    print("Check Authen");
    print("Username :$username Password: $password");
    // String url =
    //     "${MyConstant().domain}/checkin/getUserWhereUser.php?isAdd=true&username=$username";

    String url =
        "${MyConstant().domain}/checkin/getUserWhereUserAd.php?username=$username&password=$password";
    try {
      Response response = await Dio().get(url);
      print("res = $response");

      var result = json.decode(response.data);
      print("result = $result");
      if (result.isEmpty) {
        normalDialog(context,
            "ชื่อผู้ใช้ หรือรหัสผ่านของคุณไม่ถูกต้อง!! กรุณาลองอีกครั้ง");
      } else {
        for (var map in result) {
          UserModel userModel = UserModel.fromJson(map);
          routeToService(const HomeScreen(), userModel);
        }
      }
    } catch (e) {}
  }

  Future<Null> routeToService(Widget myWidget, UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("userid", userModel.userid!);
    await preferences.setString("fullname", userModel.fullname!);
    await preferences.setString("username", userModel.username!);

    MaterialPageRoute route = MaterialPageRoute(builder: (context) => myWidget);
    Navigator.pushAndRemoveUntil(context, route, (route) => false);
  }
}
