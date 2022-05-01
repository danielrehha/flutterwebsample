part of 'firebase_bloc.dart';

abstract class FirebaseEvent extends Equatable {
  const FirebaseEvent();

  @override
  List<Object> get props => [];
}

class RegisterFirebaseEvent extends FirebaseEvent {
  final String email;
  final String password;

  RegisterFirebaseEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignInFirebaseEvent extends FirebaseEvent {
  final String email;
  final String password;

  SignInFirebaseEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignOutFirebaseEvent extends FirebaseEvent {
  
}

class ResetFirebaseEvent extends FirebaseEvent{
  
}