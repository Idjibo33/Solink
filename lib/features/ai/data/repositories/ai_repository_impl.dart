import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/ai/data/services/ai_service.dart';
import 'package:so_link/features/ai/domain/repositories/ai_repository.dart';

class AiRepositoryImpl implements AiRepository {
  AiRepositoryImpl(this._service);

  final AiService _service;

  @override
  Future<Either<Failure, String>> generatePost(String prompt) async {
    if (prompt.trim().isEmpty) {
      return const Left(AiFailure('Décrivez le sujet du post.'));
    }
    try {
      final generated = await _service.generatePost(prompt.trim());
      return Right(generated);
    } catch (error) {
      return Left(AiFailure(error.toString()));
    }
  }
}
