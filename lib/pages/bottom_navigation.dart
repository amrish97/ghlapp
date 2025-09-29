import 'package:flutter/material.dart';
import 'package:ghlapp/app/app.dart';
import 'package:ghlapp/pages/Investment/investment_page.dart';
import 'package:ghlapp/pages/faq/faq_page.dart';
import 'package:ghlapp/pages/home_page.dart';
import 'package:ghlapp/pages/profile/portfolio/portfolio_page.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_style.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:provider/provider.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  final List<Widget> _pages = [
    const HomePage(),
    const InvestmentPage(),
    const SizedBox.shrink(),
    const PortfolioPage(),
    const FaqPage(),
  ];

  @override
  Widget build(BuildContext context) {
    DateTime? lastBackPress;

    void handleBackPress() {
      final now = DateTime.now();
      if (lastBackPress == null ||
          now.difference(lastBackPress!) > const Duration(seconds: 2)) {
        lastBackPress = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Press back again to exit ${AppStrings.appName}"),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        BaseFunction().closeApp();
      }
    }

    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              handleBackPress();
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.screenBgColor,
            body: _pages[value.selectedIndex],
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: value.selectedIndex,
              backgroundColor: AppColors.white,
              onTap: (index) {
                value.setIndex(index, context, value: value);
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              elevation: 0,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.black,
              selectedLabelStyle: AppTextStyles.selectedTextStyle,
              type: BottomNavigationBarType.fixed,
              unselectedLabelStyle: AppTextStyles.unSelectedTextStyle,
              items: [
                getBottomItem(
                  icon: "assets/images/bottom_nav_image/home.png",
                  label: AppStrings.home,
                  index: 0,
                  value: value,
                ),
                getBottomItem(
                  icon: "assets/images/bottom_nav_image/money.png",
                  label: AppStrings.invest,
                  index: 1,
                  value: value,
                ),
                getBottomItem(icon: "", label: "", index: 2, value: value),
                getBottomItem(
                  icon: "assets/images/bottom_nav_image/portfolio.png",
                  label: AppStrings.portfolio,
                  index: 3,
                  value: value,
                ),
                getBottomItem(
                  icon: "assets/images/bottom_nav_image/help.png",
                  label: AppStrings.faq,
                  index: 4,
                  value: value,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem getBottomItem({
    required String icon,
    required String label,
    int? index,
    HomeProvider? value,
  }) {
    return BottomNavigationBarItem(
      icon:
          icon.isEmpty
              ? Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: const Icon(Icons.add, color: AppColors.white, size: 28),
              )
              : Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: icon.toImageAsset(
                  color:
                      value?.selectedIndex == index
                          ? AppColors.primary
                          : AppColors.black,
                ),
              ),
      label: label,
    );
  }
}
