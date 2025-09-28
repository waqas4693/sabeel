import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sabeelapp/core/auth_service.dart';
import 'package:sabeelapp/presentation/views/quran_view.dart';
import 'package:sabeelapp/presentation/widgets/glow_pulse_logo.dart';
import 'package:sabeelapp/presentation/widgets/gradient_pill_button.dart';
import 'package:sabeelapp/presentation/controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B3A61),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1B3A61),
                      Color(0xFF1E4E84),
                      Color(0xFF1A3150),
                    ],
                  ),
                ),
              ),
            ),
            // Hamburger Menu Button
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Builder(
                  builder: (context) => IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 40,
                      minHeight: 40,
                    ),
                  ),
                ),
              ),
            ),
            // Content based on selected index
            Obx(() => _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: SafeArea(
        child: Container(
          width: 260,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1B3A61), Color(0xFF1E4E84), Color(0xFF1A3150)],
            ),
            border: Border(
              right: BorderSide(
                color: const Color(0xFF1EAEDB).withOpacity(0.2),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              // Logo and App Name Section
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 135.0, 0, 25.0),
                child: Column(
                  children: [
                    GlowPulseLogo(size: 70),
                    const SizedBox(height: 16),
                    const Text(
                      'Sabeel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Navigation Items
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    _buildNavItem(
                      iconPath: 'assets/icons/home.svg',
                      title: 'Home',
                      index: 0,
                    ),
                    _buildNavItem(
                      iconPath: 'assets/icons/journey.svg',
                      title: 'Journey',
                      index: 1,
                    ),
                    _buildNavItem(
                      iconPath: 'assets/icons/quran.svg',
                      title: 'Quran',
                      index: 2,
                    ),
                    // _buildNavItem(
                    //   iconPath: 'assets/icons/resources.svg',
                    //   title: 'Resources',
                    //   index: 3,
                    // ),
                    _buildNavItem(
                      iconPath: 'assets/icons/profile.svg',
                      title: 'Profile',
                      index: 3,
                    ),
                  ],
                ),
              ),
              // Logout Button
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                child: GradientPillButton(
                  text: 'Logout',
                  icon: Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 25,
                  ),
                  onPressed: () async {
                    final authService = Get.find<AuthService>();
                    await authService.signOut();
                    Get.offAllNamed('/home');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String title,
    required int index,
    bool isLogout = false,
  }) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isLogout
                  ? Colors.red.withOpacity(0.8)
                  : isSelected
                  ? const Color(0xFF1EAEDB)
                  : const Color(0xFF1EAEDB).withOpacity(0.6),
              BlendMode.srcIn,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isLogout
                  ? Colors.red.withOpacity(0.8)
                  : isSelected
                  ? Colors.white
                  : Colors.white.withOpacity(0.6),
              fontSize: 16,
            ),
          ),
          onTap: () {
            if (isLogout) {
              Get.offAllNamed('/home');
            } else if (index == 2) {
              Get.to(() => const QuranView());
            } else {
              controller.selectIndex(index);
              Get.back(); // Close drawer after selection
            }
          },
        ),
      );
    });
  }

  Widget _buildContent() {
    switch (controller.selectedIndex.value) {
      case 0:
        return const HomeContent();
      case 1:
        return const Center(
          child: Text('Journey View', style: TextStyle(color: Colors.white)),
        );
      case 2:
        return const Center(
          child: Text(
            'Quran View Content',
            style: TextStyle(color: Colors.white),
          ),
        );
      case 3:
        return const Center(
          child: Text('Resources View', style: TextStyle(color: Colors.white)),
        );
      case 4:
        return const Center(
          child: Text('Profile View', style: TextStyle(color: Colors.white)),
        );
      default:
        return const Center(
          child: Text('Home View', style: TextStyle(color: Colors.white)),
        );
    }
  }
}

