import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';


class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final String email = value?.trim() ?? '';

    if (email.isEmpty) {
      return 'Email is required';
    }

    final RegExp emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return 'Enter a valid email';
    }

    return null;
  }

  void _verifyEmail() {
    FocusScope.of(context).unfocus();

    final bool isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email is valid',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.field,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double width = constraints.maxWidth;
            final double scale = width / 393.0;

            return SingleChildScrollView(
              keyboardDismissBehavior:
              ScrollViewKeyboardDismissBehavior.onDrag,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 18 * scale,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 8 * scale),

                      SizedBox(
                        height: 40 * scale,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 45 * scale,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: AppColors.yellow,
                                  size: 28 * scale,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Center(
                                child: Text(
                                  'Forget Password',
                                  style: TextStyle(
                                    color: AppColors.yellow,
                                    fontSize: 22 * scale,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 45 * scale),
                          ],
                        ),
                      ),

                      SizedBox(height: 40 * scale),

                      SizedBox(
                        width: 300 * scale,
                        height: 300 * scale,
                        child: Image.asset(
                          'assets/images/reset_password_illustration.png',
                          fit: BoxFit.contain,
                          errorBuilder: (
                              context,
                              error,
                              stackTrace,
                              ) {
                            return const Center(
                              child: Icon(
                                Icons.lock_reset_rounded,
                                color: AppColors.yellow,
                                size: 120,
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 45 * scale),

                      TextFormField(
                        controller: _emailController,
                        validator: _validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        autovalidateMode:
                        AutovalidateMode.onUserInteraction,
                        onFieldSubmitted: (_) {
                          _verifyEmail();
                        },
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.5 * scale,
                        ),
                        cursorColor: AppColors.yellow,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.field,
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16.5 * scale,
                            fontWeight: FontWeight.w400,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Colors.white,
                            size: 25 * scale,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 15 * scale,
                            vertical: 15 * scale,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(14 * scale),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(14 * scale),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(14 * scale),
                            borderSide: const BorderSide(
                              color: AppColors.yellow,
                              width: 1,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(14 * scale),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.circular(14 * scale),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1,
                            ),
                          ),
                          errorStyle: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 12 * scale,
                          ),
                        ),
                      ),

                      SizedBox(height: 24 * scale),

                      SizedBox(
                        width: double.infinity,
                        height: 52 * scale,
                        child: ElevatedButton(
                          onPressed: _verifyEmail,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.yellow,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(14 * scale),
                            ),
                          ),
                          child: Text(
                            'Verify Email',
                            style: TextStyle(
                              fontSize: 17 * scale,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 30 * scale),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}