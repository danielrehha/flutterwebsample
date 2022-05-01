import 'dart:async';
import 'package:allbert_cms/domain/repositories/repository_auth.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'firebase_event.dart';
part 'firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseBloc({@required this.repository}) : super(FirebaseInitial());

  final IAuthRepository repository;

  @override
  Stream<FirebaseState> mapEventToState(
    FirebaseEvent event,
  ) async* {
    yield FirebaseAwaitingState();
    if (event is SignInFirebaseEvent) {
      final result =
          await repository.SignIn(email: event.email, password: event.password);
      if (result.isRight()) {
        yield FirebaseSignedInState(result.getOrElse(() => null));
      } else {
        String message;
        result.fold((l) => {message = l.errorMessage}, (r) => {});
        yield FirebaseErrorState(message);
      }
    }
    if (event is SignOutFirebaseEvent) {
      final result = await repository.SignOut();
      if (result.isRight()) {
        yield FirebaseSignedOutState();
      } else {
        String message;
        result.fold((l) => {message = l.errorMessage}, (r) => {});
        yield FirebaseErrorState(message);
      }
    }
    if (event is RegisterFirebaseEvent) {
      final result = await repository.Register(
          email: event.email, password: event.password);
      if (result.isRight()) {
        yield FirebaseSignedInState(result.getOrElse(() {
          throw Exception(
              'Unexpected internal error occured while signing in.');
        }));
      } else {
        String message;
        result.fold((l) => {message = l.errorMessage}, (r) => {});
        yield FirebaseErrorState(message);
      }
    }
    if (event is ResetFirebaseEvent) {
      yield FirebaseInitial();
    }
  }
}
