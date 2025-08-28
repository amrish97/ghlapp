import 'package:flutter/material.dart';

class OnBoardProvider extends ChangeNotifier {
  final PageController controller = PageController();

  bool _isLastPage = false;

  bool get isLastPage => _isLastPage;

  void setLastPage(bool value) {
    _isLastPage = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> pageData = [
    {
      "index": 0,
      "content": " to Esy Cash your Trusted Loan Partner",
      "subContent":
          "Fast, secure, and transparent loans designed for your needs",
      "image": "assets/images/onboard.png",
    },
    {
      "index": 1,
      "content": "Easiest way to Transfer ",
      "subContent":
          "Transfer money with ease! our app simplifies the process. ",
      "image": "assets/images/onboard2.png",
    },
    {
      "index": 2,
      "content": "Your Security, Our ",
      "subContent":
          " Bank-level encryption keeps your personal and financial data protected.",
      "image": "assets/images/onboard3.png",
    },
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
