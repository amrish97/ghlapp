import 'package:flutter/material.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';

mixin BottomNavigationMixin on ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index, BuildContext context, {HomeProvider? value}) {
    if (index == 2) {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        barrierColor: Colors.black54.withAlpha(90),
        pageBuilder: (context, anim1, anim2) {
          final List<Map<String, dynamic>> iconWithTitle = [
            {
              "image": "assets/images/calc.png",
              "title": "Investment Calculator",
              "onTap": () {},
            },
            {
              "image": "assets/images/video.png",
              "title": "Educational Videos",
              "onTap": () {
                print("Educational Videos");
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRouteEnum.educationalVideo.name,
                );
              },
            },
            {
              "image": "assets/images/economy.png",
              "title": "Economy Insights",
              "onTap": () {
                print("Economy Insights");
              },
            },
            {
              "image": "assets/images/finance.png",
              "title": "Financial IQ",
              "onTap": () {
                print("Financial IQ");
              },
            },
            {
              "image": "assets/images/refer.png",
              "title": "Refer & Earn",
              "onTap": () async {
                Navigator.pop(context);
                await value?.getReferralCode(context);
                Navigator.pushNamed(context, AppRouteEnum.referral.name);
              },
            },
          ];
          final size = MediaQuery.of(context).size;
          return Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Positioned(
                  bottom: size.height * 0.09,
                  left: size.width * 0.08,
                  right: size.width * 0.08,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        ...iconWithTitle.asMap().entries.map((element) {
                          print("ele--->> ${element.key}---${element.value}");
                          return getImageTitle(
                            image: element.value["image"],
                            title: element.value["title"],
                            onTap: element.value["onTap"],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  Widget getImageTitle({
    required String image,
    required String title,
    required GestureTapCallback onTap,
  }) {
    return Row(
      children: [
        SizedBox(width: 10),
        image.toImageAsset(),
        SizedBox(width: 10),
        PrimaryText(
          text: title,
          weight: AppFont.semiBold,
          align: TextAlign.start,
          size: AppDimen.textSize14,
        ),
      ],
    ).toGesture(onTap: onTap);
  }
}
