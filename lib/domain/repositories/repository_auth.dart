import 'package:allbert_cms/data/contracts/i_datasource_auth.dart';
import 'package:allbert_cms/core/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class IAuthRepository {
  // ignore: non_constant_identifier_names
  Future<Either<AuthFailure, User>> Register(
      {@required String email, @required String password});
  // ignore: non_constant_identifier_names
  Future<Either<AuthFailure, User>> SignIn(
      {@required String email, @required String password});
  // ignore: non_constant_identifier_names
  Future<Either<AuthFailure, void>> SignOut();
}

class FirebaseAuthRepository implements IAuthRepository {
  final IAuthSource authSource;

  FirebaseAuthRepository({@required this.authSource});

  @override
  // ignore: non_constant_identifier_names
  Future<Either<FirebaseAuthFailure, User>> Register(
      {String email, String password}) async {
    try {
      final result =
          await authSource.Register(email: email, password: password);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(e.message));
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<FirebaseAuthFailure, User>> SignIn(
      {@required String email, @required String password}) async {
    try {
      final result = await authSource.SignIn(email: email, password: password);
      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(e.message));
    }
  }

  @override
  // ignore: non_constant_identifier_names
  Future<Either<FirebaseAuthFailure, void>> SignOut() async {
    try {
      await authSource.SignOut();
      return Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(FirebaseAuthFailure(e.message));
    }
  }
}
