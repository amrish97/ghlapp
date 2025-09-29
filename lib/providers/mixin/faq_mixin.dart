import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghlapp/model/chat_model.dart';
import 'package:ghlapp/model/faq_model.dart';
import 'package:ghlapp/resources/AppString.dart';
import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:http/http.dart' as http;

import '../../constants.dart';

mixin FaqMixin on ChangeNotifier {
  final List<Faq> _faqData = [];

  List<Faq> get faqData => _faqData;
  String? showUserMessage;

  final TextEditingController chatMessageController = TextEditingController();

  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  Future<File?> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  Future<void> sendMessage(String text, context) async {
    _messages.add(ChatMessage(text: text, isSender: true, attachment: ""));
    notifyListeners();
    try {
      final url = Uri.parse("${AppStrings.baseURL}chat/send");
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({"message": text}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("send--->> $data");
        await getMessages(context);
        chatMessageController.clear();
      } else {
        _messages.add(
          ChatMessage(
            text: "Error: ${response.statusCode}",
            isSender: false,
            attachment: "",
          ),
        );
        notifyListeners();
      }
    } catch (e) {
      _messages.add(
        ChatMessage(
          text: "Failed to send message: $e",
          isSender: false,
          attachment: "",
        ),
      );
      notifyListeners();
    }
  }

  Future<void> uploadImageOnChatPage(filePath, context) async {
    try {
      final url = Uri.parse("${AppStrings.baseURL}chat/send");
      var request = http.MultipartRequest("POST", url);
      request.headers.addAll({
        "Accept": "application/json",
        "Authorization": "Bearer $authToken",
      });
      if (filePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath("attachment", filePath),
        );
      }
      var response = await request.send();
      final res = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        await getMessages(context);
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: res);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
  }

  Future<void> getMessages(context) async {
    final url = Uri.parse("${AppStrings.baseURL}chat/messages");
    try {
      final res = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final data = jsonDecode(res.body);
      print("messages--->> $data");
      if (res.statusCode == 200) {
        final List<dynamic> messagesJson = data["messages"];
        _messages.clear();
        for (var item in messagesJson) {
          final attachment = item["attachment_url"] ?? "";
          print("attachmentNmae--->> ${item["sender_name"]}");
          _messages.add(
            ChatMessage(
              text: item["message"] ?? "",
              isSender: item["sender_name"] != "admin",
              attachment: attachment,
            ),
          );
        }
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: data["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
    }
    notifyListeners();
  }

  Future<void> getFAQData(context) async {
    final url = Uri.parse("${AppStrings.baseURL}faq");
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $authToken",
        },
      );
      final res = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        _faqData.clear();
        final faqsMap = res["faqs"] as Map<String, dynamic>;
        for (var faqList in faqsMap.values) {
          final parsed =
              (faqList as List)
                  .map((e) => Faq.fromJson(e as Map<String, dynamic>))
                  .toList();
          _faqData.addAll(parsed);
        }
        notifyListeners();
      } else {
        AppSnackBar.show(context, message: res["message"]);
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
      print("res1------->>  $e");
    }
  }
}
