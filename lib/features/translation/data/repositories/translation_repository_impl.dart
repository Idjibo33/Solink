import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/translation/data/services/translation_service.dart';
import 'package:so_link/features/translation/domain/repositories/translation_repository.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  TranslationRepositoryImpl(this._service);

  final TranslationService _service;

  @override
  Future<Either<Failure, String>> translate(String text) async {
    if (text.trim().isEmpty) {
      return const Left(TranslationFailure('Aucun texte à traduire.'));
    }
    try {
      return Right(await _service.translate(text));
    } catch (error) {
      return Left(TranslationFailure(error.toString()));
    }
  }
}
