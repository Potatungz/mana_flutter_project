import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mana_app/main.dart';
import 'package:mana_app/model/check_in_model.dart';
import 'package:mana_app/model/usermodel.dart';
import 'package:mana_app/screen/aboutus_screen.dart';
import 'package:mana_app/screen/checkin_screen.dart';
import 'package:mana_app/screen/checkout_screen.dart';
import 'package:mana_app/screen/login_screen.dart';
import 'package:mana_app/screen/profile_screen.dart';
import 'package:mana_app/utility/my_constant.dart';
import 'package:mana_app/utility/my_style.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? userModel;
  CheckInModel? checkInModel;

  String? fullname, userid;
  List<CheckInModel> checkinModels = [];
  List<CheckInModel> lastWeekModels = [];
  List<CheckInModel> thisMonthModels = [];

  bool loadData = true;

  @override
  void initState() {
    super.initState();
    readCurrentData();
    readDataLastWeek();
    readDataThisMonth();

    // processReadSQLite();
  }

  Future<void> readDataLastWeek() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userid = preferences.getString("userid");

    String url =
        "${MyConstant().domain}/checkin/getDataLastWeek.php?isAdd=true&id_pers=$userid";
    print("url = $url");

    await Dio().get(url).then(
      (value) {
        var result = json.decode(value.data);
        for (var map in result) {
          CheckInModel model = CheckInModel.fromJson(map);
          String? modelCheckin = model.workdate;

          if (modelCheckin!.isNotEmpty) {
            setState(() {
              lastWeekModels.add(model);
            });
          }
        }
      },
    );
  }

  Future<void> readDataThisMonth() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userid = preferences.getString("userid");

    String url =
        "${MyConstant().domain}/checkin/getDataThisMonth.php?isAdd=true&id_pers=$userid";
    print("url = $url");

    await Dio().get(url).then(
      (value) {
        var result = json.decode(value.data);
        for (var map in result) {
          CheckInModel model = CheckInModel.fromJson(map);
          String? modelCheckin = model.workdate;

          if (modelCheckin!.isNotEmpty) {
            setState(() {
              thisMonthModels.add(model);
            });
          }
        }
      },
    );
  }

  Future<void> readCurrentData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userid = preferences.getString("userid");
    fullname = preferences.getString("fullname");
    print("userid : $userid");

    String url =
        "${MyConstant().domain}/checkin/getDataThisWeek.php?isAdd=true&id_pers=$userid";
    print("url = $url");

    await Dio().get(url).then(
      (value) {
        var result = json.decode(value.data);
        for (var map in result) {
          CheckInModel model = CheckInModel.fromJson(map);
          String? modelCheckin = model.workdate;

          if (modelCheckin!.isNotEmpty) {
            setState(() {
              checkinModels.add(model);
            });
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Check-in & Check-out"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
                },
                icon: Icon(Icons.person_outline_rounded))
          ],
          backgroundColor: Color(0xff263A96),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 30.0),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xffE9EBF4),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: Color(0xff263A96),
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff354373).withOpacity(0.6),
                                blurRadius: 2,
                                offset:
                                    Offset(0, 2), // changes position of shadow
                              ),
                            ],
                          ),
                          labelColor: Colors.white,
                          labelStyle: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold),
                          unselectedLabelColor: Color(0xff263A96),
                          unselectedLabelStyle: TextStyle(
                              fontSize: 12.0, fontWeight: FontWeight.w500),
                          tabs: [
                            Tab(
                              text: "Last Week",
                            ),
                            Tab(
                              text: "This Week",
                            ),
                            Tab(
                              text: "Last Month",
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: TabBarView(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 100,
                            child: ListView.builder(
                              itemCount: lastWeekModels.length,
                              itemBuilder: ((context, index) => Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                              "${lastWeekModels[index].workdate}",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                              minFontSize: 10.0,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: lastWeekModels[index]
                                                          .workout ==
                                                      null
                                                  ? TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                CheckoutScreen(
                                                                    checkInModel:
                                                                        checkinModels[
                                                                            index])));
                                                      },
                                                      child: AutoSizeText(
                                                        "check out",
                                                        style: TextStyle(
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                        minFontSize: 8.0,
                                                      ),
                                                      style: TextButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                          primary: Colors.white,
                                                          backgroundColor:
                                                              Color(
                                                                  0xffFF9800)),
                                                    )
                                                  : TextButton(
                                                      onPressed: () {},
                                                      child: AutoSizeText(
                                                        "Complete",
                                                        style: TextStyle(
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                        minFontSize: 8.0,
                                                      ),
                                                      style: TextButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                          primary: Colors.white,
                                                          backgroundColor:
                                                              Color(
                                                                  0xff263A96)),
                                                    ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                              "check in on ${lastWeekModels[index].workin}",
                                              style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              minFontSize: 7.0,
                                            ),
                                            lastWeekModels[index].workout ==
                                                    null
                                                ? AutoSizeText(
                                                    "check out on ",
                                                    style: TextStyle(
                                                        fontSize: 9.0,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    minFontSize: 7.0,
                                                  )
                                                : AutoSizeText(
                                                    "check out on ${lastWeekModels[index].workout}",
                                                    style: TextStyle(
                                                        fontSize: 9.0,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    minFontSize: 7.0,
                                                  ),
                                          ],
                                        ),
                                        Divider()
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 100,
                            child: ListView.builder(
                              itemCount: checkinModels.length,
                              itemBuilder: ((context, index) => Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                              "${checkinModels[index].workdate}",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                              minFontSize: 10.0,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: checkinModels[index]
                                                          .workout ==
                                                      null
                                                  ? TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                CheckoutScreen(
                                                                    checkInModel:
                                                                        checkinModels[
                                                                            index])));
                                                      },
                                                      child: AutoSizeText(
                                                        "check out",
                                                        style: TextStyle(
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                        minFontSize: 8.0,
                                                      ),
                                                      style: TextButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                          primary: Colors.white,
                                                          backgroundColor:
                                                              Color(
                                                                  0xffFF9800)),
                                                    )
                                                  : TextButton(
                                                      onPressed: () {},
                                                      child: AutoSizeText(
                                                        "Complete",
                                                        style: TextStyle(
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                        minFontSize: 8.0,
                                                      ),
                                                      style: TextButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                          primary: Colors.white,
                                                          backgroundColor:
                                                              Color(
                                                                  0xff263A96)),
                                                    ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                              "check in on ${checkinModels[index].workin}",
                                              style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              minFontSize: 7.0,
                                            ),
                                            checkinModels[index].workout == null
                                                ? AutoSizeText(
                                                    "check out on ",
                                                    style: TextStyle(
                                                        fontSize: 9.0,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    minFontSize: 7.0,
                                                  )
                                                : AutoSizeText(
                                                    "check out on ${checkinModels[index].workout}",
                                                    style: TextStyle(
                                                        fontSize: 9.0,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    minFontSize: 7.0,
                                                  ),
                                          ],
                                        ),
                                        Divider()
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                          //-----------------  This Month --------------------//
                          Container(
                            width: double.infinity,
                            height: 100,
                            child: ListView.builder(
                              itemCount: thisMonthModels.length,
                              itemBuilder: ((context, index) => Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                              "${thisMonthModels[index].workdate}",
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                              minFontSize: 10.0,
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                              child: thisMonthModels[index]
                                                          .workout ==
                                                      null
                                                  ? TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) =>
                                                                CheckoutScreen(
                                                                    checkInModel:
                                                                        thisMonthModels[
                                                                            index])));
                                                      },
                                                      child: AutoSizeText(
                                                        "check out",
                                                        style: TextStyle(
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                        minFontSize: 8.0,
                                                      ),
                                                      style: TextButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                          primary: Colors.white,
                                                          backgroundColor:
                                                              Color(
                                                                  0xffFF9800)),
                                                    )
                                                  : TextButton(
                                                      onPressed: () {},
                                                      child: AutoSizeText(
                                                        "Complete",
                                                        style: TextStyle(
                                                            fontSize: 10.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                        minFontSize: 8.0,
                                                      ),
                                                      style: TextButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0)),
                                                          primary: Colors.white,
                                                          backgroundColor:
                                                              Color(
                                                                  0xff263A96)),
                                                    ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AutoSizeText(
                                              "check in on ${thisMonthModels[index].workin}",
                                              style: TextStyle(
                                                  fontSize: 9.0,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              minFontSize: 7.0,
                                            ),
                                            thisMonthModels[index].workout ==
                                                    null
                                                ? AutoSizeText(
                                                    "check out on ",
                                                    style: TextStyle(
                                                        fontSize: 9.0,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    minFontSize: 7.0,
                                                  )
                                                : AutoSizeText(
                                                    "check out on ${thisMonthModels[index].workout}",
                                                    style: TextStyle(
                                                        fontSize: 9.0,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    minFontSize: 7.0,
                                                  ),
                                          ],
                                        ),
                                        Divider()
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        drawer: const NavDrawer(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 30.0),
          child: Container(
            width: double.infinity,
            height: 50.0,
            child: TextButton(
              child: const Text(
                "บันทึกเวลาเข้างาน",
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
                print("Check in 1");
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CheckInScreen()));
              },
            ),
          ),
        ),
      ),
    );
  }
}

class NavDrawer extends StatefulWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  UserModel? userModel;
  String? fullname;

  @override
  void initState() {
    readCurrentInfo();
    super.initState();
  }

  Future<void> readCurrentInfo() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    fullname = preferences.getString("fullname");
    setState(() {});
  }

  Future<void> signOutProcess() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    //exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[buildHeader(context), buildMenuItems(context)],
      )),
    );
  }

  buildHeader(BuildContext context) {
    return Container(
      color: Color(0xff263A96),
      padding: EdgeInsets.only(
          left: 24.0, top: 24 + MediaQuery.of(context).padding.top, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$fullname",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ))
        ],
      ),
    );
  }

  buildMenuItems(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Wrap(
            runSpacing: 16.0,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.home_outlined,
                  color: Color(0xff263A96),
                ),
                title: const Text("Home"),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_outline_rounded,
                  color: Color(0xff263A96),
                ),
                title: const Text("Profile"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xff263A96),
                ),
                title: const Text("About us"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AboutUsScreen()));
                },
              ),
              Divider(),
              ListTile(
                leading: const Icon(
                  Icons.logout_outlined,
                  color: Color(0xff263A96),
                ),
                title: const Text("Logout"),
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool('showLogin', false);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                  signOutProcess();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}