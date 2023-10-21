import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:furniverse_admin/LoginandLogout/login.dart';
import 'package:furniverse_admin/LoginandLogout/profile_screen.dart';
import 'package:furniverse_admin/sample.dart';

class MainButtons extends StatelessWidget {
  final Map<String, String> routes;

  const MainButtons(this.routes, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: StreamBuilder<User?>(
      //   stream: FirebaseAuth.instance.authStateChanges(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     } else if(snapshot.hasError){
      //       return const Center(child: Text("Something went wrong."),);
      //     } else if (snapshot.hasData) {
      //       return const ProfilePage();
      //     } else {
      //     return const LogIn();
      //     }
      //   }
      // ),

      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Routes'),
          for (var route in routes.entries)
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, route.key);
                },
                child: Text('Go to ${route.value}'))
        ],
      )),
    );
  }
}
