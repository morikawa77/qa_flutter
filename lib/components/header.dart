import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:routemaster/routemaster.dart';

class Header extends AppBar {
  final bool showLogoutButton;
  final BuildContext context;

  // ignore: use_key_in_widget_constructors
  Header({
    required this.showLogoutButton,
    required this.context,
  }) : super(
          title: const Text(
            'Live Q&A',
            style: TextStyle(
              fontFamily: 'IowanOldStyle',
              fontSize: 36.0,
            ),
          ),
          actions: [
            if (showLogoutButton)
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Routemaster.of(context).push('/');
                },
              ),
          ],
        );
}
