import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  bool isLoading = false;
  bool obscurePassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    emailController.dispose();
    pwdController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (emailController.text.trim().isEmpty || pwdController.text.isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    setState(() => isLoading = true);
    
    try {
      final user = await AuthService.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: pwdController.text,
      );
      
      if (user != null && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _handleForgotPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _showErrorSnackBar('Please enter your email address first');
      return;
    }

    try {
      await AuthService.resetPassword(email);
      _showSuccessSnackBar('Password reset email sent! Check your inbox.');
    } catch (e) {
      _showErrorSnackBar(e.toString());
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        // FIX 1: Removed 'const' from BoxDecoration
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Center(
            // FIX 2: Wrapped with Scrollbar and set thumbVisibility to false
            child: Scrollbar(
              thumbVisibility: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.train,
                            size: 64,
                            color: Colors.white,
                          ),
                        ).animate().scale(delay: 200.ms),
                        
                        const SizedBox(height: 24),
                        
                        Text(
                          'RailBuddy',
                          style: textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate().fadeIn(delay: 400.ms),
                        
                        const SizedBox(height: 8),
                        
                        Text(
                          'Your Smart Travel Companion',
                          style: textTheme.titleMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ).animate().fadeIn(delay: 600.ms),
                        
                        const SizedBox(height: 48),

                        Container(
                          constraints: const BoxConstraints(maxWidth: 400),
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Welcome Back',
                                style: textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ).animate().fadeIn(delay: 800.ms),
                              
                              const SizedBox(height: 32),
                              
                              TextField(
                                controller: emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Mobile / Email',
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.person_outline, color: Colors.white.withOpacity(0.7)),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: Colors.white, width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                  ),
                                ),
                              ).animate().fadeIn(delay: 1000.ms),
                              
                              const SizedBox(height: 20),
                              
                              TextField(
                                controller: pwdController,
                                obscureText: obscurePassword,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                                  prefixIcon: Icon(Icons.lock_outline, color: Colors.white.withOpacity(0.7)),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                    onPressed: () => setState(() => obscurePassword = !obscurePassword),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.1),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: const BorderSide(color: Colors.white, width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                  ),
                                ),
                              ).animate().fadeIn(delay: 1200.ms),
                              
                              const SizedBox(height: 12),
                              
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: _handleForgotPassword,
                                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                                  child: Text(
                                    'Forgot Password?',
                                    style: textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8)),
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 24),
                              
                              FilledButton(
                                onPressed: isLoading ? null : _handleLogin,
                                style: FilledButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      )
                                    : Text(
                                        'Login',
                                        style: textTheme.titleMedium?.copyWith(
                                          color: colorScheme.onPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ).animate().fadeIn(delay: 1400.ms),
                              
                              const SizedBox(height: 24),
                              
                              Row(
                                children: [
                                  Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child: Text(
                                      'Or continue with',
                                      style: textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.7)),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _SocialLoginButton(
                                    icon: Icons.g_mobiledata_rounded,
                                    label: 'Google',
                                    onPressed: () {},
                                  ),
                                  _SocialLoginButton(
                                    icon: Icons.facebook,
                                    label: 'Facebook',
                                    onPressed: () {},
                                  ),
                                ],
                              ).animate().fadeIn(delay: 1600.ms),
                              
                              const SizedBox(height: 24),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Don\'t have an account? ',
                                    style: textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.7)),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pushNamed(context, '/register'),
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: Text(
                                      'Sign Up',
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ).animate().fadeIn(delay: 1800.ms),
                            ],
                          ),
                        ).animate().slideY(delay: 1000.ms),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialLoginButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _SocialLoginButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        side: BorderSide(color: Colors.white.withOpacity(0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white.withOpacity(0.1),
      ),
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}