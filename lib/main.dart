import 'package:flutter/material.dart';
import 'package:furniverse_admin/LoginandLogout/login.dart';
import 'package:furniverse_admin/admin_prod_list/admin_prod_list.dart';
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
    '/adminProdList': "Admin Product List",
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
        '/adminProdList': (context) => const AdminProdList(),
      },
    );
  }
}
