import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:ghlapp/app/app_routes.dart';
import 'package:ghlapp/providers/mixin/bottomNav_mixin.dart';
import 'package:ghlapp/providers/mixin/get_detail_mixin.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class ProfileProvider extends ChangeNotifier
    with GetDetailMixin, BottomNavigationMixin {
  String? frontAadhaarPath;
  String? backAadhaarPath;
  String? panCardPath;
  String? bankDocPath;
  String? nomineeFrontPath;
  String? nomineeBackPath;
  String? cmlReport;

  bool isAadhaarUploaded = false;
  bool isPanUploaded = false;
  bool isBankUploaded = false;
  bool isNomineeUploaded = false;
  bool isCMLUploaded = false;

  Future<String?> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );
    if (result != null && result.files.single.path != null) {
      return result.files.single.path!;
    }
    return null;
  }

  Future<File?> compressFile(File file) async {
    final ext = path.extension(file.path).toLowerCase();
    if (ext == ".pdf") {
      return file;
    }

    final dir = await getTemporaryDirectory();
    final targetPath = path.join(
      dir.absolute.path,
      "${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}",
    );

    final XFile? result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70,
      minWidth: 1080,
      minHeight: 1080,
      format: CompressFormat.jpeg,
    );

    return result != null ? File(result.path) : file;
  }

  Future<void> pickFrontAadhaar() async {
    final path = await _pickFile();
    if (path != null) {
      frontAadhaarPath = path;
      notifyListeners();
    }
  }

  Future<void> pickBackAadhaar() async {
    final path = await _pickFile();
    if (path != null) {
      backAadhaarPath = path;
      notifyListeners();
    }
  }

  Future<void> pickPanCard() async {
    final path = await _pickFile();
    if (path != null) {
      panCardPath = path;
      notifyListeners();
    }
  }

  Future<void> pickCMLReport() async {
    final path = await _pickFile();
    if (path != null) {
      cmlReport = path;
      notifyListeners();
    }
  }

  Future<void> pickBankDoc() async {
    final path = await _pickFile();
    if (path != null) {
      bankDocPath = path;
      notifyListeners();
    }
  }

  Future<void> pickNomineeFront() async {
    final path = await _pickFile();
    if (path != null) {
      nomineeFrontPath = path;
      notifyListeners();
    }
  }

  Future<void> pickNomineeBack() async {
    final path = await _pickFile();
    if (path != null) {
      nomineeBackPath = path;
      notifyListeners();
    }
  }

  void resetAadhaar() {
    frontAadhaarPath = null;
    backAadhaarPath = null;
    isAadhaarUploaded = false;
    notifyListeners();
  }

  void resetPan() {
    panCardPath = null;
    isPanUploaded = false;
    notifyListeners();
  }

  void resetCMLReport() {
    cmlReport = null;
    isCMLUploaded = false;
    notifyListeners();
  }

  void resetBank() {
    bankDocPath = null;
    isBankUploaded = false;
    notifyListeners();
  }

  void resetNominee() {
    nomineeFrontPath = null;
    nomineeBackPath = null;
    isNomineeUploaded = false;
    notifyListeners();
  }

  bool hasUploaded(String title) {
    if (title == AppStrings.aadharCard) {
      return frontAadhaarPath != null || backAadhaarPath != null;
    } else if (title == AppStrings.panCard) {
      return panCardPath != null;
    } else if (title == AppStrings.bankDocuments) {
      return bankDocPath != null;
    } else if (title == AppStrings.nomineeDocuments) {
      return nomineeFrontPath != null || nomineeBackPath != null;
    } else if (title == AppStrings.cmlReport) {
      return cmlReport != null;
    }
    return false;
  }

  Future<void> uploadDocuments(context, String title) async {
    final uri = Uri.parse("${AppStrings.baseURL}upload/documents");
    final request = http.MultipartRequest("POST", uri);
    if (title == AppStrings.aadharCard) {
      if (frontAadhaarPath != null) {
        final compressed = await compressFile(File(frontAadhaarPath!));
        if (compressed != null) {
          request.files.add(
            await http.MultipartFile.fromPath("aadhaar_front", compressed.path),
          );
        }
      }
      if (backAadhaarPath != null) {
        final compressed = await compressFile(File(backAadhaarPath!));
        if (compressed != null) {
          request.files.add(
            await http.MultipartFile.fromPath("aadhaar_back", compressed.path),
          );
        }
      }
    }
    if (title == AppStrings.panCard) {
      if (panCardPath != null) {
        final compressed = await compressFile(File(panCardPath!));
        if (compressed != null) {
          request.files.add(
            await http.MultipartFile.fromPath("pan_image", compressed.path),
          );
        }
      }
    }
    if (title == AppStrings.bankDocuments) {
      if (bankDocPath != null) {
        final compressed = await compressFile(File(bankDocPath!));
        if (compressed != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              "passbook_image",
              compressed.path,
            ),
          );
        }
      }
    }
    if (title == AppStrings.nomineeDocuments) {
      if (nomineeFrontPath != null) {
        final compressed = await compressFile(File(nomineeFrontPath!));
        if (compressed != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              "nominee_aadhaar_front",
              compressed.path,
            ),
          );
        }
      }
      if (nomineeBackPath != null) {
        final compressed = await compressFile(File(nomineeBackPath!));
        if (compressed != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              "nominee_aadhaar_back",
              compressed.path,
            ),
          );
        }
      }
    }
    if (title == AppStrings.cmlReport) {
      if (cmlReport != null) {
        final compressed = await compressFile(File(cmlReport!));
        if (compressed != null) {
          request.files.add(
            await http.MultipartFile.fromPath("cdslproof", compressed.path),
          );
        }
      }
    }
    request.headers.addAll({
      "Accept": "application/json",
      "Authorization": "Bearer $authToken",
    });
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      AppSnackBar.show(
        context,
        message: "$title uploaded successfully",
        backgroundColor: AppColors.greenCircleColor,
      );
      if (title == AppStrings.aadharCard) isAadhaarUploaded = true;
      if (title == AppStrings.panCard) isPanUploaded = true;
      if (title == AppStrings.bankDocuments) isBankUploaded = true;
      if (title == AppStrings.nomineeDocuments) isNomineeUploaded = true;
      if (title == AppStrings.cmlReport) isCMLUploaded = true;
      notifyListeners();
    } else {
      AppSnackBar.show(context, message: "Error uploading $title");
      debugPrint("Response Body: $responseBody");
    }
  }

  Future getDocuments(context) async {
    final url = Uri.parse("${AppStrings.baseURL}kyc/image");
    try {
      final request = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );
      final data = jsonDecode(request.body);
      if (request.statusCode == 200) {
        frontAadhaarPath = data["aadhaar_front_image"] ?? "";
        backAadhaarPath = data["aadhaar_back_image"] ?? "";
        panCardPath = data["pan_image"] ?? "";
        bankDocPath = data["passbook_image"] ?? "";
        nomineeFrontPath = data["nominee_aadhaar_fimage"] ?? "";
        nomineeBackPath = data["nominee_aadhaar_bimage"] ?? "";
        isAadhaarUploaded =
            frontAadhaarPath!.isNotEmpty || backAadhaarPath!.isNotEmpty;
        isPanUploaded = panCardPath!.isNotEmpty;
        isBankUploaded = bankDocPath!.isNotEmpty;
        isNomineeUploaded =
            nomineeFrontPath!.isNotEmpty || nomineeBackPath!.isNotEmpty;
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: data["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  void logOut(context) async {
    final url = Uri.parse("${AppStrings.baseURL}logout");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode({"device_id": authToken}),
      );
      final res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        AppSnackBar.show(
          context,
          message: res["message"],
          backgroundColor: AppColors.greenCircleColor,
        );
        await clearToken();
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRouteEnum.splash.name,
          (route) => false,
        );
      } else {
        AppSnackBar.show(context, message: res["message"]);
        return null;
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
      return null;
    }
  }

  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("auth_token");
    authToken = "";
    userName = "";
  }
}
