// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, avoid_print, depend_on_referenced_packages

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:climbot/login.dart';
import 'package:climbot/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (Firebase.apps.isEmpty) {
    print('Firebase has not been initialized');
  } else {
    print('Firebase has been initialized');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: Consumer(
            builder: (context, ThemeProvider modelTheme, child) => MaterialApp(
                  title: 'ClimBot',
                  theme: modelTheme.isDark
                      ? ThemeData.dark()
                      : ThemeData(
                          primarySwatch: Colors.amber,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                  debugShowCheckedModeBanner: false,
                  // darkTheme: ThemeData.dark(),
                  initialRoute: '/',
                  routes: {
                    '/': (context) => const OnBoardingPage(),
                    'home': (context) => const Home(),
                    'login': (context) => Login(),
                    'register': (context) => Register(),
                  },
                )));
  }
}

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  void _onIntroEnd(context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Home()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => Login()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  final introKey = GlobalKey<IntroductionScreenState>();

  Widget _builLottie(String assetName, [double width = 350]) {
    return Lottie.network(assetName, width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          child: const Text(
            'Let\'s go right away!',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () => _onIntroEnd(context),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Hi, There",
          body: "Welcome to ClimBot, A Higly precise Weather Application",
          image: _builLottie(
              'https://assets1.lottiefiles.com/packages/lf20_sokznsry.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Precise Location",
          body:
              "its gets your precise location for urrent weather details of your location ",
          image: _builLottie(
              'https://assets2.lottiefiles.com/packages/lf20_xxc4uwgo.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Higly Accurate Data",
          body: "Gives you the precise weather data of your location",
          image: _builLottie(
              'https://assets5.lottiefiles.com/packages/lf20_x17ybolp.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "User Friendly",
          body: "Easy to use interface",
          image: _builLottie(
              'https://assets9.lottiefiles.com/packages/lf20_ab0pxvgc.json'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "See Yourself",
          bodyWidget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Click on Done", style: bodyStyle),
              Text(" To get started", style: bodyStyle),
            ],
          ),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
            bodyAlignment: Alignment.bottomCenter,
            imageAlignment: Alignment.topCenter,
          ),
          image: _builLottie(
              'https://assets3.lottiefiles.com/temp/lf20_JA7Fsb.json'),
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
