import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qa_flutter/firebase_options.dart';
import 'package:qa_flutter/theme.dart';
import 'package:qa_flutter/splashscreen.dart';
import 'package:qa_flutter/login_page.dart';
import 'package:qa_flutter/home.dart';
import 'package:qa_flutter/admin.dart';
import 'package:qa_flutter/participant.dart';
import 'package:qa_flutter/app_state.dart';
import 'package:qa_flutter/link_handler.dart';

void main() {
  Routemaster.setPathUrlStrategy();
  runApp(const MyApp());
}

final initializingRoutes = RouteMap(
  onUnknownRoute: (route) => MaterialPage<void>(
    child: Scaffold(
      appBar: AppBar(),
      body: const Center(child: CircularProgressIndicator()),
    ),
  ),
  routes: {
    '/': (route) => const MaterialPage<void>(
          key: ValueKey('login'),
          child: LoginPage(),
        ),
    '/login': (route) => const MaterialPage<void>(
          key: ValueKey('login'),
          child: LoginPage(),
        ),
    '/home': (route) => const MaterialPage<void>(
          key: ValueKey('home'),
          child: Home(),
        ),
    '/admin/:code': (route) => MaterialPage<void>(
          child: Admin(code: route.pathParameters['code']!),
        ),
    '/participant/:code': (route) => MaterialPage<void>(
          child: Participant(code: route.pathParameters['code']!),
        ),
  },
);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  final _appState = AppState();

  final RoutemasterDelegate _routemaster = RoutemasterDelegate(
    routesBuilder: (context) {
      return initializingRoutes;
    },
  );

  late final _linkHandler =
      LinkHandler(onLink: (link) => _routemaster.push(link))..init();

  @override
  void dispose() {
    _linkHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // ignore: avoid_print
            print('Erro ao inicializar o Firebase: ${snapshot.error}');
            return const Center(
              child: Text("Erro ao inicializar o Firebase"),
            );
          }
    
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: _appState),
              Provider(
                create: (_) => Api(
                  onAuthFailure: () {
                    _appState.logOut();
                    _routemaster.replace('/');
                  },
                ),
              )
            ],
            child: MaterialApp.router(
              routeInformationParser: const RoutemasterParser(),
              routerDelegate: _routemaster,
              theme: MyTheme.myTheme,
              debugShowCheckedModeBanner: false,
            ),
          );
        }
      )
    );
  }
}

Future<FirebaseApp?> _initializeFirebase() async {
  try {
    FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return app;
  } catch (e) {
    // ignore: avoid_print
    print('Error initializing Firebase: $e');
    return null;
  } 
}