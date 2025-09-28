import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:sabeelapp/core/auth_service.dart';
import 'package:sabeelapp/presentation/widgets/glow_pulse_logo.dart';
import 'package:sabeelapp/presentation/widgets/gradient_action_button.dart';
import 'package:sabeelapp/presentation/widgets/custom_particles_background.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

enum OnboardingStep { splash, question1, question2, question3, signup }

class _OnboardingViewState extends State<OnboardingView> {
  OnboardingStep _currentStep = OnboardingStep.splash;
  int? _selectedOption1;
  int? _selectedOption2;
  int? _selectedOption3;
  int _signupTabIndex = 0;

  // Controllers for sign-up form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Auth service instance
  final AuthService _authService = Get.find<AuthService>();

  // State variables
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Splash screen for 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _currentStep = OnboardingStep.question1;
      });
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToNextStep() {
    setState(() {
      switch (_currentStep) {
        case OnboardingStep.splash:
          _currentStep = OnboardingStep.question1;
          break;
        case OnboardingStep.question1:
          _currentStep = OnboardingStep.question2;
          break;
        case OnboardingStep.question2:
          _currentStep = OnboardingStep.question3;
          break;
        case OnboardingStep.question3:
          _currentStep = OnboardingStep.signup;
          break;
        case OnboardingStep.signup:
          break;
      }
    });
  }

  void _goToPreviousStep() {
    switch (_currentStep) {
      case OnboardingStep.question1:
        // Navigate back to home view when on first question
        Get.offAllNamed('/home');
        break;
      case OnboardingStep.question2:
        setState(() {
          _currentStep = OnboardingStep.question1;
        });
        break;
      case OnboardingStep.question3:
        setState(() {
          _currentStep = OnboardingStep.question2;
        });
        break;
      case OnboardingStep.signup:
        setState(() {
          _currentStep = OnboardingStep.question3;
        });
        break;
      case OnboardingStep.splash:
        // Navigate back to home view when on splash
        Get.offAllNamed('/home');
        break;
    }
  }

  Future<void> _signUp() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final success = await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text,
        displayName: _nameController.text.trim(),
      );

      if (success) {
        // Success - navigate to dashboard
        Get.offAllNamed('/dashboard');
      } else {
        setState(() {
          _errorMessage = 'Registration failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signIn() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final success = await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        // Success - navigate to dashboard
        Get.offAllNamed('/dashboard');
      } else {
        setState(() {
          _errorMessage =
              'Sign in failed. Please check your credentials and try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSplash() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GlowPulseLogo(size: 80),
          const SizedBox(height: 32),
          const Text(
            'Welcome to Sabeel',
            style: TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'A Journey to Discover Your Divine Purpose',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion({
    required String question,
    required List<String> options,
    required int? selectedIndex,
    required void Function(int) onSelect,
    required int step,
    required int totalSteps,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: _goToPreviousStep,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  Center(child: GlowPulseLogo(size: 48)),
                  const SizedBox(height: 16),
                  Text(
                    'Question $step of $totalSteps',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    question,
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ...List.generate(options.length, (i) {
                    final selected = selectedIndex == i;
                    return _OnboardingOption(
                      text: options[i],
                      selected: selected,
                      onTap: () => onSelect(i),
                    );
                  }),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GradientActionButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                        text: 'Skip',
                        onPressed: _goToNextStep,
                      ),
                      // const SizedBox(width: ),
                      GradientActionButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                        text: step == totalSteps ? 'Continue' : 'Next',
                        enabled: selectedIndex != null,
                        onPressed: selectedIndex != null ? _goToNextStep : null,
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignup() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: GlowPulseLogo(size: 48)),
                    const SizedBox(height: 16),

                    // Custom Tab Buttons
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _signupTabIndex = 0;
                                  _errorMessage = '';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: _signupTabIndex == 0
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Create Account',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _signupTabIndex == 0
                                        ? Colors.white
                                        : Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _signupTabIndex = 1;
                                  _errorMessage = '';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  color: _signupTabIndex == 1
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Sign In',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: _signupTabIndex == 1
                                        ? Colors.white
                                        : Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Content based on selected tab
                    _signupTabIndex == 0
                        ? _buildSignUpTab()
                        : _buildSignInTab(),

                    const SizedBox(height: 16),

                    // Back button
                    TextButton(
                      onPressed: _goToPreviousStep,
                      child: const Text(
                        'Back to Questions',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Create Your Account',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Begin your personal spiritual journey',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Your full name',
            filled: true,
            fillColor: Colors.white.withOpacity(0.12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'your@email.com',
            filled: true,
            fillColor: Colors.white.withOpacity(0.12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password (at least 6 characters)',
            filled: true,
            fillColor: Colors.white.withOpacity(0.12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 24),
        if (_errorMessage.isNotEmpty && _signupTabIndex == 0)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1EAEDB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF1EAEDB).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xFF1EAEDB),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Color(0xFF1EAEDB),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        GradientActionButton(
          text: _isLoading ? 'Creating Account...' : 'Begin Your Path',
          onPressed: _isLoading ? null : _signUp,
        ),
      ],
    );
  }

  Widget _buildSignInTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Welcome Back',
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Continue your spiritual journey',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 24),
        // Email Field
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Email',
            labelStyle: const TextStyle(color: Colors.white70),
            hintText: 'your@email.com',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withOpacity(0.12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1EAEDB)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Password Field
        TextField(
          controller: _passwordController,
          obscureText: true,
          textInputAction: TextInputAction.done,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: const TextStyle(color: Colors.white70),
            hintText: '********',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white.withOpacity(0.12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF1EAEDB)),
            ),
            suffixIcon: const Icon(Icons.lock, color: Colors.white38),
          ),
        ),
        const SizedBox(height: 8),
        // Forgot Password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Get.snackbar(
                'Coming Soon',
                'Password reset functionality will be available soon.',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text(
              'Forgot password?',
              style: TextStyle(color: Colors.white54),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Error Message for Sign In
        if (_errorMessage.isNotEmpty && _signupTabIndex == 1)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1EAEDB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF1EAEDB).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: const Color(0xFF1EAEDB),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Color(0xFF1EAEDB),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        // Sign In Button
        GradientActionButton(
          text: _isLoading ? 'Signing In...' : 'Sign In',
          onPressed: _isLoading ? null : _signIn,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF204366),
      body: SafeArea(
        child: Stack(
          children: [
            // Background gradient and particles
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
            Positioned.fill(child: CustomParticlesBackground()),
            if (_currentStep == OnboardingStep.splash) _buildSplash(),
            if (_currentStep == OnboardingStep.question1)
              _buildQuestion(
                question: 'What brings you to your spiritual journey today?',
                options: [
                  'Seeking inner peace and clarity',
                  'Deepening my connection with faith',
                  'Finding purpose and meaning',
                  'Navigating life challenges',
                ],
                selectedIndex: _selectedOption1,
                onSelect: (i) => setState(() => _selectedOption1 = i),
                step: 1,
                totalSteps: 3,
              ),
            if (_currentStep == OnboardingStep.question2)
              _buildQuestion(
                question:
                    'How would you describe your current spiritual practice?',
                options: [
                  'Just beginning to explore',
                  'Occasional practice',
                  'Regular practice but seeking more',
                  'Dedicated, seeking deeper insights',
                ],
                selectedIndex: _selectedOption2,
                onSelect: (i) => setState(() => _selectedOption2 = i),
                step: 2,
                totalSteps: 3,
              ),
            if (_currentStep == OnboardingStep.question3)
              _buildQuestion(
                question: 'What do you hope to achieve through this journey?',
                options: [
                  'Daily spiritual guidance',
                  'Community and connection',
                  'Knowledge and understanding',
                  'Practical application in daily life',
                ],
                selectedIndex: _selectedOption3,
                onSelect: (i) => setState(() => _selectedOption3 = i),
                step: 3,
                totalSteps: 3,
              ),
            if (_currentStep == OnboardingStep.signup)
              Positioned.fill(child: _buildSignup()),
          ],
        ),
      ),
    );
  }
}

class _OnboardingOption extends StatefulWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;
  const _OnboardingOption({
    required this.text,
    required this.selected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<_OnboardingOption> createState() => _OnboardingOptionState();
}

class _OnboardingOptionState extends State<_OnboardingOption> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final bool selected = widget.selected;
    final bool hovering = _hovering;
    Color bgColor = Colors.transparent;
    Color borderColor = Colors.white.withOpacity(0.1);
    List<BoxShadow> boxShadow = [];
    double scale = 1.0;
    Color textColor = Colors.white;

    if (selected) {
      bgColor = Colors.white.withValues(alpha: 0.01);
      borderColor = Colors.white.withOpacity(0.4);
      boxShadow = [
        BoxShadow(
          color: Colors.white.withOpacity(0.3),
          blurRadius: 15,
          spreadRadius: 0,
        ),
      ];
      scale = 1.02;
    } else if (hovering) {
      bgColor = Colors.white.withOpacity(0.1);
      borderColor = Colors.white.withOpacity(0.1);
      scale = 1.02;
    } else {
      bgColor = Colors.white.withOpacity(0.05);
      borderColor = Colors.white.withOpacity(0.1);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(16),
            boxShadow: boxShadow,
          ),
          child: Transform.scale(
            scale: scale,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
