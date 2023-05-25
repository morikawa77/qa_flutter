// import 'dart:ui';
import 'package:flutter/material.dart';

class MyTheme {
  static const primaryColor = Color(0xFF00796B);
  static const accent = Color(0xFFFFC107);
  static const inputFontColor = Color(0xFF757575);
  static const white = Color(0xFFFFFFFF);
  static const inputBackgroundColor = Color(0xFFB2DFDB);
  static const black = Color(0xFF1E1E1E);
  static const error = Color(0xFFA00000);

  // static const buttonStyle as ButtonStyle = ButtonStyle(
  //     backgroundColor: MaterialStateProperty.all<Color>(MyTheme.accent), // Cor de fundo
  //     padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.fromLTRB(9, 24, 9, 24)), 
  //     textStyle: MaterialStateProperty.all<TextStyle>(
  //       const TextStyle(
  //         fontSize: 16, 
  //         fontFamily: 'IowanOldStyle',
  //         color: MyTheme.black,
  //       )
  //     ), // Cor da fonte
  //     shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: MyTheme.black))), 
  //   ),
  //   child: const Text('Criar usuário'),
  // );

  static ThemeData myTheme = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: black,
      foregroundColor: accent,
      titleTextStyle: TextStyle(
        color: accent,
        fontWeight: FontWeight.bold,
        fontSize: 36.0,
      ),
    ),

    scaffoldBackgroundColor: primaryColor,
    // canvasColor: primaryColor,
    // cardColor: black,
    // dialogBackgroundColor: black,
    // disabledColor: inputFontColor,
    // dividerColor: inputFontColor,
    // focusColor: ,
    // highlightColor: ,
    // hintColor: ,
    // hoverColor: ,
    // indicatorColor: ,
    // primaryColor: primaryColor,
    // primaryColorDark: primaryColor,
    // primaryColorLight: primaryColor,
    // secondaryHeaderColor: ,
    // shadowColor: black,
    // splashColor: ,
    // unselectedWidgetColor: ,

    textTheme: const TextTheme(
      displayLarge: TextStyle(
      fontSize: 12.0,
    ),
    displayMedium: TextStyle(
      fontSize: 12.0,
    ),
    displaySmall: TextStyle(
      fontSize: 12.0,
    ),
    headlineLarge: TextStyle(
      fontSize: 12.0,
    ),
    headlineMedium: TextStyle(
      fontSize: 12.0,
    ),
    headlineSmall: TextStyle(
      fontSize: 12.0,
    ),
    titleLarge: TextStyle(
      fontSize: 18.0,
    ),
    titleMedium: TextStyle(
      fontSize: 16.0,
    ),
    titleSmall: TextStyle(
      fontSize: 14.0, 
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0, 
      // fontStyle: FontStyle.italic,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0, 
    ),
    bodySmall: TextStyle(
      fontSize: 14.0, 
    ),
    labelLarge: TextStyle(
      fontSize: 14.0, 
    ),
    labelMedium: TextStyle(
      fontSize: 14.0, 
    ),
    labelSmall: TextStyle(
      fontSize: 14.0, 
      // fontFamily: 'Hind',
    ),
    ), 
  );
}


// const TextStyle({
//     this.inherit = true,
//     this.color,
//     this.backgroundColor,
//     this.fontSize,
//     this.fontWeight,
//     this.fontStyle,
//     this.letterSpacing,
//     this.wordSpacing,
//     this.textBaseline,
//     this.height,
//     this.leadingDistribution,
//     this.locale,
//     this.foreground,
//     this.background,
//     this.shadows,
//     this.fontFeatures,
//     this.fontVariations,
//     this.decoration,
//     this.decorationColor,
//     this.decorationStyle,
//     this.decorationThickness,
//     this.debugLabel,
//     String? fontFamily,
//     List<String>? fontFamilyFallback,
//     String? package,
//     this.overflow,
//   }