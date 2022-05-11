import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mana_app/screen/privacy_screen.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  String? version, buildNumber;
  @override
  void initState() {
    super.initState();
    readVersionApp();
  }

  Future<Null> readVersionApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    buildNumber = packageInfo.buildNumber;
    setState(() {});

    print("Version: $version, build: $buildNumber");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE9EBF4),
      appBar: AppBar(
        title: Text(
          "About us",
          style: TextStyle(fontFamily: 'DMSans', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff263A96),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.policy_outlined,
                      color: Color(0xff263A96),
                    ),
                    title: Text("Privacy policy", style: GoogleFonts.dmSans()),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen()));
                    },
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.get_app,
                      color: Color(0xff263A96),
                    ),
                    title: const Text(
                      "Version",
                      style: TextStyle(
                        fontFamily: 'DMSans',
                      ),
                    ),
                    trailing: Text("${version} (${buildNumber})"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
