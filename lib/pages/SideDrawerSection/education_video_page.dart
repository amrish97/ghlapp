import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/video_player.dart';
import 'package:provider/provider.dart';

class EducationalVideoPage extends StatelessWidget {
  const EducationalVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, value, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              forceMaterialTransparency: true,
              automaticallyImplyLeading: false,
              backgroundColor: AppColors.screenBgColor,
              flexibleSpace: Padding(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 40),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.black,
                        size: 20,
                      ),
                    ).toGesture(
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 10),
                    PrimaryText(
                      text: "Educational Videos",
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize16,
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.screenBgColor,
          body: ListView.builder(
            itemCount: value.educationalVideo.length,
            itemBuilder: (context, index) {
              final videoIndex = value.educationalVideo[index];
              if (kDebugMode) {
                debugPrint("data--->>> ${videoIndex["y_link"]}");
              }
              return Container(
                height: 250,
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(color: AppColors.white),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        videoIndex["uploadfiles_url"] ?? "",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                    VideoPlayerScreen(
                      videoUrl:
                          videoIndex["y_link"] ??
                          "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
