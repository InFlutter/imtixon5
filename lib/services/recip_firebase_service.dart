import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/recip.dart';

class RecipFirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final CollectionReference _recipCollection =
  FirebaseFirestore.instance.collection('recips');

  Stream<List<Recip>> getRecips() {
    return _recipCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Recip.fromDocument(doc)).toList());
  }

  Future<String> _uploadImage(File file) async {
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageRef = _storage.ref().child('recip_images/$fileName');
    final UploadTask uploadTask = storageRef.putFile(file);
    final TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> addRecip({
    required String recepName,
    required String recepDescription,
    required List<String> recepProducts,
    required File imageFile,
  }) async {
    final String imageUrl = await _uploadImage(imageFile);
    final Recip recip = Recip(
      id: '',
      recepName: recepName,
      recepDescription: recepDescription,
      recepProducts: recepProducts,
      imageUrl: imageUrl,
    );
    await _recipCollection.add(recip.toMap());
  }

  Future<void> editRecip({
    required String id,
    required String recepName,
    required String recepDescription,
    required List<String> recepProducts,
    File? imageFile,
    String? oldImageUrl,
  }) async {
    String imageUrl = oldImageUrl ?? '';
    if (imageFile != null) {
      // Delete old image if exists
      if (oldImageUrl != null && oldImageUrl.isNotEmpty) {
        await _storage.refFromURL(oldImageUrl).delete();
      }
      imageUrl = await _uploadImage(imageFile);
    }

    await _recipCollection.doc(id).update({
      'recepName': recepName,
      'recepDescription': recepDescription,
      'recepProducts': recepProducts,
      'imageUrl': imageUrl,
    });
  }

  Future<void> deleteRecip(String id, String imageUrl) async {
    await _recipCollection.doc(id).delete();
    if (imageUrl.isNotEmpty) {
      await _storage.refFromURL(imageUrl).delete();
    }
  }
}
