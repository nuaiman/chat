import 'package:flutter/material.dart';
import 'package:flutter_appwrite_chat_app_jun23/features/chats/view/texting_view.dart';
import 'package:flutter_appwrite_chat_app_jun23/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user/controller/user_controller.dart';

class UserListTile extends ConsumerWidget {
  const UserListTile({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userProfileControllerProvider);
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => TextingView(
            otherUser: user,
            currentUser: currentUser,
          ),
        ));
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.profilePic),
      ),
      title: Text(user.name),
    );
  }
}
