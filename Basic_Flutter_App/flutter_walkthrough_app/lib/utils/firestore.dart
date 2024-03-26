import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //Get User Collection
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  //Additional Colelctions?

  //Save to Collection
  Future<void> saveUserToDatabase(String newUser) async {
    await users.add({
      //
    });
  }

  //Additional Fields?
}
