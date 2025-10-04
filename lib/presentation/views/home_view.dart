import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sabeelapp/routes/app_pages.dart';
import 'package:sabeelapp/presentation/widgets/glow_pulse_logo.dart';
import 'package:sabeelapp/presentation/controllers/home_controller.dart';
import 'package:sabeelapp/presentation/widgets/gradient_action_button.dart';
import 'package:sabeelapp/presentation/widgets/custom_particles_background.dart';
import 'package:sabeelapp/core/auth_service.dart';
import 'package:sabeelapp/services/api_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.find<HomeController>();
  final AuthService _authService = Get.find<AuthService>();
  bool _isCheckingLogin = false;

  /// Check if user is already logged in and navigate accordingly
  Future<void> _handleFindPurposePress() async {
    if (_isCheckingLogin) return; // Prevent multiple taps

    setState(() {
      _isCheckingLogin = true;
    });

    try {
      // Check if user has a valid token
      if (ApiService.isLoggedIn && _authService.isLoggedIn) {
        // User is logged in, go directly to dashboard
        Get.toNamed(Routes.DASHBOARD);
      } else {
        // User is not logged in, go to journey (which will redirect to login)
        Get.toNamed(Routes.JOURNEY);
      }
    } catch (e) {
      print('Error checking login status: $e');
      // Fallback to normal flow
      Get.toNamed(Routes.JOURNEY);
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingLogin = false;
        });
      }
    }
  }

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
                    text: _isCheckingLogin
                        ? 'Checking...'
                        : 'Find Your Purpose',
                    onPressed: _isCheckingLogin
                        ? null
                        : _handleFindPurposePress,
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
