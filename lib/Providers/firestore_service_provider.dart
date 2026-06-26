import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:yapter/Models/user.dart';
import 'package:yapter/Services/database.dart';
part 'firestore_service_provider.g.dart';
@riverpod
FirestoreService firestoreService(FirestoreServiceRef ref){
  return FirestoreService();
}