// HomeContent widget for the Home menu item
class HomeContent extends GetView<DashboardController> {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {
        'icon': 'assets/icons/compass.svg',
        'title': 'Self-Reflection & Understanding',
        'desc': 'Reflect on your core identity and values.',
        'quote': 'He who knows himself knows his Lord. — Islamic Tradition',
        'sub_steps': [
          {
            'question': 'What are your deepest values?',
            'prompts': [
              'Reflect on your true self.',
              'Describe your inner struggles and breakthroughs.',
              'How have you changed over time?',
            ],
          },
          {
            'question': 'What kind of person do you aspire to be?',
            'prompts': [
              'Reflect on your true self.',
              'Describe your inner struggles and breakthroughs.',
              'How have you changed over time?',
            ],
          },
          {
            'question': 'What experiences have shaped your thinking or growth?',
            'prompts': [
              'Reflect on your true self.',
              'Describe your inner struggles and breakthroughs.',
              'How have you changed over time?',
            ],
          },
          {
            'question': 'What do you fear? What gives you peace?',
            'prompts': [
              'Reflect on your true self.',
              'Describe your inner struggles and breakthroughs.',
              'How have you changed over time?',
            ],
          },
          {
            'question':
                'Are there recurring patterns in your thoughts/behaviors?',
            'prompts': [
              'Reflect on your true self.',
              'Describe your inner struggles and breakthroughs.',
              'How have you changed over time?',
            ],
          },
        ],
      },
      {
        'icon': 'assets/icons/signs.svg',
        'title': 'Divine Signs & Guidance',
        'desc':
            'Recognize spiritual signals, intuition, and meaningful moments.',
        'quote':
            'We will show them Our signs in the horizons and within themselves. — Qur\'an 41:53',
        'sub_steps': [
          {
            'question':
                'Have there been moments where life felt like it was pointing you somewhere?',
            'prompts': [
              'Journal about divine timing moments.',
              'Reflect on prayers and answers received.',
              'Notable people who shifted your path.',
            ],
          },
          {
            'question':
                'Do you believe in a higher power? How do you connect with it?',
            'prompts': [
              'Journal about divine timing moments.',
              'Reflect on prayers and answers received.',
              'Notable people who shifted your path.',
            ],
          },
          {
            'question':
                'What spiritual moments or dreams have stayed with you?',
            'prompts': [
              'Journal about divine timing moments.',
              'Reflect on prayers and answers received.',
              'Notable people who shifted your path.',
            ],
          },
          {
            'question': 'Have there been "meant to be" events?',
            'prompts': [
              'Journal about divine timing moments.',
              'Reflect on prayers and answers received.',
              'Notable people who shifted your path.',
            ],
          },
        ],
      },
      {
        'icon': 'assets/icons/talents.svg',
        'title': 'Talents & Blessings',
        'desc': 'Discover the unique strengths and skills you possess.',
        'quote':
            'Every one of you is a shepherd and is responsible for his flock. — Prophet Muhammad ﷺ',
        'sub_steps': [
          {
            'question': 'What skills come naturally to you?',
            'prompts': [
              'Think about practical skills and soft qualities.',
              'Proud contributions or feedback received.',
              'Repeated compliments you get.',
            ],
          },
          {
            'question': 'What do others appreciate in you?',
            'prompts': [
              'Think about practical skills and soft qualities.',
              'Proud contributions or feedback received.',
              'Repeated compliments you get.',
            ],
          },
          {
            'question': 'When do you feel most "in flow"?',
            'prompts': [
              'Think about practical skills and soft qualities.',
              'Proud contributions or feedback received.',
              'Repeated compliments you get.',
            ],
          },
          {
            'question': 'What were you good at even as a child?',
            'prompts': [
              'Think about practical skills and soft qualities.',
              'Proud contributions or feedback received.',
              'Repeated compliments you get.',
            ],
          },
        ],
      },
      {
        'icon': 'assets/icons/purpose.svg',
        'title': 'Service & Purpose',
        'desc': 'How your unique gifts can create meaning and serve others.',
        'quote':
            'The best of people are those who benefit others. — Prophet Muhammad ﷺ',
        'sub_steps': [
          {
            'question': 'Who do you feel called to help?',
            'prompts': [
              'Share real stories of helping others.',
              'Visualize a purposeful "ideal day".',
              'Communities or causes that call you.',
            ],
          },
          {
            'question': 'What injustice or need deeply moves you?',
            'prompts': [
              'Share real stories of helping others.',
              'Visualize a purposeful "ideal day".',
              'Communities or causes that call you.',
            ],
          },
          {
            'question': 'What would a fulfilling life of service look like?',
            'prompts': [
              'Share real stories of helping others.',
              'Visualize a purposeful "ideal day".',
              'Communities or causes that call you.',
            ],
          },
          {
            'question': 'What legacy do you want to leave?',
            'prompts': [
              'Share real stories of helping others.',
              'Visualize a purposeful "ideal day".',
              'Communities or causes that call you.',
            ],
          },
        ],
      },
    ];

    final buttonLabels = [
      'Continue to First step',
      'Continue to Second step',
      'Continue to Third step',
      'Continue to Final step',
      'Review your Journey',
    ];

    return Center(
      child: Obx(
        () => Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50.0,
                vertical: 26.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Find your purpose',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'There are four steps on the path',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  // Stepper
                  _VerticalStepper(steps: steps),
                  const SizedBox(height: 36),
                  // Continue Button
                  if (controller.currentMainStep.value < steps.length)
                    GradientPillButton(
                      text: buttonLabels[controller.currentMainStep.value],
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        controller.openStepModal();
                      },
                    )
                  else if (controller.currentMainStep.value == steps.length)
                    GradientPillButton(
                      text: 'Get Response',
                      icon: const Icon(
                        Icons.auto_awesome,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        controller.processCompleteJourney();
                      },
                    )
                  else
                    GradientPillButton(
                      text: 'Begin the first step',
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        controller.resetJourney();
                      },
                    ),
                ],
              ),
            ),
            if (controller.showStepModal.value)
              StepModal(
                step: steps[controller.currentMainStep.value],
                totalSteps: steps.length,
                onClose: () => controller.closeStepModal(),
              ),
          ],
        ),
      ),
    );
  }
}

