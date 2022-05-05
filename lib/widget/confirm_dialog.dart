import 'package:flutter/material.dart';
import 'package:mana_app/screen/home_screen.dart';

Future<Null> confirmDialog(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(
                              Icons.login,
                              size: 40,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Checkin Confirm ?",
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "Check in Time",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff8D8D8D)),
                                          ),
                                          Text("00:00",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ))
                                        ],
                                      ),
                                      Container(
                                        height: 24,
                                        width: 1.0,
                                        color: Color(0xff8D8D8D),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text("Check in Out",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xff8D8D8D))),
                                          Text("00:00",
                                              style: TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xff8D8D8D)))
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 48.0,
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      MaterialPageRoute route =
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeScreen());
                                      Navigator.of(context).pushAndRemoveUntil(
                                          route, (route) => false);
                                    },
                                    child: const Text(
                                      "CONFIRM",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        primary: Colors.white,
                                        backgroundColor: Color(0xff263A96)),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "CANCEL",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    style: TextButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      primary: Color(0xffD0D0D0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
}
