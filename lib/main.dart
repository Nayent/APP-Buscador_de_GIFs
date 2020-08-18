import 'package:flutter/material.dart';
import 'Pages/homepage.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        hintColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        )),
    home: HomePage(),
  ));
}
