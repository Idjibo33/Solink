import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';

abstract interface class AiRepository {
  Future<Either<Failure, String>> generatePost(String prompt);
}
