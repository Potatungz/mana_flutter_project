import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mana_app/model/check_in_model.dart';
import 'package:mana_app/model/usermodel.dart';
import 'package:mana_app/screen/home_screen.dart';
import 'package:mana_app/utility/dialog.dart';
import 'package:mana_app/utility/my_style.dart';
import 'package:mana_app/widget/confirm_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utility/my_constant.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  UserModel? userModel;
  CheckInModel? checkInModel;

  String? m_id, workdate_in, workin, latitude_in, longitude_in, address;

  List<CheckInModel> checkinModels = [];

  double? lat1, lng1;
  double? distance;
  // Location location = Location();

  var myDateTime = DateTime.now();
  var dateFormater = DateFormat.yMd();
  var timeFormater = DateFormat.Hms();

  late GoogleMapController _googleMapController;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    findMyLocation();
  }

  Future<Null> findMyLocation() async {
    Position position = await getGeoLocationPosition();
    setState(() {
      lat1 = position.latitude;
      lng1 = position.longitude;
    });
    getAddress(position);
  }

  Future<void> getAddress(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemark);

    Placemark place = placemark[0];
    address =
        "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}";
    setState(() {});
  }

  Future<Position> getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openAppSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
  //   double distance = 0;

  //   var p = 0.017453292519943295;
  //   var c = cos;
  //   var a = 0.5 -
  //       c((lat2 - lat1) * p) / 2 +
  //       c(lat1 * p) * c(lat2 * p) * (1 - c((lng2 - lng1) * p)) / 2;
  //   distance = 12742 * asin(sqrt(a));

  //   return distance;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFAFA),
      appBar: AppBar(
        title: Text("Check in",
            style: TextStyle(fontFamily: 'Kanit', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xff263A96),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(children: [
            showMap(),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2), // Shadow position
                    ),
                  ],
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              child: Icon(
                                Icons.map_rounded,
                                color: Color(0xff263A96),
                                size: 32,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Container(
                              child: Text(
                                "Work Description",
                                style: TextStyle(
                                    fontFamily: 'Kanit',
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff191E2F)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                              flex: 1,
                              child: SizedBox(
                                width: double.infinity,
                              )),
                          Flexible(
                            flex: 2,
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: <Widget>[
                                      AutoSizeText(
                                        "Lattitude: ",
                                        style: TextStyle(
                                            fontFamily: 'Kanit',
                                            fontSize: 10.0,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff191E2F)),
                                        minFontSize: 8.0,
                                        maxLines: 1,
                                      ),
                                      Expanded(
                                        child: lat1 == null
                                            ? AutoSizeText(
                                                "-",
                                                style: TextStyle(
                                                    fontFamily: 'Kanit',
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff474747)),
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 8.0,
                                                maxLines: 1,
                                              )
                                            : AutoSizeText(
                                                "$lat1",
                                                style: TextStyle(
                                                    fontFamily: 'Kanit',
                                                    fontSize: 10.0,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff474747)),
                                                overflow: TextOverflow.ellipsis,
                                                minFontSize: 8.0,
                                                maxLines: 1,
                                              ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                              flex: 2,
                              child: Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          AutoSizeText(
                                            "Longitude: ",
                                            style: TextStyle(
                                                fontFamily: 'Kanit',
                                                fontSize: 10.0,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff191E2F)),
                                            minFontSize: 8.0,
                                            maxLines: 1,
                                          ),
                                          Expanded(
                                            child: lng1 == null
                                                ? AutoSizeText(
                                                    "-",
                                                    style: TextStyle(
                                                        fontFamily: 'Kanit',
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff474747)),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    minFontSize: 8.0,
                                                    maxLines: 1,
                                                  )
                                                : AutoSizeText(
                                                    "$lng1",
                                                    style: TextStyle(
                                                        fontFamily: 'Kanit',
                                                        fontSize: 10.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xff474747)),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    minFontSize: 8.0,
                                                    maxLines: 1,
                                                  ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.1,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2), // Shadow position
                    ),
                  ],
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              child: Icon(
                                Icons.location_pin,
                                color: Color(0xff263A96),
                                size: 32.0,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Container(
                              child: Text(
                                "Check in Address",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Kanit',
                                    color: Color(0xff191E2F)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                              flex: 1,
                              child: SizedBox(
                                width: double.infinity,
                              )),
                          Flexible(
                            flex: 4,
                            child: Container(
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  address == null
                                      ? AutoSizeText(
                                          "-",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Kanit',
                                              color: Color(0xff474747)),
                                          overflow: TextOverflow.ellipsis,
                                          minFontSize: 8.0,
                                          maxLines: 1,
                                        )
                                      : AutoSizeText(
                                          "$address",
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Kanit',
                                              color: Color(0xff474747)),
                                          overflow: TextOverflow.ellipsis,
                                          minFontSize: 8.0,
                                          maxLines: 1,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2), // Shadow position
                            ),
                          ],
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 2,
                              child: Container(
                                height: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: Color(0xff263A96),
                                      size: 32.0,
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text("วันที่",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Kanit',
                                            color: Color(0xff191E2F))),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: Container(
                                  height: double.infinity,
                                  child: Center(
                                      child: Text(
                                    "${dateFormater.format(myDateTime)}",
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Kanit',
                                        color: Color(0xff474747)),
                                  ))),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 2), // Shadow position
                            ),
                          ],
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 2,
                              child: Container(
                                height: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.timelapse_outlined,
                                        color: Color(0xff263A96), size: 32.0),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text("เวลา",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Kanit',
                                            color: Color(0xff191E2F))),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 5,
                              child: Container(
                                  height: double.infinity,
                                  decoration: BoxDecoration(),
                                  child: Center(
                                      child: Text(
                                    "${timeFormater.format(myDateTime)}",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Kanit',
                                        color: Color(0xff474747)),
                                  ))),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 30.0),
        child: Container(
          width: double.infinity,
          height: 50.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color(0xff263A96),
                textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit')),
            onPressed: () {
              showConfirmDialog();
            },
            child: Text("บันทึกเวลาเข้างาน"),
          ),
          // child: TextButton(
          //   child: const Text(
          //     "บันทึกเวลาเข้างาน",
          //     style: TextStyle(
          //       fontSize: 14.0,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   style: TextButton.styleFrom(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10.0)),
          //       primary: Colors.white,
          //       backgroundColor: Color(0xff263A96)),
          //   onPressed: () {
          //     showConfirmDialog();
          //   },
          // ),
        ),
      ),
    );
  }

  Set<Marker> myLocation() {
    return <Marker>[
      Marker(
        markerId: MarkerId("myLocation"),
        position: LatLng(lat1!, lng1!),
        infoWindow: InfoWindow(
          title: "ตำแหน่งของฉัน",
        ),
      ),
    ].toSet();
  }

  Container showMap() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      print("Target Platform = $defaultTargetPlatform");
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }

    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: Color(0xffE0E0E0)),
            color: Colors.white),
        child: lat1 == null
            ? MyStyle().showProgress()
            : GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      lat1!,
                      lng1!,
                    ),
                    zoom: 16.0),
                mapType: MapType.normal,
                onMapCreated: (controller) => _googleMapController = controller,
                markers: myLocation(),
              ));
  }

  Future<Null> showConfirmDialog() async {
    myDateTime = DateTime.now();
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
                                color: Colors.green,
                                size: 40,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AutoSizeText(
                                      "Checkin Confirm ?",
                                      style: TextStyle(
                                          fontFamily: 'Kanit',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold),
                                      maxFontSize: 14.0,
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            AutoSizeText("Check in Time",
                                                style: TextStyle(
                                                    fontFamily: 'Kanit',
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color(0xff8D8D8D)),
                                                minFontSize: 12.0),
                                            AutoSizeText(
                                                "${timeFormater.format(myDateTime)}",
                                                style: TextStyle(
                                                    fontFamily: 'Kanit',
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xff263A96)),
                                                minFontSize: 12.0)
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
                                            AutoSizeText("Check in Out",
                                                style: TextStyle(
                                                    fontFamily: 'Kanit',
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Color(0xff8D8D8D)),
                                                minFontSize: 12.0),
                                            AutoSizeText(
                                              "00:00",
                                              style: TextStyle(
                                                  fontFamily: 'Kanit',
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Color(0xff8D8D8D)),
                                              minFontSize: 12.0,
                                            )
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
                                        insertDataCheckin();
                                      },
                                      child: const Text(
                                        "CONFIRM",
                                        style: TextStyle(
                                          fontFamily: 'Kanit',
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
                                          fontFamily: 'Kanit',
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

  Future<Null> insertDataCheckin() async {
    myDateTime = DateTime.now();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    m_id = preferences.getString('userid');
    workdate_in = dateFormater.format(myDateTime);
    workin = timeFormater.format(myDateTime);
    latitude_in = lat1.toString();
    longitude_in = lng1.toString();

    String urlAddDataCheckin =
        "${MyConstant().domain}/checkin/addDataCheckIn.php?isAdd=true&m_id=$m_id&workdate=$workdate_in&workin=$workin&latitude_in=$latitude_in&longitude_in=$longitude_in";
    try {
      Response response = await Dio().get(urlAddDataCheckin);

      if (response.toString() == 'true') {
        Navigator.pop(context);
        MaterialPageRoute route =
            MaterialPageRoute(builder: (context) => HomeScreen());
        Navigator.of(context).pushAndRemoveUntil(route, (route) => false);
      } else {}
    } catch (e) {}
  }
}
