import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

 import 'package:movieapp/core/routes/app_route_name.dart';
import 'package:movieapp/core/theme/app_colors.dart';
import 'package:movieapp/core/widgets/custom_btn.dart';
import 'package:provider/provider.dart';

import '../manger/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = 'LoginScreen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: Scaffold(
        backgroundColor:  AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Consumer<AuthProvider>(
                builder: (context, provider, child) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Hero(
                          tag: "logo",
                          child: Center(
                            child: Image.asset(
                              "assets/images/movie_logo.png",
                              width: 121.w,
                            ),
                          ),
                        ),
                        SizedBox(height: 50.h),

                        // Email Field
                        TextFormField(
                          controller: provider.emailController,
                          keyboardType: TextInputType.emailAddress,
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
                          style: const TextStyle(color: Colors.white),
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
                              borderSide: const BorderSide(color: AppColors.background),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppColors.background),
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
                              borderSide: const BorderSide(color: AppColors.background),
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Password Field
                        TextFormField(
                          controller: provider.passwordController,
                          obscureText: _obscurePassword,
                          obscuringCharacter: "*",
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your password";
                            } else if (value.length < 6) {
                              return "Password must be at least 6 characters";
                            }
                            return null;
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            prefixIcon: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: SvgPicture.asset(
                                "assets/icone/password.svg",
                                width: 30.w,
                                height: 25.h,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: Colors.white70,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            hintText: "Password",
                            hintStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppColors.background),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: AppColors.background),
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
                              borderSide: const BorderSide(color: AppColors.background),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // Forget Password
                        Align(
                          alignment: AlignmentDirectional.centerEnd,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRouteName. forgetpassword,
                              );
                            },
                            child: const Text(
                              "Forget Password ?",
                              style: TextStyle(
                                color:AppColors.primary,
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 36.h),

                        // Login Button
                        CustomBtn(
                          isLoding: provider.isLoading,
                          title: 'Login',
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              provider.login();
                            }
                          },
                        ),
                        SizedBox(height: 20.h),

                        // Create Account Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don’t Have Account ? ",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRouteName.register,
                                );
                              },
                              child: Text(
                                "Create One",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        // Divider OR
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppColors.background,
                                thickness: 1,
                                endIndent: 12.w,
                                indent: 20.w,
                              ),
                            ),
                            Text(
                              "OR",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color:AppColors.background,
                                thickness: 1,
                                indent: 12.w,
                                endIndent: 20.w,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        // Login with Google Button
                        CustomBtn(
                          isLoding: provider.isLoading,
                          icon: SvgPicture.asset(
                            "assets/icone/google.svg",
                            width: 24.w,
                            height: 24.h,
                          ),
                          title: 'Login With Google',
                          onPressed: () {
                            provider.signInWithGoogle();
                          },
                        ),
                        SizedBox(height: 30.h),

                        // Language Switcher
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.r),
                            border: Border.all(
                              color: AppColors.background,
                              width: 2,
                            ),
                          ),

                        ),
                        Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "assets/icone/en.svg",
                                  width: 28.w,
                                  height: 28.h,
                                ),
                                SizedBox(width: 12.w),
                                SvgPicture.asset(
                                  "assets/icone/EG.svg",
                                  width: 28.w,
                                  height: 28.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
