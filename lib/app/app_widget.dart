import 'package:flutter/material.dart';
import 'package:pi_projeto/app/routes/app_pages.dart';
import 'package:pi_projeto/app/routes/app_routes.dart';


void main() {
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Dentista',
      initialRoute: AppRoutes.splash,
      routes: AppPages.routes,
      theme: 
        ThemeData(
          useMaterial3: true,
          primaryColor: const Color(0xFFB86B77),
        ),
    );
  }
}
