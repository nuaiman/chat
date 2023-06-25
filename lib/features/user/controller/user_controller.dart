import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../apis/user_api.dart';
import '../../../models/user_model.dart';

class UserControllerNotifier extends StateNotifier<UserModel> {
  final UserApi _userApi;
  UserControllerNotifier({required UserApi userApi})
      : _userApi = userApi,
        super(
          UserModel(id: '', name: '', profilePic: ''),
        );

  Future<UserModel> getUserProfileDetails(String userId) async {
    final document = await _userApi.getCurrentUserDetails(userId);
    final userModel = UserModel.fromMap(document.data);
    state = userModel;
    return userModel;
  }

  Future<List<UserModel>> getAllusers() async {
    User currentUserId = await _userApi.getCurrentUser();
    final userList = await _userApi.getAllUsers();
    final listOfUsers =
        userList.map((user) => UserModel.fromMap(user.data)).toList();
    listOfUsers.removeWhere((user) => user.id == currentUserId.$id);
    return listOfUsers;
  }
}
// -----------------------------------------------------------------------------

final userProfileControllerProvider =
    StateNotifierProvider<UserControllerNotifier, UserModel>((ref) {
  final userApi = ref.watch(userApiProvider);
  return UserControllerNotifier(userApi: userApi);
});

final getUserProfileDetailsFutureProvider =
    FutureProvider.family((ref, String userId) {
  final profileController = ref.watch(userProfileControllerProvider.notifier);
  return profileController.getUserProfileDetails(userId);
});

final getUsersProvider = FutureProvider((ref) async {
  final userController = ref.watch(userProfileControllerProvider.notifier);
  return userController.getAllusers();
});
