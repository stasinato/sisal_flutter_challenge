part of 'gazzetta_cubit.dart';

@immutable
sealed class GazzettaState {}

final class GazzettaInitial extends GazzettaState {}

final class GazzettaLoading extends GazzettaState {}

final class GazzettaLoaded extends GazzettaState {
  final List<GazzettaArticle> articles;

  GazzettaLoaded({required this.articles});
}

final class GazzettaError extends GazzettaState {}
