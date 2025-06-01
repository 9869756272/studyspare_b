import 'package:flutter/material.dart';

ThemeData getApplicationTheme(){
  return ThemeData(
     useMaterial3: false,primarySwatch: Colors.blue,
     fontFamily: 'Opensans Regular',
     elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
     ),
     appBarTheme: const AppBarTheme(
      centerTitle: true,
      color:Color.fromARGB(255, 77, 144, 199),
      elevation: 4,
      shadowColor: Colors.black,
      titleTextStyle: TextStyle(
        fontFamily:'OpenSans Bold',
        fontSize: 20    ,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
     ),

  );
}