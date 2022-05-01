import 'package:allbert_cms/core/failures/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

abstract class IActionHandler<T> {
  void onError(BuildContext context,Failure failure,
      {List<VoidCallback> actions});
  Future<void> executeTask(BuildContext context, Future<Either<Failure, T>> action, VoidCallback onComplete);
}
