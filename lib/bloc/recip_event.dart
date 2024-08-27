// recip_event.dart
import 'package:equatable/equatable.dart';
import 'dart:io';

abstract class RecipEvent extends Equatable {
  const RecipEvent();

  @override
  List<Object> get props => [];
}

class LoadRecips extends RecipEvent {}

class AddRecip extends RecipEvent {
  final String recepName;
  final String recepDescription;
  final List<String> recepProducts;
  final File imageFile;

  const AddRecip({
    required this.recepName,
    required this.recepDescription,
    required this.recepProducts,
    required this.imageFile,
  });

  @override
  List<Object> get props => [recepName, recepDescription, recepProducts, imageFile];
}

class EditRecip extends RecipEvent {
  final String id;
  final String recepName;
  final String recepDescription;
  final List<String> recepProducts;
  final File? imageFile;
  final String? oldImageUrl;

  const EditRecip({
    required this.id,
    required this.recepName,
    required this.recepDescription,
    required this.recepProducts,
    this.imageFile,
    this.oldImageUrl,
  });

  @override
  List<Object> get props => [id, recepName, recepDescription, recepProducts, imageFile ?? '', oldImageUrl ?? ''];
}

class DeleteRecip extends RecipEvent {
  final String id;
  final String imageUrl;

  const DeleteRecip({
    required this.id,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [id, imageUrl];
}
