import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/data/services/auth_service.dart';
import 'package:so_link/features/auth/data/services/user_service.dart';
import 'package:so_link/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthService authService,
    required UserService userService,
  }) : _authService = authService,
       _userService = userService;

  final AuthService _authService;
  final UserService _userService;

  @override
  Stream<UserModel?> authStateChanges() async* {
    await for (final firebaseUser in _authService.authStateChanges()) {
      if (firebaseUser == null) {
        yield null;
        continue;
      }
      try {
        await _migrateLegacyEmail(firebaseUser.uid, firebaseUser.email);
        final user = await _userService.getUser(firebaseUser.uid);
        yield user ?? _placeholderUser(firebaseUser.uid);
      } catch (_) {
        yield _placeholderUser(firebaseUser.uid);
      }
    }
  }

  @override
  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.signIn(
        email: email,
        password: password,
      );
      final uid = credential.user?.uid;
      if (uid == null) {
        return const Left(AuthFailure('Connexion impossible.'));
      }
      await _migrateLegacyEmail(uid, credential.user?.email);
      final user = await _userService.getUser(uid);
      if (user == null) {
        return const Left(
          AuthFailure('Profil introuvable. Contactez le support.'),
        );
      }
      return Right(user);
    } catch (error) {
      return Left(mapFailure(error));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUp({
    required String nom,
    required String prenom,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _authService.signUp(
        email: email,
        password: password,
      );
      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        return const Left(AuthFailure('Création du compte impossible.'));
      }
      await _userService.createUserProfile(
        id: firebaseUser.uid,
        nom: nom,
        prenom: prenom,
        email: email,
      );
      return Right(
        UserModel(
          id: firebaseUser.uid,
          nom: nom.trim(),
          prenom: prenom.trim(),
          bio: '',
          posts: 0,
          followers: 0,
          followings: 0,
          creeLe: Timestamp.now(),
        ),
      );
    } catch (error) {
      return Left(mapFailure(error));
    }
  }

  @override
  Future<Either<Failure, UserModel>> completeProfile({
    required String userId,
    required String bio,
  }) async {
    try {
      await _userService.updateBio(userId: userId, bio: bio);
      final user = await _userService.getUser(userId);
      if (user == null) {
        return const Left(AuthFailure('Profil introuvable.'));
      }
      return Right(user);
    } catch (error) {
      return Left(mapFailure(error));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authService.signOut();
      return const Right(null);
    } catch (error) {
      return Left(mapFailure(error));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUser(String userId) async {
    try {
      final user = await _userService.getUser(userId);
      if (user == null) {
        return const Left(AuthFailure('Utilisateur introuvable.'));
      }
      return Right(user);
    } catch (error) {
      return Left(mapFailure(error));
    }
  }

  @override
  Stream<UserModel> watchUser(String userId) {
    return _userService.watchUser(userId);
  }

  @override
  Stream<List<UserModel>> watchOtherUsers(String currentUserId) {
    return _userService.watchOtherUsers(currentUserId);
  }

  Future<void> _migrateLegacyEmail(String userId, String? email) async {
    try {
      await _userService.migrateLegacyEmail(
        userId: userId,
        fallbackEmail: email,
      );
    } catch (_) {
      // La migration ne doit jamais bloquer la connexion. Les comptes non
      // migrés restent couverts par le script admin.
    }
  }

  UserModel _placeholderUser(String uid) {
    return UserModel(
      id: uid,
      nom: '',
      prenom: '',
      bio: '',
      posts: 0,
      followers: 0,
      followings: 0,
      creeLe: Timestamp.now(),
    );
  }
}
