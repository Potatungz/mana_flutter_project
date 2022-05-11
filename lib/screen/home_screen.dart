import 'dart:convert';
import 'dart:async';

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
  late Future<List<CheckInModel>> checkInModels = readDataThisWeek();
  late Future<List<CheckInModel>> lastWeekModels = readDataLastWeek();
  late Future<List<CheckInModel>> thisMonthModels = readDataThisMonth();

  bool loadData = true;

  @override
  void initState() {
    super.initState();
    // readCurrentData();
  }

  Future<List<CheckInModel>> readDataLastWeek() async {
    print("read data last week");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userid = preferences.getString("userid");

    String url =
        "${MyConstant().domain}/checkin/getDataLastWeek.php?isAdd=true&id_pers=$userid";

    await Dio().get(url).then(
      (value) {
        var result = json.decode(value.data);
        List<CheckInModel> lastWeekModels = [];
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
    return lastWeekModels;
  }

  // Future<void> readDataLastWeek() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   userid = preferences.getString("userid");

  //   String url =
  //       "${MyConstant().domain}/checkin/getDataLastWeek.php?isAdd=true&id_pers=$userid";
  //   print("url = $url");

  //   await Dio().get(url).then(
  //     (value) {
  //       var result = json.decode(value.data);
  //       for (var map in result) {
  //         CheckInModel model = CheckInModel.fromJson(map);
  //         String? modelCheckin = model.workdate;

  //         if (modelCheckin!.isNotEmpty) {
  //           setState(() {
  //             lastWeekModels.add(model);
  //           });
  //         }
  //       }
  //     },
  //   );
  // }

  Future<List<CheckInModel>> readDataThisMonth() async {
    print("read data this month");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userid = preferences.getString("userid");

    String url =
        "${MyConstant().domain}/checkin/getDataThisMonth.php?isAdd=true&id_pers=$userid";
    List<CheckInModel> thisMonthModels = [];
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

    return thisMonthModels;
  }

  Future<List<CheckInModel>> readDataThisWeek() async {
    print("read data this month");
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userid = preferences.getString("userid");
    fullname = preferences.getString("fullname");

    String url =
        "${MyConstant().domain}/checkin/getDataThisWeek.php?isAdd=true&id_pers=$userid";
    List<CheckInModel> checkInModels = [];
    await Dio().get(url).then(
      (value) {
        var result = json.decode(value.data);
        for (var map in result) {
          CheckInModel model = CheckInModel.fromJson(map);
          String? modelCheckin = model.workdate;

          if (modelCheckin!.isNotEmpty) {
            setState(() {
              checkInModels.add(model);
            });
          }
        }
      },
    );
    return checkInModels;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Check-in & Check-out",
              style:
                  TextStyle(fontFamily: 'DMSans', fontWeight: FontWeight.bold)),
          centerTitle: true,
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
                              fontFamily: 'DMSans',
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold),
                          unselectedLabelColor: Color(0xff263A96),
                          unselectedLabelStyle: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500),
                          tabs: [
                            Tab(
                              text: "Last Week",
                            ),
                            Tab(
                              text: "This Week",
                            ),
                            Tab(
                              text: "This Month",
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
                          //-------------- Last Week --------------//
                          Container(
                              width: double.infinity,
                              height: 100,
                              child: FutureBuilder<List<CheckInModel>>(
                                  future: lastWeekModels,
                                  builder: (BuildContext context,
                                      AsyncSnapshot snaplastweek) {
                                    if (snaplastweek.connectionState ==
                                        ConnectionState.waiting) {
                                      print("Loading...");
                                      return MyStyle().showProgress();
                                    } else if (snaplastweek.hasData) {
                                      final lastWeekModels = snaplastweek.data!;
                                      return buildLastWeek(lastWeekModels);
                                    } else {
                                      return Center(child: Text("ไม่พบข้อมูล"));
                                    }
                                  })),
                          //-------------- Last Week --------------//

                          //-------------- This Week --------------//
                          Container(
                            width: double.infinity,
                            height: 100,
                            child: FutureBuilder<List<CheckInModel>>(
                                future: checkInModels,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapthisweek) {
                                  if (snapthisweek.connectionState ==
                                      ConnectionState.waiting) {
                                    print("Loading...");

                                    return MyStyle().showProgress();
                                  } else if (snapthisweek.hasData) {
                                    print("Complete Data...");
                                    final checkInModels = snapthisweek.data!;
                                    return buildLastWeek(checkInModels);
                                  } else {
                                    print("None Data");
                                    return Center(child: Text("ไม่พบข้อมูล"));
                                  }
                                }),
                          ),
                          //-------------- This Week --------------//

                          //-------------- This Month --------------//
                          Container(
                            width: double.infinity,
                            height: 100,
                            child: FutureBuilder<List<CheckInModel>>(
                                future: thisMonthModels,
                                builder: (BuildContext context,
                                    AsyncSnapshot snapthismonth) {
                                  if (snapthismonth.connectionState ==
                                      ConnectionState.waiting) {
                                    return MyStyle().showProgress();
                                  } else if (snapthismonth.hasData) {
                                    print("Complete Data...");
                                    final thisMonthModels = snapthismonth.data!;
                                    return buildLastWeek(thisMonthModels);
                                  } else {
                                    print("None Data");
                                    return Center(child: Text("ไม่พบข้อมูล"));
                                  }
                                }),
                          )
                          //-------------- This Month --------------//
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
                  fontFamily: 'DMSans',
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CheckInScreen()));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildThisWeek(List<CheckInModel> checkInModels) {
    return ListView.builder(
      itemCount: checkInModels.length,
      itemBuilder: ((context, index) => Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      "${checkInModels[index].workdate}",
                      style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                      minFontSize: 10.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: checkInModels[index].workout == null
                          ? TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                        checkInModel: checkInModels[index])));
                              },
                              child: AutoSizeText(
                                "check out",
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.normal),
                                minFontSize: 8.0,
                              ),
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  primary: Colors.white,
                                  backgroundColor: Color(0xffFF9800)),
                            )
                          : TextButton(
                              onPressed: () {},
                              child: AutoSizeText(
                                "Complete",
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.normal),
                                minFontSize: 8.0,
                              ),
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  primary: Colors.white,
                                  backgroundColor: Color(0xff263A96)),
                            ),
                    )
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      "check in on ${checkInModels[index].workin}",
                      style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 9.0,
                          fontWeight: FontWeight.normal),
                      minFontSize: 7.0,
                    ),
                    checkInModels[index].workout == null
                        ? AutoSizeText(
                            "check out on ",
                            style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 9.0,
                                fontWeight: FontWeight.normal),
                            minFontSize: 7.0,
                          )
                        : AutoSizeText(
                            "check out on ${checkInModels[index].workout}",
                            style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 9.0,
                                fontWeight: FontWeight.normal),
                            minFontSize: 7.0,
                          ),
                  ],
                ),
                Divider()
              ],
            ),
          )),
    );
  }

  Widget buildLastWeek(List<CheckInModel> lastWeekModels) {
    return ListView.builder(
        itemCount: lastWeekModels.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      "${lastWeekModels[index].workdate}",
                      style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                      minFontSize: 10.0,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: lastWeekModels[index].workout == null
                          ? TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CheckoutScreen(
                                        checkInModel: lastWeekModels[index])));
                              },
                              child: AutoSizeText(
                                "check out",
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.normal),
                                minFontSize: 8.0,
                              ),
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  primary: Colors.white,
                                  backgroundColor: Color(0xffFF9800)),
                            )
                          : TextButton(
                              onPressed: () {},
                              child: AutoSizeText(
                                "Complete",
                                style: TextStyle(
                                    fontFamily: 'DMSans',
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.normal),
                                minFontSize: 8.0,
                              ),
                              style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  primary: Colors.white,
                                  backgroundColor: Color(0xff263A96)),
                            ),
                    )
                  ],
                ),
                SizedBox(
                  height: 12.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(
                      "check in on ${lastWeekModels[index].workin}",
                      style: TextStyle(
                          fontFamily: 'DMSans',
                          fontSize: 9.0,
                          fontWeight: FontWeight.normal),
                      minFontSize: 7.0,
                    ),
                    lastWeekModels[index].workout == null
                        ? AutoSizeText(
                            "check out on ",
                            style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 9.0,
                                fontWeight: FontWeight.normal),
                            minFontSize: 7.0,
                          )
                        : AutoSizeText(
                            "check out on ${lastWeekModels[index].workout}",
                            style: TextStyle(
                                fontFamily: 'DMSans',
                                fontSize: 9.0,
                                fontWeight: FontWeight.normal),
                            minFontSize: 7.0,
                          ),
                  ],
                ),
                Divider()
              ],
            ),
          );
        });
  }
}

