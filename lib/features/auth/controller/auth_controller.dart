import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../apis/auth_api.dart';
import '../../../apis/user_api.dart';
import '../../../core/utils.dart';
import '../../chats/view/chats_view.dart';
import '../../user/controller/user_controller.dart';
import '../view/auth_otp_view.dart';
import '../view/auth_phone_view.dart';
import '../view/update_user_profile_view.dart';

class AuthControllerNotifier extends StateNotifier<bool> {
  final AuthApi _authApi;
  final UserApi _userApi;
  AuthControllerNotifier({required AuthApi authApi, required UserApi userApi})
      : _authApi = authApi,
        _userApi = userApi,
        super(false);

  void createSession({
    required BuildContext context,
    required String phone,
  }) async {
    state = true;
    final result = await _authApi.createSession(
        userId: phone.split('+').last, phone: phone);

    result.fold(
      (l) {
        state = false;
        showSnackbar(context, l.message);
      },
      (r) {
        state = false;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AuthOtpView(
            userId: r.userId,
          ),
        ));
      },
    );
  }

  void updateSession({
    required BuildContext context,
    required String userId,
    required String secret,
  }) async {
    state = true;
    final result = await _authApi.updateSession(userId: userId, secret: secret);

    result.fold(
      (l) {
        state = false;
        showSnackbar(context, l.message);
      },
      (r) {
        state = false;
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => UpdateUserProfileView(userId: userId),
        ));
      },
    );
  }

  Future<User?> getCurrentAccount() async {
    return await _authApi.getCurrentAccount();
  }

  void logout(BuildContext context) async {
    final result = await _authApi.logout();
    result.fold(
      (l) => null,
      (r) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthPhoneView(),
          ),
          (route) => false),
    );
  }

  Future<void> createOrUpdateUser(BuildContext context, String userId,
      String name, String profilePicPath, WidgetRef ref) async {
    state = true;
    final result = await _userApi.createOrUpdateUser(
      userId: userId,
      name: name,
      profilePic: profilePicPath,
    );

    result.fold(
      (l) {
        state = false;
        showSnackbar(context, l.message);
      },
      (r) {
        state = false;
        ref
            .read(userProfileControllerProvider.notifier)
            .getUserProfileDetails(r.$id);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ChatsView(),
          ),
          (route) => false,
        );
      },
    );
  }

  // Future<UserModel> getUserDetails(String uid) async {
  //   final document = await _userApi.getUserDetails(uid);
  //   final user = UserModel.fromMap(document.data);
  //   print(document);
  //   return user;
  // }
}
// -----------------------------------------------------------------------------

final authControllerProvider =
    StateNotifierProvider<AuthControllerNotifier, bool>((ref) {
  final authApi = ref.watch(authApiProvider);
  final userApi = ref.watch(userApiProvider);
  return AuthControllerNotifier(authApi: authApi, userApi: userApi);
});

final getCurrentAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCurrentAccount();
});
