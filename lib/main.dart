import 'package:flutter/material.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/firebasefiles/firebase_user_notification.dart';
import 'package:furniverse_admin/screens/LoginandLogout/login.dart';
import 'package:furniverse_admin/screens/admin_home/admin_main.dart';
import 'package:furniverse_admin/screens/admin_home/pages/admin_add_product.dart';
import 'package:furniverse_admin/screens/admin_home/pages/admin_prod_list_dart.dart';
import 'package:furniverse_admin/sample.dart';
import 'package:furniverse_admin/screens/admin_home/pages/customerrequest.dart';
import 'package:furniverse_admin/screens/admin_home/pages/notification.dart';
import 'package:furniverse_admin/screens/admin_home/pages/orderstatus.dart';
import 'package:furniverse_admin/services/order_services.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:provider/provider.dart';
import 'screens/home/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseUserNotification().initNotifications();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => VariantsProvider(),
    ),
    StreamProvider.value(
        value: OrderService().streamOrders(), initialData: null),
    StreamProvider.value(
        value: ProductService().streamProducts(), initialData: null)
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  final routes = {
    '/': 'Home Page',
    '/page1': 'Page 1',
    '/adminHome': "Admin Home",
    '/newprod': "New Product",
    '/notif': "Notfication",
    '/status': "Status",
    '/req': "Request",
  };

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final customTheme = ThemeData(
      primaryColor: Colors.white,
      primaryIconTheme: const IconThemeData(color: Colors.black),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      title: 'Furniverse',
      theme: customTheme,
      routes: {
        '/': (context) => MainButtons(routes),
        '/page1': (context) => const Sample(),
        '/adminHome': (context) => const AdminMain(),
        '/newprod': (context) => const AddProduct(),
        '/notif': (context) => const AppNotification(),
        '/status': (context) => const OrderStatus(),
        '/req': (context) => const CustomerRequest(),
      },
    );
  }
}
