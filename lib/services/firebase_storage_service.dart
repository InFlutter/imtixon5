import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadFile(String fileName, File file) async {
    final imageReference =
        _storage.ref().child("cars").child("images").child("$fileName.jpg");
    // _storage.ref().child("cars/images/$fileName.jpg");
    final uploadTask = imageReference.putFile(file);

    // UploadTask - Yuklash haqida ma'lumot beradi
    uploadTask.snapshotEvents.listen((event) {
      print(event.state);

      // Yuklash foizi --- round() - yahlitlash
      int percentage =
          (event.bytesTransferred * 100 / file.lengthSync()).round();
      print("Yuklandi: $percentage");
    });

    String imageUrl = "";
    await uploadTask.whenComplete(() async {
      imageUrl = await imageReference.getDownloadURL();
    });

    return imageUrl;
  }

  Future<String> changeFile({
    required String oldImageUrl,
    required File newFile,
  }) async {
    final imageReference = _storage.refFromURL(oldImageUrl);
    final uploadTask = imageReference.putFile(newFile);

    // UploadTask - Yuklash haqida ma'lumot beradi
    uploadTask.snapshotEvents.listen((event) {
      print(event.state);

      // Yuklash foizi --- round() - yahlitlash
      int percentage =
          (event.bytesTransferred * 100 / newFile.lengthSync()).round();
      print("Yuklandi: $percentage");
    });

    String imageUrl = "";
    await uploadTask.whenComplete(() async {
      imageUrl = await imageReference.getDownloadURL();
    });

    return imageUrl;
  }

  Future<void> deleteFile(String fileUrl) async {
    final imageReference = _storage.refFromURL(fileUrl);
    imageReference.delete();
  }
}
