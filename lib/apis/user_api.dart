import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/appwrite_constants.dart';
import '../core/failure.dart';
import '../core/providers.dart';
import '../core/type_defs.dart';

abstract class IUserApi {
  Future<User> getCurrentUser();

  FutureEither<Document> createOrUpdateUser({
    required String userId,
    required String name,
    required String profilePic,
  });

  Future<Document> getCurrentUserDetails(String userId);

  Future<List<Document>> getAllUsers();
}
// -----------------------------------------------------------------------------

class UserApi implements IUserApi {
  final Account _account;
  final Databases _databases;
  final Storage _storage;
  UserApi(
      {required Account account,
      required Databases databases,
      required Storage storage})
      : _account = account,
        _databases = databases,
        _storage = storage;

  @override
  Future<User> getCurrentUser() async {
    return _account.get();
  }

  @override
  FutureEither<Document> createOrUpdateUser(
      {required String userId,
      required String name,
      required String profilePic}) async {
    try {
      User userName = await _account.updateName(name: name);

      await _storage.deleteFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: userId,
      );

      File storageInfo = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: userId,
        file: InputFile.fromPath(
          path: profilePic,
        ),
      );

      final imageLink = AppwriteConstants.imageUrl(storageInfo.$id);

      Document document = await _databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: userId,
        data: {
          'id': userId,
          'name': userName.name,
          'profilePic': imageLink,
        },
      );

      return right(document);
    } on AppwriteException catch (e, stackTrace) {
      if (e.code == 404) {
        String? imageLink;

        User userName = await _account.updateName(name: name);

        File storageInfo = await _storage.createFile(
          bucketId: AppwriteConstants.imagesBucket,
          fileId: userId,
          file: InputFile.fromPath(
            path: profilePic,
          ),
        );

        imageLink = AppwriteConstants.imageUrl(storageInfo.$id);

        Document document = await _databases.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userId,
          data: {
            'id': userId,
            'name': userName.name,
            'profilePic': imageLink,
          },
        );

        return right(document);
      }
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<Document> getCurrentUserDetails(String userId) async {
    return _databases.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
      documentId: userId,
      // queries: [
      //   Query.notEqual('id', userId),
      // ],
    );
  }

  @override
  Future<List<Document>> getAllUsers() async {
    final documents = await _databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollection,
    );
    return documents.documents;
  }
}
// -----------------------------------------------------------------------------

final userApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  final databases = ref.watch(appwriteDatabaseProvider);
  final storage = ref.watch(appwriteStorageProvider);
  return UserApi(account: account, databases: databases, storage: storage);
});
