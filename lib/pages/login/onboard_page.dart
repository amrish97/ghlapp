import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/providers/onboard_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<OnBoardProvider>(
      builder: (context, provider, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              App().closeApp();
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.screenBgColor,
            body: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: provider.controller,
                      itemCount: provider.pageData.length,
                      onPageChanged: provider.setPage,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final data = provider.pageData[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(data["image"], fit: BoxFit.contain),
                            const SizedBox(height: 30),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                PrimaryText(
                                  text: data["content"],
                                  color: AppColors.black,
                                  weight: AppFont.semiBold,
                                  size: 24,
                                ),
                                if (index == 0) ...[
                                  const SizedBox(width: 5),
                                  PrimaryText(
                                    text: AppStrings.appName,
                                    color: AppColors.primary,
                                    weight: AppFont.semiBold,
                                    size: 24,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 12),
                            PrimaryText(
                              text: data["subContent"],
                              color: AppColors.black,
                              weight: AppFont.regular,
                              size: 17,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      provider.pageData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        height: 8,
                        width: provider.currentPage == index ? 20 : 8,
                        decoration: BoxDecoration(
                          color:
                              provider.currentPage == index
                                  ? AppColors.primary
                                  : Color(0xFF949494),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    text: "Next",
                    width: MediaQuery.of(context).size.width - 150,
                    onTap: () {
                      if (provider.currentPage == 2) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRouteEnum.login.name,
                        );
                      } else {
                        provider.controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: "Skip",
                    width: MediaQuery.of(context).size.width - 150,
                    color: AppColors.white,
                    showBorderColor: true,
                    onTap: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRouteEnum.login.name,
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
