// recip_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/recip_firebase_service.dart';
import 'recip_event.dart';
import 'recip_state.dart';

class RecipBloc extends Bloc<RecipEvent, RecipState> {
  final RecipFirebaseService _recipService = RecipFirebaseService();

  RecipBloc() : super(RecipInitial()) {
    on<LoadRecips>(_onLoadRecips);
    on<AddRecip>(_onAddRecip);
    on<EditRecip>(_onEditRecip);
    on<DeleteRecip>(_onDeleteRecip);
  }

  Future<void> _onLoadRecips(LoadRecips event, Emitter<RecipState> emit) async {
    emit(RecipLoadInProgress());
    try {
      await for (final recips in _recipService.getRecips()) {
        emit(RecipLoadSuccess(recips));
      }
    } catch (e) {
      emit(RecipLoadFailure(e.toString()));
    }
  }

  Future<void> _onAddRecip(AddRecip event, Emitter<RecipState> emit) async {
    try {
      await _recipService.addRecip(
        recepName: event.recepName,
        recepDescription: event.recepDescription,
        recepProducts: event.recepProducts,
        imageFile: event.imageFile,
      );
      add(LoadRecips()); // Reload recipes
    } catch (e) {
      emit(RecipLoadFailure(e.toString()));
    }
  }

  Future<void> _onEditRecip(EditRecip event, Emitter<RecipState> emit) async {
    try {
      await _recipService.editRecip(
        id: event.id,
        recepName: event.recepName,
        recepDescription: event.recepDescription,
        recepProducts: event.recepProducts,
        imageFile: event.imageFile,
        oldImageUrl: event.oldImageUrl,
      );
      add(LoadRecips()); // Reload recipes
    } catch (e) {
      emit(RecipLoadFailure(e.toString()));
    }
  }

  Future<void> _onDeleteRecip(DeleteRecip event, Emitter<RecipState> emit) async {
    try {
      await _recipService.deleteRecip(event.id, event.imageUrl);
      add(LoadRecips()); // Reload recipes
    } catch (e) {
      emit(RecipLoadFailure(e.toString()));
    }
  }
}
