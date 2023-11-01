import 'package:flutter/material.dart';
import 'package:furniverse_admin/LoginandLogout/login.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/admin_home/admin_main.dart';
import 'package:furniverse_admin/admin_home/pages/admin_add_product.dart';
import 'package:furniverse_admin/admin_home/pages/admin_prod_list_dart.dart';
import 'package:furniverse_admin/sample.dart';
import 'package:provider/provider.dart';
import 'home/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => VariantsProvider())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {

  final routes = {
    '/': 'Home Page',
    '/page1': 'Page 1',
    '/adminHome': "Admin Home",
    '/newprod': "New Product",

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
        '/adminHome': (context) => const AdminMain(),
        '/newprod': (context) => const AddProduct(),
      },
    );
  }
}
