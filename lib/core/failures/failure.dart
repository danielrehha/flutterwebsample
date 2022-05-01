abstract class Failure {
  final String errorMessage;

  Failure(this.errorMessage) {
    print(this.errorMessage);
  }
}

class ServerFailure extends Failure {
  ServerFailure(String errorMessage) : super(errorMessage);
}

class AuthFailure extends Failure {
  AuthFailure(String errorMessage) : super(errorMessage);
}

class FirebaseAuthFailure extends AuthFailure {
  FirebaseAuthFailure(String errorMessage) : super(errorMessage);
}

class AppFailure extends Failure {
  AppFailure(String errorMessage) : super(errorMessage);
}
