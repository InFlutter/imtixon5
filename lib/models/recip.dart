import 'package:cloud_firestore/cloud_firestore.dart';

class Recip {
  final String id;
  final String recepName;
  final String recepDescription;
  final List<String> recepProducts;
  final String imageUrl;

  Recip({
    required this.id,
    required this.recepName,
    required this.recepDescription,
    required this.recepProducts,
    required this.imageUrl,
  });

  factory Recip.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Recip(
      id: doc.id,
      recepName: data['recepName'] ?? '',
      recepDescription: data['recepDescription'] ?? '',
      recepProducts: List<String>.from(data['recepProducts'] ?? []),
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'recepName': recepName,
      'recepDescription': recepDescription,
      'recepProducts': recepProducts,
      'imageUrl': imageUrl,
    };
  }
}
