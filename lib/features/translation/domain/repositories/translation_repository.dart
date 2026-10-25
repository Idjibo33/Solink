import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';

abstract interface class TranslationRepository {
  Future<Either<Failure, String>> translate(String text);
}
