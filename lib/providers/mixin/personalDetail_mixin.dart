import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

mixin PersonalDetailMixin on ChangeNotifier {
  final TextEditingController personalDetailNameController =
      TextEditingController();
  final TextEditingController personalDetailEmailController =
      TextEditingController();
  final TextEditingController personalDetailAddressController =
      TextEditingController();
  final TextEditingController personalDetailPinCodeController =
      TextEditingController();
  final TextEditingController personalDetailCityController =
      TextEditingController();
  final TextEditingController personalDetailLandMarkController =
      TextEditingController();

  final FocusNode personalDetailNameFocus = FocusNode();
  final FocusNode personalDetailEmailFocus = FocusNode();
  final FocusNode personalDetailAddressFocus = FocusNode();
  final FocusNode personalDetailPinCodeFocus = FocusNode();
  final FocusNode personalDetailCityFocus = FocusNode();
  final FocusNode personalDetailLandMarkFocus = FocusNode();

  String? filePathProfile;

  Future<String?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );
    if (result != null && result.files.single.path != null) {
      return result.files.single.path!;
    }
    return null;
  }

  Future<void> pickProfile() async {
    final path = await _pickFile();
    if (path != null) {
      filePathProfile = path;
      notifyListeners();
    }
  }

  Future<void> sendPersonalDetail(context, String profilePath) async {
    final url = Uri.parse("${AppStrings.baseURL}personal-details");
    try {
      var request = http.MultipartRequest("POST", url);
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      });
      request.fields.addAll({
        "name": personalDetailNameController.text,
        "email": personalDetailEmailController.text,
        "c_address": personalDetailAddressController.text,
        "pincode": personalDetailPinCodeController.text,
        "city": personalDetailCityController.text,
        "landmark": personalDetailLandMarkController.text,
      });
      if (profilePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath("profile_img", profilePath),
        );
      }
      print("Request Fields: ${request.fields}");
      var response = await request.send();
      final res = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        AppSnackBar.show(
          context,
          message: "Personal Detail Updated Successfully",
          backgroundColor: AppColors.greenCircleColor,
        );
        clearData();
        Navigator.pop(context);
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: res);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  clearData() {
    personalDetailNameController.clear();
    personalDetailEmailController.clear();
    personalDetailAddressController.clear();
    personalDetailPinCodeController.clear();
    personalDetailCityController.clear();
    personalDetailLandMarkController.clear();
  }
}