class _VerticalStepper extends GetView<DashboardController> {
  final List<Map<String, dynamic>> steps;
  const _VerticalStepper({required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (i) {
        return Obx(() {
          final isCompleted = i < controller.currentMainStep.value;
          final isActive = i == controller.currentMainStep.value;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Step indicator and line
              Column(
                children: [
                  _StepCircle(
                    number: (i + 1).toString(),
                    active: isActive,
                    completed: isCompleted,
                  ),
                  if (i < steps.length - 1)
                    Container(
                      width: 2,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            isActive || isCompleted
                                ? const Color(0xFF1EAEDB)
                                : Colors.white.withOpacity(0.15),
                            isCompleted
                                ? const Color(0xFF1EAEDB)
                                : Colors.white.withOpacity(0.08),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 20),
              // Step content
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withOpacity(0.04)
                        : Colors.white.withOpacity(0.02),
                    border: Border.all(
                      color: isActive
                          ? const Color(0xFF1EAEDB).withOpacity(0.5)
                          : Colors.white.withOpacity(0.08),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: const Color(0xFF1EAEDB).withOpacity(0.18),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[i]['title']!,
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.w600,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        steps[i]['desc']!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
      }),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final String number;
  final bool active;
  final bool completed;

  const _StepCircle({
    required this.number,
    required this.active,
    this.completed = false,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = completed
        ? BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF1EAEDB),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1EAEDB).withOpacity(0.45),
                blurRadius: 16,
                spreadRadius: 1,
              ),
            ],
          )
        : BoxDecoration(
            shape: BoxShape.circle,
            gradient: active
                ? const LinearGradient(
                    colors: [Color(0xFF1EAEDB), Color(0xFF47BFFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: active ? null : Colors.white.withOpacity(0.08),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: const Color(0xFF1EAEDB).withOpacity(0.45),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ]
                : [],
            border: Border.all(
              color: active
                  ? const Color(0xFF1EAEDB)
                  : Colors.white.withOpacity(0.18),
              width: 2,
            ),
          );

    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: decoration,
      child: completed
          ? const Icon(Icons.check, color: Colors.white, size: 22)
          : Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
    );
  }
}

class StepModal extends GetView<DashboardController> {
  final Map<String, dynamic> step;
  final VoidCallback onClose;
  final int totalSteps;

  const StepModal({
    required this.step,
    required this.onClose,
    required this.totalSteps,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final subSteps = (step['sub_steps'] as List?) ?? [];
    final totalSubSteps = subSteps.length;

    return Obx(() {
      // Ensure we have valid sub-steps and current sub-step index
      final currentSubStepIndex = controller.currentSubStep.value.clamp(
        0,
        totalSubSteps - 1,
      );
      final currentSubStepData = totalSubSteps > 0
          ? subSteps[currentSubStepIndex]
          : step;

      final question = currentSubStepData['question'] ?? '';
      final prompts = (currentSubStepData['prompts'] as List? ?? []);
      final isFirstSubStep = currentSubStepIndex == 0;
      final isLastSubStep = currentSubStepIndex == totalSubSteps - 1;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF233057), Color(0xFF1A2237)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF8B5CF6).withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: const Color.fromRGBO(15, 23, 42, 0.3),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top icon
                Container(
                  width: 64,
                  height: 64,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8B5CF6), Color(0xFFC026D3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      step['icon'] ?? 'assets/icons/compass.svg',
                      width: 32,
                      height: 32,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                // Title
                Text(
                  step['title'] ?? '',
                  style: GoogleFonts.playfairDisplay(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Description
                Text(
                  step['desc'] ?? '',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Quote
                Text(
                  step['quote'] ?? '',
                  style: TextStyle(
                    color: const Color(0xFFB983FF),
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // Sub-step indicator (if there are multiple sub-steps)
                if (totalSubSteps > 1) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Question ${currentSubStepIndex + 1} of $totalSubSteps',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: Column(
                    key: ValueKey<int>(currentSubStepIndex),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          question,
                          style: GoogleFonts.playfairDisplay(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Textarea
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF17213A),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.18),
                          ),
                        ),
                        child: TextField(
                          controller: controller.textEditingController,
                          minLines: 3,
                          maxLines: 5,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Write your thoughts here...',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 18),
                      // Reflective prompts
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF23204A).withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF8B5CF6).withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.auto_awesome,
                                  color: Color(0xFF8B5CF6),
                                  size: 22,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Reflective prompts',
                                  style: GoogleFonts.playfairDisplay(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...List.generate(prompts.length, (i) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 6),
                                      width: 7,
                                      height: 7,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF33C3F0),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        prompts[i],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Pagination indicator
                const SizedBox(height: 18),
                if (totalSubSteps > 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(totalSubSteps, (i) {
                      final bool isActive = i == currentSubStepIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isActive ? 22 : 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF33C3F0)
                              : Colors.white.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),
                const SizedBox(height: 22),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: isFirstSubStep
                          ? null
                          : () => controller.previousSubStep(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Previous'),
                    ),
                    GradientPillButton(
                      text: isLastSubStep ? 'Finish Step' : 'Continue',
                      onPressed: () =>
                          controller.nextSubStep(totalSubSteps, totalSteps),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Back to all steps
                TextButton(
                  onPressed: onClose,
                  child: const Text(
                    '← Back to all steps',
                    style: TextStyle(color: Colors.white54, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
