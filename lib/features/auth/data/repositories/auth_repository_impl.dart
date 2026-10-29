import 'package:fpdart/fpdart.dart';
import 'package:so_link/core/errors/failure.dart';
import 'package:so_link/features/auth/data/models/user_model.dart';
import 'package:so_link/features/auth/domain/repositories/auth_gateway.dart';
import 'package:so_link/features/auth/domain/repositories/auth_repository.dart';
import 'package:so_link/features/auth/domain/repositories/user_store.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthGateway authGateway,
    required UserStore userStore,
  })  : _authGateway = authGateway,
        _userStore = userStore;

  final AuthGateway _authGateway;
  final UserStore _userStore;

  @override
  Stream<UserModel?> authStateChanges() async* {
    await for (final authUser in _authGateway.authStateChanges()) {
      if (authUser == null) {
        yield null;
        continue;
      }
      try {
        await _migrateLegacyEmail(authUser.uid, authUser.email);
        final user = await _userStore.getUser(authUser.uid);
        yield user ?? _placeholderUser(authUser.uid);
      } catch (_) {
        yield _placeholderUser(authUser.uid);
      }
    }
  }

  @override
  Future<Either<Failure, UserModel>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final authUser =
          await _authGateway.signIn(email: email, password: password);
      await _migrateLegacyEmail(authUser.uid, authUser.email);
      final user = await _userStore.getUser(authUser.uid);
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
      final authUser =
          await _authGateway.signUp(email: email, password: password);
      await _userStore.createUserProfile(
        id: authUser.uid,
        nom: nom,
        prenom: prenom,
        email: authUser.email.isEmpty ? email : authUser.email,
      );
      return Right(
        UserModel(
          id: authUser.uid,
          nom: nom.trim(),
          prenom: prenom.trim(),
          bio: '',
          posts: 0,
          followers: 0,
          followings: 0,
          creeLe: DateTime.now(),
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
      await _userStore.updateBio(userId: userId, bio: bio);
      final user = await _userStore.getUser(userId);
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
      await _authGateway.signOut();
      return const Right(null);
    } catch (error) {
      return Left(mapFailure(error));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUser(String userId) async {
    try {
      final user = await _userStore.getUser(userId);
      if (user == null) {
        return const Left(AuthFailure('Utilisateur introuvable.'));
      }
      return Right(user);
    } catch (error) {
      return Left(mapFailure(error));
    }
  }

  @override
  Stream<UserModel> watchUser(String userId) => _userStore.watchUser(userId);

  @override
  Stream<List<UserModel>> watchOtherUsers(String currentUserId) =>
      _userStore.watchOtherUsers(currentUserId);

  Future<void> _migrateLegacyEmail(String userId, String? email) async {
    try {
      await _userStore.migrateLegacyEmail(
        userId: userId,
        fallbackEmail: email,
      );
    } catch (_) {
      // La migration ne doit jamais bloquer la connexion. Les comptes non
      // migres restent couverts par le script admin.
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
      creeLe: DateTime.now(),
    );
  }
}
