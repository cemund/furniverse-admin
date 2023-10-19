import 'package:flutter/material.dart';

class MainButtons extends StatelessWidget {
  final Map<String, String> routes;

  const MainButtons(this.routes, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  const Color(0xFFF0F0F0),
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
