import 'package:dhlapp/app/app_routes.dart';
import 'package:dhlapp/providers/login_provider.dart';
import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/resources/app_font.dart';
import 'package:dhlapp/widgets/custom_button.dart';
import 'package:dhlapp/widgets/custom_snakebar.dart';
import 'package:dhlapp/widgets/custom_text.dart';
import 'package:dhlapp/widgets/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginProvider>().initLocationCheck();
      context.read<LoginProvider>().initDeviceId();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors.screenBgColor,
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                          ),
                          Image.asset('assets/images/login.png', scale: 3),
                          SizedBox(height: 20),
                          PrimaryText(
                            text: "Enter Your Phone Number",
                            size: 30,
                            weight: FontWeight.bold,
                          ),
                          SizedBox(height: 20),
                          PrimaryText(
                            text:
                                "Lorem ipsum dolor sit amet consectetur. Elementum imperdiet est",
                            size: 16,
                            align: TextAlign.center,
                            weight: AppFont.light,
                            color: AppColors.lightGrey,
                          ),
                          SizedBox(height: 20),
                          CustomTextFormField(
                            label: 'Enter your phone number',
                            isShowPrefixIcon: true,
                            controller: value.phoneNumberController,
                            prefixIcon: "assets/images/Vector.png",
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 20),
                          CustomButton(
                            text: "Send OTP",
                            onTap: () {
                              if (value.phoneNumberController.text.isEmpty) {
                                AppSnackBar.show(
                                  context,
                                  message: 'Please enter a phone number',
                                );
                              } else if (value
                                      .phoneNumberController
                                      .text
                                      .length !=
                                  10) {
                                AppSnackBar.show(
                                  context,
                                  message: 'Please enter valid phone number',
                                );
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  AppRouteEnum.verifyPhone.name,
                                );
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          PrimaryText(
                            text: "Login With",
                            size: 16,
                            weight: AppFont.medium,
                            color: AppColors.lightGrey,
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 60,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.lightGrey.withAlpha(40),
                                  ),
                                  child: Image.asset(
                                    'assets/images/google.png',
                                    scale: 3,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Container(
                                  height: 60,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.lightGrey.withAlpha(40),
                                  ),
                                  child: Image.asset(
                                    'assets/images/facebook.png',
                                    scale: 3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
