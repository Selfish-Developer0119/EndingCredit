import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Color(0xFFF2F2F7),
        dialogBackgroundColor: Color(0xFFF2F2F7),
        primaryColor: Colors.white,
        accentColor: Colors.black,
        backgroundColor: Colors.grey,
        primaryColorLight: Color(0xFF333333),
        textTheme: TextTheme(
          headline1: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.grey, fontSize: 15.0),

        )
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Color(0xFF222222),
        dialogBackgroundColor: Colors.black,
        primaryColor: Colors.black,
        accentColor: Colors.white,
        backgroundColor: Colors.grey,
          primaryColorLight: Colors.white,
          textTheme: TextTheme(
            headline1: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
            bodyText1: TextStyle(color: Colors.white,),
            bodyText2: TextStyle(color: Colors.grey, fontSize: 15.0),
          )
      ),
      home: HomeScreen(),
    );
  }
}
