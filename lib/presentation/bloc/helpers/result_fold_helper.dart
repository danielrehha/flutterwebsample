import 'package:allbert_cms/core/failures/failure.dart';
import 'package:dartz/dartz.dart';

class ResultFoldHelper {
  Failure extract<T>(Either<Failure, T> result) {
    Failure failure;
    result.fold((l) => failure = l, (r) => null);
    return failure;
  }
}