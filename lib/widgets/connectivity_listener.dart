import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ghlapp/providers/connectivity_provider.dart';
import 'package:ghlapp/resources/app_colors.dart';
import 'package:ghlapp/resources/app_dimention.dart';
import 'package:ghlapp/resources/app_font.dart';
import 'package:ghlapp/widgets/custom_text.dart';
import 'package:provider/provider.dart';

class ConnectivityListener extends StatefulWidget {
  final Widget child;

  const ConnectivityListener({super.key, required this.child});

  @override
  State<ConnectivityListener> createState() => _ConnectivityListenerState();
}

class _ConnectivityListenerState extends State<ConnectivityListener> {
  bool _showOnlineBanner = false;
  bool? _lastIsOnline;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ConnectivityProvider>(
        builder: (context, provider, _) {
          final bool isOnline = provider.isOnline;
          if (_lastIsOnline == null) {
            _lastIsOnline = isOnline;
          } else if (isOnline != _lastIsOnline) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (isOnline) {
                _timer?.cancel();
                setState(() => _showOnlineBanner = true);
                _timer = Timer(const Duration(seconds: 2), () {
                  if (!mounted) return;
                  setState(() => _showOnlineBanner = false);
                });
              } else {
                _timer?.cancel();
                setState(() => _showOnlineBanner = false);
              }
              _lastIsOnline = isOnline;
            });
          }
          return Column(
            children: [
              Expanded(child: widget.child),
              if (!isOnline)
                Container(
                  height: 20,
                  width: double.infinity,
                  color: AppColors.primary,
                  alignment: Alignment.center,
                  child: PrimaryText(
                    text: "No Internet Connection",
                    weight: AppFont.medium,
                    size: AppDimen.textSize10,
                    color: AppColors.white,
                  ),
                )
              else if (_showOnlineBanner)
                Container(
                  height: 20,
                  width: double.infinity,
                  color: AppColors.greenCircleColor,
                  alignment: Alignment.center,
                  child: PrimaryText(
                    text: "Back Online",
                    weight: AppFont.medium,
                    size: AppDimen.textSize10,
                    color: AppColors.white,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
