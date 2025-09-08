import 'package:ghlapp/resources/app_colors.dart';
import 'package:flutter/material.dart';

//
// class CustomScaffold extends StatefulWidget {
//   final Key? key;
//   final Widget? body;
//   final Widget? appBar;
//   final Widget? action;
//   final String? title;
//   final Function? customAppBarFunction;
//   final bool resizeToAvoidBottomInset;
//   final Color? backgroundColor;
//   final ValueChanged<Map<String, dynamic>>? onChanged;
//   final Widget? floatingActionButton;
//   final FloatingActionButtonLocation? floatingActionButtonLocation;
//   final Widget? bottomNavigationBar;
//   final Widget? drawer;
//   final Color? appBarBGColor;
//
//   const CustomScaffold({
//     this.key,
//     this.appBar,
//     this.title,
//     this.action,
//     this.body,
//     this.customAppBarFunction,
//     this.onChanged,
//     this.resizeToAvoidBottomInset = false,
//     this.backgroundColor,
//     this.floatingActionButton,
//     this.floatingActionButtonLocation,
//     this.bottomNavigationBar,
//     this.drawer,
//     this.appBarBGColor = AppColors.white,
//   }) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() {
//     return CustomScaffoldState();
//   }
// }
//
// class CustomScaffoldState extends State<CustomScaffold> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: widget.backgroundColor,
//       resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
//       body: widget.body,
//       key: widget.key ?? GlobalKey(),
//       floatingActionButton: widget.floatingActionButton,
//       floatingActionButtonLocation: widget.floatingActionButtonLocation,
//       bottomNavigationBar: widget.bottomNavigationBar,
//       drawer: widget.drawer,
//     );
//   }
// }
