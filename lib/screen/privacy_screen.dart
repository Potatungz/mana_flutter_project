import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9EBF4),
      appBar: AppBar(
        title: const Text("Privacy Policy",
            style:
                TextStyle(fontFamily: 'DMSans', fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Color(0xff263A96),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: "https://www.bangkokcable.com/th/pdpa",
      ),
    );
  }
}
