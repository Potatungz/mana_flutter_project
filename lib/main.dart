import 'package:flutter/material.dart';
import 'package:mana_app/screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final showLogin = prefs.getBool("showLogin") ?? false;

  runApp(MyApp(showLogin: showLogin));
}

class MyApp extends StatelessWidget {
  final bool showLogin;
  const MyApp({
    Key? key,
    required this.showLogin,
  }) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: showLogin ? LoginScreen() : OnboardingPage(),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required subtitle,
  }) =>
      Padding(
        padding: const EdgeInsets.all(40.0),
        child: Container(
            color: color,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Image.asset(
                urlImage,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Color(0xff191E2F),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 24.0,
              ),
              Container(
                child: Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                    color: Color(
                      0xff8D8D8D,
                    ),
                  ),
                ),
              ),
            ])),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: <Widget>[
            buildPage(
                color: Colors.white,
                urlImage: "asset/onboarding01.png",
                title: 'ไม่ต้องรีบตื่นเช้าไปเข้างาน',
                subtitle:
                    'เมื่อมีแอป MANA คุณก็จะลดเวลาการเดินทางไปทำงาน ทำให้คุณมีเวลามากขึ้น และมีความสุขมากขึ้น'),
            buildPage(
                color: Colors.white,
                urlImage: "asset/onboarding02.png",
                title: 'เข้างานที่ไหน..ก็ได้บนใบโลกนี้',
                subtitle:
                    'เมื่อมีแอป MANA คุณจะทำงานที่ไหนก็ได้ เมื่อไหร่ก็ได้ ทำให้ชีวิตการเข้าทำงานของคุณสะดวกมากยิ่งขึ้น'),
            buildPage(
                color: Colors.white,
                urlImage: "asset/onboarding03.png",
                title: 'ปักหมุดพิกัดการเข้า-ออกงาน',
                subtitle:
                    'แอป MANA จะเป็นเหมือนผู้ช่วยส่วนตัว เก็บข้อมูล และบันทึกตำแหน่งที่คุณเช็คอินเข้าทำงานในทุกๆวัน'),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)),
                primary: Colors.white,
                backgroundColor: Color(0xff263A96),
                minimumSize: const Size.fromHeight(80.0),
              ),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showLogin', true);

                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: const Text(
                "Get Start",
                style: TextStyle(fontSize: 24.0),
              ))
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 80.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    onPressed: () => controller.jumpToPage(2),
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff263A96),
                      ),
                    ),
                  ),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: WormEffect(
                        spacing: 10,
                        dotHeight: 12,
                        dotWidth: 12,
                        dotColor: Color(0xffE9EBF4),
                        activeDotColor: Color(0xff263A96),
                      ),
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn),
                    ),
                  ),
                  TextButton(
                    onPressed: () => controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff263A96),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
