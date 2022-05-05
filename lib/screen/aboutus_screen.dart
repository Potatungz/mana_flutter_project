import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9EBF4),
      appBar: AppBar(
        title: Text("About us"),
        backgroundColor: Color(0xff263A96),
      ),
      body: SafeArea(
        child: Center(child: Text("Coming Soon")),
      ),
    );
  }
}
