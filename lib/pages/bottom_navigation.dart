import 'package:dhlapp/pages/home_page.dart';
import 'package:dhlapp/providers/home_provider.dart';
import 'package:dhlapp/resources/app_colors.dart';
import 'package:dhlapp/resources/app_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  final List<Widget> _pages = [
    HomePage(),
    const Center(child: Text("Search Page")),
    const Center(child: Text("Add Action Page")),
    const Center(child: Text("Portfolio Page")),
    const Center(child: Text("FAQ Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return Scaffold(
          backgroundColor: AppColors.screenBgColor,
          body: _pages[value.selectedIndex],
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: value.selectedIndex,
            backgroundColor: AppColors.white,
            onTap: (index) {
              value.setIndex(index);
            },
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 0,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.black,
            selectedLabelStyle: AppTextStyles.body,
            type: BottomNavigationBarType.fixed,
            unselectedLabelStyle: AppTextStyles.body,
            items: [
              getBottomItem(
                icon: "assets/images/bottom_nav_image/home.png",
                label: "Home",
                index: 0,
                value: value,
              ),
              getBottomItem(
                icon: "assets/images/bottom_nav_image/money.png",
                label: "Investment",
                index: 1,
                value: value,
              ),
              getBottomItem(icon: "", label: "", index: 2, value: value),
              getBottomItem(
                icon: "assets/images/bottom_nav_image/portfolio.png",
                label: "Portfolio",
                index: 3,
                value: value,
              ),
              getBottomItem(
                icon: "assets/images/bottom_nav_image/help.png",
                label: "FAQ",
                index: 4,
                value: value,
              ),
            ],
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
                child: Image.asset(
                  icon,
                  color:
                      value?.selectedIndex == index ? AppColors.primary : null,
                  scale: 3,
                ),
              ),
      label: label,
    );
  }
}
