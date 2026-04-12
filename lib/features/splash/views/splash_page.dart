import 'package:flutter/material.dart';
import 'package:pi_projeto/app/routes/app_routes.dart'; // Importe suas rotas
import 'package:pi_projeto/core/theme/app_colors.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.CorPrincipal,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 186),
              Image.asset('assets/images/icon.png'),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
              Spacer(),
              const Text(
                'from',
                style: TextStyle(
                  color: AppColors.CorBranco,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                'UNIFEOB',
                style: TextStyle(
                  color: AppColors.CorBranco,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
