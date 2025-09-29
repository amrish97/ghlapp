import 'package:flutter/material.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/commonWidgets.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/video_player.dart';
import 'package:provider/provider.dart';

class EducationalVideoPage extends StatefulWidget {
  const EducationalVideoPage({super.key});

  @override
  State<EducationalVideoPage> createState() => _EducationalVideoPageState();
}

class _EducationalVideoPageState extends State<EducationalVideoPage> {
  @override
  void initState() {
    context.read<HomeProvider>().getEducationVideo(context);
    super.initState();
  }

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
                    getBackButton(context),
                    SizedBox(width: 10),
                    PrimaryText(
                      text: AppStrings.educationVideo,
                      weight: AppFont.semiBold,
                      size: AppDimen.textSize16,
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.screenBgColor,
          body:
              value.educationalVideo.isEmpty
                  ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  )
                  : ListView.builder(
                    itemCount: value.educationalVideo.length,
                    itemBuilder: (context, index) {
                      final videoIndex = value.educationalVideo[index];
                      return Container(
                        height: 250,
                        margin: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(color: AppColors.white),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: YoutubeVideoPlayer(url: videoIndex["link"]),
                        ),
                      );
                    },
                  ),
        );
      },
    );
  }
}