Widget buildThisMonth(List<CheckInModel> thisMonthModels) {
  return ListView.builder(
    itemCount: thisMonthModels.length,
    itemBuilder: ((context, index) => Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    "${thisMonthModels[index].workdate}",
                    style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                    minFontSize: 10.0,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: thisMonthModels[index].workout == null
                        ? TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CheckoutScreen(
                                      checkInModel: thisMonthModels[index])));
                            },
                            child: AutoSizeText(
                              "check out",
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.normal),
                              minFontSize: 8.0,
                            ),
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                primary: Colors.white,
                                backgroundColor: Color(0xffFF9800)),
                          )
                        : TextButton(
                            onPressed: () {},
                            child: AutoSizeText(
                              "Complete",
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontSize: 10.0,
                                  fontWeight: FontWeight.normal),
                              minFontSize: 8.0,
                            ),
                            style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                primary: Colors.white,
                                backgroundColor: Color(0xff263A96)),
                          ),
                  )
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText(
                    "check in on ${thisMonthModels[index].workin}",
                    style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 9.0,
                        fontWeight: FontWeight.normal),
                    minFontSize: 7.0,
                  ),
                  thisMonthModels[index].workout == null
                      ? AutoSizeText(
                          "check out on ",
                          style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 9.0,
                              fontWeight: FontWeight.normal),
                          minFontSize: 7.0,
                        )
                      : AutoSizeText(
                          "check out on ${thisMonthModels[index].workout}",
                          style: TextStyle(
                              fontFamily: 'DMSans',
                              fontSize: 9.0,
                              fontWeight: FontWeight.normal),
                          minFontSize: 7.0,
                        ),
                ],
              ),
              Divider()
            ],
          ),
        )),
  );
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
                title: const Text(
                  "Home",
                  style: TextStyle(
                    fontFamily: 'DMSans',
                  ),
                ),
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
                title: const Text(
                  "Profile",
                  style: TextStyle(
                    fontFamily: 'DMSans',
                  ),
                ),
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
                title: const Text(
                  "About us",
                  style: TextStyle(
                    fontFamily: 'DMSans',
                  ),
                ),
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
                title: const Text(
                  "Logout",
                  style: TextStyle(
                    fontFamily: 'DMSans',
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(
                        "Are you sure you want to log out?",
                        style: TextStyle(
                          fontFamily: 'DMSans',
                        ),
                      ),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancle",
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  fontWeight: FontWeight.bold),
                            )),
                        TextButton(
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setBool('showLogin', false);

                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          LoginScreen()),
                                  (Route<dynamic> route) => false);

                              signOutProcess();
                            },
                            child: Text(
                              "Log Out",
                              style: TextStyle(
                                  fontFamily: 'DMSans',
                                  color: Colors.redAccent),
                            ))
                      ],
                    ),
                    barrierDismissible: false,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
