import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'common/error_page.dart';
import 'common/loading_page.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/view/auth_phone_view.dart';
import 'features/chats/view/chats_view.dart';
import 'features/user/controller/user_controller.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Bisky Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: ref.watch(getCurrentAccountProvider).when(
            data: (data) {
              if (data != null) {
                ref
                    .read(userProfileControllerProvider.notifier)
                    .getUserProfileDetails(data.$id);
                return const ChatsView();
              }
              return const AuthPhoneView();
            },
            error: (error, stackTrace) => ErrorPage(error: error.toString()),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
