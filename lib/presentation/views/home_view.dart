import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sabeelapp/routes/app_pages.dart';
import 'package:sabeelapp/presentation/widgets/glow_pulse_logo.dart';
import 'package:sabeelapp/presentation/controllers/home_controller.dart';
import 'package:sabeelapp/presentation/widgets/gradient_action_button.dart';
import 'package:sabeelapp/presentation/widgets/custom_particles_background.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1a3a5c), // from-[#1a3a5c]
                      Color(0xFF2c5282), // to-[#2c5282]
                    ],
                  ),
                ),
              ),
            ),
            Positioned.fill(child: CustomParticlesBackground()),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GlowPulseLogo(size: 80),
                  SizedBox(height: 24),
                  Text(
                    'Sabeel',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '(The Path)',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  SizedBox(height: 32),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '"Indeed, Allah will not change the condition of a people until they change what is in themselves."',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '— Qur\'an 13:11',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  SizedBox(height: 40),
                  GradientActionButton(
                    text: 'Find Your Purpose',
                    onPressed: () {
                      Get.toNamed(Routes.JOURNEY);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 55,
                      vertical: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF204366),
    );
  }
}
