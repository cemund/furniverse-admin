import 'package:flutter/material.dart';
import 'package:furniverse_admin/sample.dart';
import 'home/main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final routes = {
    '/': 'Home Page',
    '/page1': 'Page 1',
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
        '/page1': (context) => const Sample(),
      },
    );
  }
}
