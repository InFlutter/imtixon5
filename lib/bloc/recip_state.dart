// recip_state.dart
import 'package:equatable/equatable.dart';
import '../models/recip.dart';

abstract class RecipState extends Equatable {
  const RecipState();

  @override
  List<Object> get props => [];
}

class RecipInitial extends RecipState {}

class RecipLoadInProgress extends RecipState {}

class RecipLoadSuccess extends RecipState {
  final List<Recip> recips;

  const RecipLoadSuccess(this.recips);

  @override
  List<Object> get props => [recips];
}

class RecipLoadFailure extends RecipState {
  final String error;

  const RecipLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
