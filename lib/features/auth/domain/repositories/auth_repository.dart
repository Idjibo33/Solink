import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';

abstract interface class AuthRepository {
  Stream<UserModel?> authStateChanges();

  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> signUp({
    required String nom,
    required String prenom,
    required String email,
    required String password,
  });

  Future<Either<Failure, UserModel>> completeProfile({
    required String userId,
    required String bio,
  });

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, UserModel>> getUser(String userId);

  Stream<UserModel> watchUser(String userId);

  Stream<List<UserModel>> watchOtherUsers(String currentUserId);
}
