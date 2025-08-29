import 'package:flutter/material.dart';

class OnBoardProvider extends ChangeNotifier {
  final PageController controller = PageController();
  int _currentPage = 0;
  int get currentPage => _currentPage;

  void setPage(int index) {
    _currentPage = index;
    notifyListeners();
  }

  List<Map<String, dynamic>> pageData = [
    {
      "index": 0,
      "content": "Welcome ! to",
      "subContent": "Smart investing made simple, secure, and stress-free.",
      "image": "assets/images/onboard1.png",
    },
    {
      "index": 1,
      "content": "Grow Your Wealth, One Step at a Time",
      "subContent":
          "Invest with confidence, track with ease, and watch your future bloom.",
      "image": "assets/images/onboard2.png",
    },
    {
      "index": 2,
      "content": "Start Your Investment Journey Today ",
      "subContent":
          " Create your free account in seconds and unlock smarter investing.",
      "image": "assets/images/onboard3.png",
    },
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
