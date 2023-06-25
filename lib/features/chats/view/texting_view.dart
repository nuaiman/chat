import 'package:flutter/material.dart';
import 'package:flutter_appwrite_chat_app_jun23/common/error_page.dart';
import 'package:flutter_appwrite_chat_app_jun23/common/loading_page.dart';
import 'package:flutter_appwrite_chat_app_jun23/features/chats/controller/chats_controller.dart';
import 'package:flutter_appwrite_chat_app_jun23/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/text_list.dart';

class TextingView extends ConsumerStatefulWidget {
  const TextingView({
    super.key,
    required this.currentUser,
    required this.otherUser,
  });

  final UserModel currentUser;
  final UserModel otherUser;

  @override
  ConsumerState<TextingView> createState() => _TextingViewState();
}

class _TextingViewState extends ConsumerState<TextingView> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    ref
        .read(chatsControllerProvider.notifier)
        .getChats(otherUserId: widget.otherUser.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 45,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.otherUser.profilePic),
            ),
          ),
          centerTitle: false,
          title: Text(widget.otherUser.name),
        ),
        body: Column(
          children: [
            Expanded(
              child: TextList(
                currentUser: widget.currentUser,
                otherUser: widget.otherUser,
              ),
            ),
            Container(
              width: double.infinity,
              height: 80,
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          hintText: 'Send messages',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: IconButton(
                            onPressed: () {
                              if (_textController.text.trim().isEmpty) {
                                return;
                              }
                              ref
                                  .read(chatsControllerProvider.notifier)
                                  .sendText(
                                    context: context,
                                    otherUserId: widget.otherUser.id,
                                    text: _textController.text,
                                  );

                              _textController.clear();
                            },
                            icon: const Icon(Icons.send),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
