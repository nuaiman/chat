import 'package:flutter/material.dart';
import 'package:flutter_appwrite_chat_app_jun23/apis/chat_api.dart';
import 'package:flutter_appwrite_chat_app_jun23/apis/user_api.dart';
import 'package:flutter_appwrite_chat_app_jun23/models/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatsControllerNotifier extends StateNotifier<bool> {
  final ChatsApi _chatsApi;
  final UserApi _userApi;
  ChatsControllerNotifier(
      {required ChatsApi chatsApi, required UserApi userApi})
      : _chatsApi = chatsApi,
        _userApi = userApi,
        super(false);

  void sendText(
      {required BuildContext context,
      required String otherUserId,
      required String text}) async {
    final user = await _userApi.getCurrentUser();

    await _chatsApi.createConversation(
      currentUserId: user.$id,
      otherUserId: otherUserId,
      chat: ChatModel(
        id: '${user.$id}_$otherUserId',
        senderId: user.$id,
        otherId: otherUserId,
        message: text,
      ),
    );
  }

  Future<List<ChatModel>> getChats({required String otherUserId}) async {
    final user = await _userApi.getCurrentUser();
    final chatList = await _chatsApi.getChats(
        currentUserId: user.$id, otherUserId: otherUserId);
    final list = chatList.map((chat) => ChatModel.fromMap(chat.data)).toList();
    print(list);
    return list;
  }

  // THIS is not working
}

// -----------------------------------------------------------------------------

final chatsControllerProvider =
    StateNotifierProvider<ChatsControllerNotifier, bool>((ref) {
  final chatsApi = ref.watch(chatsApiProvider);
  final userApi = ref.watch(userApiProvider);
  return ChatsControllerNotifier(chatsApi: chatsApi, userApi: userApi);
});

final getChatsProvider = FutureProvider.family((ref, String otherUserId) async {
  final chatController = ref.watch(chatsControllerProvider.notifier);
  return chatController.getChats(otherUserId: otherUserId);
});
