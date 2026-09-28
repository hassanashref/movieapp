import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movieapp/core/routes/app_route_name.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/widgets/custom_btn.dart';
import 'package:provider/provider.dart';

import '../manger/auth_provider.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Consumer<AuthProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (Navigator.canPop(context)) {
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    AppRouteName.loginScreen,
                                  );
                                }
                              },
                              child: const Icon(
                                Icons.arrow_back,
                                color: AppColors.primary,
                              ),
                            ),
                            const Expanded(
                              child: Center(
                                child: Text(
                                  "Forget Password",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 24), // Balance back icon
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Center(
                          child: Image.asset(
                            "assets/images/Forgot password-bro 1.png",
                            height: 320.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        TextFormField(
                          controller: provider.emailController,
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            final bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                            ).hasMatch(value ?? "");

                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your email";
                            } else if (!emailValid) {
                              return "Please enter a valid email address";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: SvgPicture.asset(
                                "assets/icone/email.svg",
                                width: 30.w,
                                height: 25.h,
                              ),
                            ),
                            hintText: "Email",
                            hintStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: AppColors.primary),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: AppColors.primary),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Colors.red),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: AppColors.primary),
                            ),
                          ),
                        ),
                        SizedBox(height: 38.h),
                        provider.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              )
                            : CustomBtn(
                                title: 'Verify Email',
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    provider.resetPassword(context: context);
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
