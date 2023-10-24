import 'package:flutter/material.dart';
import 'package:furniverse_admin/LoginandLogout/login.dart';
import 'package:furniverse_admin/admin_home/admin_main.dart';
import 'package:furniverse_admin/admin_home/pages/admin_prod_list_dart.dart';
import 'home/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routes = {
    '/': 'Home Page',
    '/page1': 'Page 1',
    '/adminHome': "Admin Home",
  };

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      title: 'Furniverse',
      routes: {
        '/': (context) => MainButtons(routes),
        '/page1': (context) => const LogIn(),
        '/adminHome': (context) => const AdminMain(),
      },
    );
  }
}
