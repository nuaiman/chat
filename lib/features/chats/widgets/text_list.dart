import 'package:flutter/material.dart';
import 'package:flutter_appwrite_chat_app_jun23/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../controller/chats_controller.dart';

class TextList extends ConsumerWidget {
  const TextList(
      {super.key, required this.currentUser, required this.otherUser});

  final UserModel currentUser;
  final UserModel otherUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getChatsProvider(otherUser.id)).when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(data[index].message),
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
