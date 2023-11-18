import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/Provider/variant_provider.dart';
import 'package:furniverse_admin/firebasefiles/firebase_user_notification.dart';
import 'package:furniverse_admin/services/auth_services.dart';
import 'package:furniverse_admin/services/order_services.dart';
import 'package:furniverse_admin/services/product_services.dart';
import 'package:furniverse_admin/wrapper.dart';
import 'package:provider/provider.dart';
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
        value: ProductService().streamProducts(), initialData: null),
    StreamProvider<User?>.value(value: AuthService().user, initialData: null),
  ], child: MyApp()));
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final routes = {
    '/': 'Home Page',
    '/page1': 'Page 1',
    '/adminHome': "Admin Home",
    '/newprod': "New Product",
    '/notif': "Notfication",
    '/login': 'login',
    // '/status': "Status",
    // '/req': "Request",
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
      navigatorKey: navigatorKey,
      initialRoute: '/',
      title: 'Furniverse',
      theme: customTheme,
      home: const Wrapper(),
      // routes: {
      //   '/': (context) => MainButtons(routes),
      //   '/page1': (context) => const Sample(),
      //   '/adminHome': (context) => const AdminMain(),
      //   '/newprod': (context) => const AddProduct(),
      //   '/notif': (context) => const AppNotification(),
      //   '/login' : (context) => const LogIn(),
      //   // '/status': (context) => const OrderStatus(),
      //   // '/req': (context) => const CustomerRequestPage(),
      // },
    );
  }
}
