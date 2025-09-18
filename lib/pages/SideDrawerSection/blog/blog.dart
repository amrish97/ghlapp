import 'package:flutter/material.dart';
import 'package:ghlapp/pages/SideDrawerSection/blog/blogdetail_page.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../resources/app_colors.dart';
import '../../../resources/app_dimention.dart';
import '../../../resources/app_font.dart';
import '../../../widgets/custom_text.dart';

class Blog extends StatelessWidget {
  const Blog({super.key});

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
                      text: "Blog",
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
            itemCount: value.blogData.length,
            itemBuilder: (context, index) {
              final data = value.blogData[index];
              String formattedDate = DateFormat(
                'dd/MM/yyyy',
              ).format(DateTime.parse(data["create_date"]));
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(color: AppColors.white),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PrimaryText(
                            text: data["title"],
                            weight: AppFont.semiBold,
                            size: AppDimen.textSize14,
                            align: TextAlign.start,
                          ),
                          SizedBox(height: 5),
                          PrimaryText(
                            text: "Post Date: $formattedDate",
                            weight: AppFont.regular,
                            size: AppDimen.textSize12,
                            color: AppColors.lightGrey,
                            align: TextAlign.start,
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                color: AppColors.primary,
                                size: AppDimen.textSize14,
                              ),
                              SizedBox(width: 5),
                              PrimaryText(
                                text: data["AuthorName"].toString().trim(),
                                weight: AppFont.semiBold,
                                size: AppDimen.textSize12,
                                color: AppColors.primary,
                                align: TextAlign.start,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 140,
                      height: 90,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          data["uploadfiles_url"] ?? "",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
              ).toGesture(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlogDetailPage(blogDetail: data),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
