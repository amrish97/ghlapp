import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ghlapp/providers/home_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/utils/extension/extension.dart';
import 'package:ghlapp/widgets/custom_button.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:ghlapp/widgets/custom_textField.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class ContactUsPage extends StatelessWidget {
  ContactUsPage({super.key});

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
              centerTitle: true,
              title: PrimaryText(
                text: "Contact Us",
                color: AppColors.black,
                weight: AppFont.semiBold,
                size: AppDimen.textSize18,
              ),
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
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: AppColors.screenBgColor,
          body: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: "Need assistance? please fill the form",
                    color: AppColors.black,
                    weight: AppFont.semiBold,
                    size: AppDimen.textSize14,
                    align: TextAlign.start,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    label: "Name",
                    controller: value.contactusNameController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    label: "Email Address",
                    controller: value.contactusEmailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    label: "Phone Number",
                    keyboardType: TextInputType.phone,
                    controller: value.contactusPhoneNumberController,
                  ),
                  SizedBox(height: 20),
                  CustomTextFormField(
                    label: "Write a Message",
                    maxLines: 6,
                    controller: value.contactusMessageController,
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: 30),
                  CustomButton(
                    text: "Send Message",
                    onTap: () {
                      value.contactUs(context);
                    },
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    height: 140,
                    child: FlutterMap(
                      mapController: value.mapController,
                      options: MapOptions(
                        initialCenter: LatLng(
                          13.06850895691521,
                          80.2570368785595,
                        ),
                        initialZoom: 13.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.ghlapp',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                13.06850895691521,
                                80.2570368785595,
                              ),
                              width: 50,
                              height: 50,
                              child: Icon(
                                Icons.location_on,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: PrimaryText(
                          text: value.address,
                          align: TextAlign.start,
                          size: AppDimen.textSize14,
                          maxLines: 5,
                          weight: AppFont.semiBold,
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  final marker = Marker(
    point: LatLng(13.06850895691521, 80.2570368785595),
    width: 50,
    height: 50,
    child: Icon(Icons.location_on, color: AppColors.primary),
  );
}
