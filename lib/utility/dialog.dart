import 'package:flutter/material.dart';

Future<Null> normalDialog(BuildContext context, String string) async {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            title: ListTile(
              title: Text(string,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Kanit',
                      color: Color(0xff354373),
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold)),
              // subtitle: Text(
              //   string,
              //   textAlign: TextAlign.center,
              // ),
            ),
            children: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "ตกลง",
                    style: TextStyle(fontFamily: 'Kanit'),
                  ))
            ],
          ));
}
