import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appwrite_chat_app_jun23/models/chat_model.dart';
import 'package:flutter_appwrite_chat_app_jun23/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../controller/chats_controller.dart';

class TextList extends ConsumerWidget {
  const TextList(
      {super.key, required this.currentUser, required this.otherUser});

  final UserModel currentUser;
  final UserModel otherUser;

  // if (realTime.events.contains(
  //             'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.chatsCollection}.documents.*.create')) {
  //           ref.read(getChatsProvider(otherUser.id));
  //         }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getChatsProvider(otherUser.id)).when(
          data: (data) {
            ref.watch(getLatestChatProvider).when(
                  data: (realTime) {
                    if (realTime.events.contains(
                        'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.chatsCollection}.documents.*.create')) {
                      // ref.read(getChatsProvider(otherUser.id));
                      data.add(ChatModel.fromMap(realTime.payload));
                    }
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                );
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => BubbleNormal(
                text: data[index].message,
                isSender: data[index].senderId == currentUser.id ? true : false,
                color: const Color(0xFFE8E8EE),
                tail: true,
                sent: true,
              ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
