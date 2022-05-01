import 'package:allbert_cms/core/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class IAuthSource {
  // ignore: non_constant_identifier_names
  Future<User> Register({@required String email, @required String password});
  // ignore: non_constant_identifier_names
  Future<User> SignIn({@required String email, @required String password});
  // ignore: non_constant_identifier_names
  Future<void> SignOut();
  Future<User> getCurrentUser();
}
