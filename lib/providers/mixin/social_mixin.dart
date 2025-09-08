import 'package:ghlapp/widgets/custom_snakebar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

mixin SocialLoginMixin on ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _userName;
  String? _email;
  String? _photoUrl;

  String? get userName => _userName;
  String? get email => _email;
  String? get photoUrl => _photoUrl;

  Future<void> signInWithGoogle(context) async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        _userName = account.displayName;
        _email = account.email;
        _photoUrl = account.photoUrl;
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
      debugPrint("Google sign-in error: $e");
    }
  }

  Future<void> signInWithFacebook(context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        _userName = userData["name"];
        _email = userData["email"];
        _photoUrl = userData["picture"]["data"]["url"];
      } else {
        debugPrint("Facebook login failed: ${result.status}");
      }
    } catch (e) {
      AppSnackBar.show(context, message: e.toString());
      debugPrint("Facebook sign-in error: $e");
    }
  }

  Future<void> logout() async {
    await _googleSignIn.signOut();
    await FacebookAuth.instance.logOut();
    _userName = null;
    _email = null;
    _photoUrl = null;
    notifyListeners();
  }
}
