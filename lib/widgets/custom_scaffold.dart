import 'package:flutter/material.dart';

class CustomScaffold extends StatefulWidget {
  final Widget? body;
  final Widget? appBar;
  final Widget? action;
  final bool resizeToAvoidBottomInset;
  final Color? backgroundColor;

  const CustomScaffold({
    super.key,
    this.appBar,
    this.action,
    this.body,
    this.resizeToAvoidBottomInset = false,
    this.backgroundColor,
  });

  @override
  State<StatefulWidget> createState() {
    return CustomScaffoldState();
  }
}

class CustomScaffoldState extends State<CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      body: widget.body,
    );
  }
}
