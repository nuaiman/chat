import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_appwrite_chat_app_jun23/constants/appwrite_constants.dart';
import 'package:flutter_appwrite_chat_app_jun23/core/providers.dart';
import 'package:flutter_appwrite_chat_app_jun23/models/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class IChatsApi {
  Future<String?> createConversation(
      {required String currentUserId,
      required String otherUserId,
      required ChatModel chat});

  Future<List<Document>> getChats(
      {required String currentUserId, required String otherUserId});
}
// -----------------------------------------------------------------------------

class ChatsApi implements IChatsApi {
  final Databases _databases;
  final Account _account;
  ChatsApi({required Databases databases, required Account account})
      : _account = account,
        _databases = databases;

  @override
  Future<String?> createConversation(
      {required String currentUserId,
      required String otherUserId,
      required ChatModel chat}) async {
    Document? document;
    try {
      document = await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.chatsCollection,
        documentId: ID.unique(),
        data: chat.toMap(),
      );
      return document.$id;
      //   document = await _databases.getDocument(
      //     databaseId: AppwriteConstants.databaseId,
      //     collectionId: AppwriteConstants.chatsCollection,
      //     documentId: '${currentUserId}_$otherUserId',
      //   );
      //   return document.$id;
      // } on AppwriteException catch (e) {
      //   if (e.code == 404) {
      //     try {
      //       document = await _databases.getDocument(
      //         databaseId: AppwriteConstants.databaseId,
      //         collectionId: AppwriteConstants.chatsCollection,
      //         documentId: '${otherUserId}_$currentUserId',
      //       );
      //       return document.$id;
      //     } on AppwriteException catch (e) {
      //       if (e.code == 404) {
      //         document = await _databases.createDocument(
      //             databaseId: AppwriteConstants.databaseId,
      //             collectionId: AppwriteConstants.chatsCollection,
      //             documentId: '${currentUserId}_$otherUserId',
      //             data: {});
      //         return document.$id;
      //       }
      //     } catch (e) {
      //       rethrow;
      //     }
      //   }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Document>> getChats(
      {required String currentUserId, required String otherUserId}) async {
    final documents = await _databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      // queries: [
      //   Query.equal('id', '${currentUserId}_$otherUserId'),
      //   Query.equal('id', '${otherUserId}_$currentUserId'),
      // ],
    );
    return documents.documents;
  }
}
// -----------------------------------------------------------------------------

final chatsApiProvider = Provider((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  final account = ref.watch(appwriteAccountProvider);
  return ChatsApi(databases: databases, account: account);
});
