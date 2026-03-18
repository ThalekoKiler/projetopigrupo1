import 'package:flutter/material.dart';
//import 'screens/home/views/homeOdontoApp.dart';
import 'theme/app_colors.dart';
import 'screens/loginPage/views/login_screen.dart';

/*void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomeOdontoApp(),
  ));
}
*/
void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Dentista',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.CorPrincipal,
      ),
      home: const LoginScreen(),
    );
  }
}
