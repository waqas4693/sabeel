import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sabeelapp/routes/app_pages.dart';
import 'package:sabeelapp/presentation/widgets/step_card.dart';
import 'package:sabeelapp/presentation/views/sign_in_dialog.dart';
import 'package:sabeelapp/presentation/widgets/glow_pulse_logo.dart';
import 'package:sabeelapp/presentation/widgets/scroll_indicator.dart';
import 'package:sabeelapp/presentation/widgets/gradient_action_button.dart';
import 'package:sabeelapp/presentation/widgets/custom_particles_background.dart';
import 'package:sabeelapp/presentation/widgets/hex_pattern_tiled_background.dart';

class JourneyView extends StatefulWidget {
  const JourneyView({super.key});

  @override
  State<JourneyView> createState() => _JourneyViewState();
}

class _JourneyViewState extends State<JourneyView> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Prevent keyboard from affecting scroll position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Ensure the page controller maintains its position
        _pageController.addListener(() {
          // This prevents unwanted scroll changes
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent keyboard from affecting layout
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1a3a5c), Color(0xFF2c5282)],
                  ),
                ),
              ),
            ),
            Positioned.fill(child: HexPatternTiledBackground()),
            Positioned.fill(child: CustomParticlesBackground()),
            PageView(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(), // Prevent overscroll
              children: [
                // Divine Purpose Section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 48,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      GlowPulseLogo(size: 80),
                      SizedBox(height: 24),
                      Text(
                        'Your Journey to',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Divine Purpose',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        '"Allah does not burden a soul beyond that it can bear."',
                        style: TextStyle(
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '— Surah Al-Baqarah, 2:286',
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      SizedBox(height: 32),
                      Text(
                        'Every soul has a unique purpose. Through divine guidance and inner reflection, yours will be revealed.',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),
                      ScrollIndicator(),
                    ],
                  ),
                ),
                // Step 1
                StepCard(
                  stepNumber: 1,
                  title: 'Self-Reflection & Understanding',
                  subtitle: 'Step 1',
                  description:
                      'Begin with deep self-reflection through Islamic practices. Engage in regular prayer (Salah), meditation (Muraqaba), and self-assessment (Muhasaba).',
                  quote: 'Whoever knows himself knows his Lord.',
                  iconSvg:
                      '''<svg width="100" height="100" viewBox="0 0 100 100"><circle cx="50" cy="50" r="45" stroke="currentColor" stroke-width="1.5" fill="none"></circle><circle cx="50" cy="50" r="35" stroke="currentColor" stroke-width="1.5" fill="none" opacity="0.7"></circle><circle cx="50" cy="50" r="25" stroke="currentColor" stroke-width="1.5" fill="none" opacity="0.5"></circle></svg>''',
                ),
                // Step 2
                StepCard(
                  stepNumber: 2,
                  title: 'Divine Signs & Guidance.',
                  subtitle: 'Step 2',
                  description:
                      'Learn to recognize Allah\'s signs (Ayat) in your daily life. The Qur\'an teaches:',
                  quote:
                      'We will show them Our signs in the horizons and within themselves until it becomes clear to them that it is the truth.\n41:53',
                  iconSvg:
                      '''<svg width="100" height="100" viewBox="0 0 100 100"><polygon points="50,10 90,30 90,70 50,90 10,70 10,30" stroke="currentColor" stroke-width="1.5" fill="none"></polygon><polygon points="50,25 80,40 80,65 50,75 20,65 20,40" stroke="currentColor" stroke-width="1.5" fill="none" opacity="0.7"></polygon><polygon points="50,40 65,50 65,60 50,65 35,60 35,50" stroke="currentColor" stroke-width="1.5" fill="none" opacity="0.5"></polygon></svg>''',
                ),
                // Step 3
                StepCard(
                  stepNumber: 3,
                  title: 'Talents & Blessings',
                  subtitle: 'Step 3',
                  description:
                      'Identify your God-given talents (Niam). Every skill and ability is an Amanah (trust) from Allah.',
                  quote:
                      'Every one of you is a shepherd and is responsible for his flock.',
                  iconSvg:
                      '''<svg width="100" height="100" viewBox="0 0 100 100"><circle cx="50" cy="50" r="15" stroke="currentColor" stroke-width="1.5" fill="none"></circle><circle cx="80" cy="50" r="15" stroke="currentColor" stroke-width="1.5" fill="none" opacity="0.8"></circle><circle cx="65" cy="75.98076211353316" r="15" stroke="currentColor" stroke-width="1.5" fill="none" opacity="0.8"></circle><circle cx="35.00000000000001" cy="75.98076211353316" r="15" stroke="currentColor" stroke-width="1.5" fill="none" opacity="0.8"></circle><circle cx="20" cy="50.00000000000001" r="15" stroke="currentColor" stroke-width="1.5" fill="none" opacity="0.8"></circle><circle cx="34.999999999999986" cy="24.019237886466847" r="15" stroke="currentColor" stroke-width="1.5" fill="none" opacity="0.8"></circle><circle cx="65" cy="24.019237886466843" r="15" stroke="currentColor" stroke-width="1.5" fill="none" opacity="0.8"></circle></svg>''',
                ),
                // Step 4
                StepCard(
                  stepNumber: 4,
                  title: 'Service & Purpose',
                  subtitle: 'Step 4',
                  description:
                      'Align your gifts with serving others (Khidma). The Prophet ﷺ taught:',
                  quote: 'The best of people are those who benefit others.',
                  iconSvg:
                      '''<svg width="100" height="100" viewBox="0 0 100 100"><path d="M30,25 C30,15 20,15 20,25 C20,35 30,35 30,25 C30,15 70,15 70,25 C70,35 80,35 80,25 C80,15 70,15 70,25 C70,35 30,35 30,25 Z" stroke="currentColor" stroke-width="1.5" fill="none"></path></svg>''',
                ),
              ],
            ),
            Positioned(
              top: 20,
              right: 25,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Get.bottomSheet(
                        const SignInDialog(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        enableDrag: true,
                      );
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GradientActionButton(
                    text: 'Begin Your Path',
                    onPressed: () {
                      Get.toNamed(Routes.ONBOARDING);
                    },
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
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
