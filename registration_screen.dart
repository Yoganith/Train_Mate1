import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import '../widgets/modern_widgets.dart';
import '../services/auth_service.dart';
import '../models/firebase_models.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Form Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() => _currentStep++);
    } else {
      _submitForm();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      try {
        final user = await AuthService.signUpWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _nameController.text.trim(),
          phoneNumber: _mobileController.text.trim().isNotEmpty 
              ? _mobileController.text.trim() 
              : null,
        );
        
        if (user != null) {
          if (mounted) {
            _showSuccessDialog();
          }
        }
      } catch (e) {
        _showErrorSnackBar(e.toString());
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  /// Show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Registration Successful!'),
        content: const Text(
          'Your account has been created successfully. Please check your email to verify your account before signing in.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Continue to Login'),
          ),
        ],
      ),
    );
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
  backgroundColor: Theme.of(context).colorScheme.primary,
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
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Create Account',
                      style: textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Registration Steps Indicator
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: List.generate(3, (index) {
                    final isCompleted = index < _currentStep;
                    final isCurrent = index == _currentStep;
                    return Expanded(
                      child: Container(
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Colors.white
                              : isCurrent
                                  ? Colors.white.withOpacity(0.6)
                                  : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ).animate(target: isCurrent ? 1 : 0).scaleX(),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // Registration Form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Form(
                      key: _formKey,
                      child: GlassCard(
                        child: AnimatedSwitcher(
                          duration: AppTheme.mediumAnimation,
                          child: _buildCurrentStep(colorScheme),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep(ColorScheme colorScheme) {
    switch (_currentStep) {
      case 0:
        return _BasicInfoStep(
          nameController: _nameController,
          emailController: _emailController,
          onNext: _nextStep,
          colorScheme: colorScheme,
        );
      case 1:
        return _ContactInfoStep(
          mobileController: _mobileController,
          onNext: _nextStep,
          onBack: _previousStep,
          colorScheme: colorScheme,
        );
      case 2:
        return _SecurityStep(
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          obscurePassword: _obscurePassword,
          obscureConfirmPassword: _obscureConfirmPassword,
          onTogglePassword: () =>
              setState(() => _obscurePassword = !_obscurePassword),
          onToggleConfirmPassword: () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword),
          onNext: _submitForm,
          onBack: _previousStep,
          isLoading: _isLoading,
          colorScheme: colorScheme,
        );
      default:
        return const SizedBox();
    }
  }
}

class _BasicInfoStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final VoidCallback onNext;
  final ColorScheme colorScheme;

  const _BasicInfoStep({
    required this.nameController,
    required this.emailController,
    required this.onNext,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Basic Information',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _buildFormField(
          controller: nameController,
          label: 'Full Name',
          hint: 'Enter your full name',
          icon: Icons.person_outline,
          colorScheme: colorScheme,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Name is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildFormField(
          controller: emailController,
          label: 'Email Address',
          hint: 'Enter your email address',
          icon: Icons.email_outlined,
          colorScheme: colorScheme,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Email is required';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return 'Enter a valid email address';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: onNext,
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: AppTheme.buttonRadius,
            ),
          ),
          child: Text(
            'Next',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    ).animate().fadeIn();
  }
}

class _ContactInfoStep extends StatelessWidget {
  final TextEditingController mobileController;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final ColorScheme colorScheme;

  const _ContactInfoStep({
    required this.mobileController,
    required this.onNext,
    required this.onBack,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Contact Information',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _buildFormField(
          controller: mobileController,
          label: 'Mobile Number',
          hint: 'Enter your mobile number',
          icon: Icons.phone_outlined,
          colorScheme: colorScheme,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Mobile number is required';
            }
            if (value!.length < 10) {
              return 'Enter a valid mobile number';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.buttonRadius,
                  ),
                ),
                child: Text(
                  'Back',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: onNext,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.buttonRadius,
                  ),
                ),
                child: Text(
                  'Next',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn();
  }
}

class _SecurityStep extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final bool obscureConfirmPassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final bool isLoading;
  final ColorScheme colorScheme;

  const _SecurityStep({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onNext,
    required this.onBack,
    required this.isLoading,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Set Password',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        _buildFormField(
          controller: passwordController,
          label: 'Password',
          hint: 'Create a strong password',
          icon: Icons.lock_outline,
          colorScheme: colorScheme,
          obscureText: obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: onTogglePassword,
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Password is required';
            }
            if (value!.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        _buildFormField(
          controller: confirmPasswordController,
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          icon: Icons.lock_outline,
          colorScheme: colorScheme,
          obscureText: obscureConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: onToggleConfirmPassword,
          ),
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Please confirm your password';
            }
            if (value != passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.buttonRadius,
                  ),
                ),
                child: Text(
                  'Back',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: isLoading ? null : onNext,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.buttonRadius,
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        'Create Account',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn();
  }
}

Widget _buildFormField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  required ColorScheme colorScheme,
  TextInputType? keyboardType,
  bool obscureText = false,
  Widget? suffixIcon,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    style: TextStyle(color: colorScheme.onSurface),
    decoration: InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
      hintStyle:
          TextStyle(color: colorScheme.onSurfaceVariant.withOpacity(0.7)),
      prefixIcon: Icon(icon, color: colorScheme.onSurfaceVariant),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
      border: OutlineInputBorder(
        borderRadius: AppTheme.buttonRadius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppTheme.buttonRadius,
        borderSide: BorderSide(color: colorScheme.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppTheme.buttonRadius,
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppTheme.buttonRadius,
        borderSide: BorderSide(color: colorScheme.error),
      ),
    ),
    validator: validator,
  );
}
