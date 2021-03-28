import 'package:asciify/screens/camera_page.dart';
import 'package:asciify/screens/home_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        cardColor: Color(0xFF5B84C4),
        fontFamily: 'Righteous',
        bottomAppBarTheme: BottomAppBarTheme(
          color: Color(0xFF939BB1),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF939BB1),
          centerTitle: true,
        ),
          backgroundColor: Color(0xFF11224D),
          textTheme: TextTheme(
            headline1: TextStyle(
              color: Color(0xFFF98125),
              fontSize: 80.0,
            ),
              headline2: TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 15.0,
              )
        ),
      ),
      routes: {
      '/' : (context) => HomePage(),
      '/camera': (context) => CameraPage()
      },
    )
  );
}
