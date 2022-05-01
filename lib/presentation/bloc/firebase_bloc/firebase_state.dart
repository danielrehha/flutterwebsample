part of 'firebase_bloc.dart';

abstract class FirebaseState extends Equatable {
  const FirebaseState();
  
  @override
  List<Object> get props => [];
}

class FirebaseInitial extends FirebaseState {

}

class FirebaseSignedOutState extends FirebaseState {
  @override
  List<Object> get props => [];
}

class FirebaseSignedInState extends FirebaseState {
  final User user;

  FirebaseSignedInState(this.user);

  @override
  List<Object> get props => [user];
}

class FirebaseAwaitingState extends FirebaseState {
  @override
  List<Object> get props => [];
}

class FirebaseErrorState extends FirebaseState {
  final String errorMessage;

  FirebaseErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
