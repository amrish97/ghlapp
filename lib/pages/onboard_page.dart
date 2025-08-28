import 'package:dhlapp/providers/onboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OnBoardProvider(),
      child: Consumer<OnBoardProvider>(
        builder: (context, value, child) {
          return Scaffold();
        },
      ),
    );
  }
}
