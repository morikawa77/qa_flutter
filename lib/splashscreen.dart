import 'package:flutter/material.dart';
import 'package:qa_flutter/theme.dart';
import 'package:routemaster/routemaster.dart';
import 'dart:async';



class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 2), () {
      Routemaster.of(context).push('/login');
    });

    return Container(
      color: MyTheme.primaryColor,
      child: const Center(
        child: Text('Live Q&A', style: TextStyle(
          fontFamily: 'IowanOldStyle',
          fontSize: 36.0,
          decoration: TextDecoration.none,
          color: MyTheme.accent,
        ),),
      ),
    );
  }
}