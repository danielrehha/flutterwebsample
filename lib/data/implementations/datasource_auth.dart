import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/data/contracts/i_datasource_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class FirebaseAuthSource implements IAuthSource {
  @override
  // ignore: non_constant_identifier_names
  Future<User> Register(
      {@required String email, @required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await userCredential.user.sendEmailVerification();

    return userCredential.user;
  }

  @override
  // ignore: non_constant_identifier_names
  Future<User> SignIn(
      {@required String email, @required String password}) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    //await SignOut();
    return userCredential.user;
  }

  @override
  // ignore: non_constant_identifier_names
  Future<void> SignOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<User> getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser;
  }
}
