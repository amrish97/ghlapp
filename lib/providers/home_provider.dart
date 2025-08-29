import 'package:dhlapp/providers/mixin/bottomNav_mixin.dart';
import 'package:dhlapp/providers/mixin/social_mixin.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier
    with BottomNavigationMixin, SocialLoginMixin {}
