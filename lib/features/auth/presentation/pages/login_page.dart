import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_logo.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          onLoginSuccess();
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.expense,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // App Icon
                const AppLogo(size: 100),
                const SizedBox(height: 32),
                // Welcome Text
                const Text(
                  'Welcome back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(flex: 1),
                // Google Sign In Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(SignInWithGoogleRequested());
                              },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFE5E5E5)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.textPrimary,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Google Icon
                                  Image.network(
                                    'https://www.google.com/favicon.ico',
                                    width: 24,
                                    height: 24,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const _GoogleIcon();
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    );
                  },
                ),
                const Spacer(flex: 2),
                // Footer Links
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Terms',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Text(
                      '\u2022',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Privacy',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Text(
                      '\u2022',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Help',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: CustomPaint(
        size: const Size(24, 24),
        painter: _GoogleIconPainter(),
      ),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Google "G" icon colors
    final Paint bluePaint = Paint()..color = const Color(0xFF4285F4);
    final Paint greenPaint = Paint()..color = const Color(0xFF34A853);
    final Paint yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final Paint redPaint = Paint()..color = const Color(0xFFEA4335);

    final double centerX = width / 2;
    final double centerY = height / 2;
    final double radius = width * 0.4;

    // Blue arc (right side)
    final Path bluePath = Path();
    bluePath.moveTo(centerX, centerY);
    bluePath.arcTo(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -0.5,
      1.0,
      false,
    );
    bluePath.close();
    canvas.drawPath(bluePath, bluePaint);

    // Green arc (bottom right)
    final Path greenPath = Path();
    greenPath.moveTo(centerX, centerY);
    greenPath.arcTo(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      0.5,
      1.0,
      false,
    );
    greenPath.close();
    canvas.drawPath(greenPath, greenPaint);

    // Yellow arc (bottom left)
    final Path yellowPath = Path();
    yellowPath.moveTo(centerX, centerY);
    yellowPath.arcTo(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      1.5,
      1.0,
      false,
    );
    yellowPath.close();
    canvas.drawPath(yellowPath, yellowPaint);

    // Red arc (top)
    final Path redPath = Path();
    redPath.moveTo(centerX, centerY);
    redPath.arcTo(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      2.5,
      1.0,
      false,
    );
    redPath.close();
    canvas.drawPath(redPath, redPaint);

    // White center
    final Paint whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(centerX, centerY), radius * 0.55, whitePaint);

    // Blue bar
    final Rect blueBar = Rect.fromLTWH(
      centerX,
      centerY - radius * 0.25,
      radius * 0.9,
      radius * 0.5,
    );
    canvas.drawRect(blueBar, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
