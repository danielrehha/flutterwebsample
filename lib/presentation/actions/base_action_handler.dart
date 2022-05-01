import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/presentation/actions/i_action_handler.dart';
import 'package:allbert_cms/presentation/bloc/helpers/result_fold_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

class ActionHandler<T> implements IActionHandler<T> {
  @override
  final ResultFoldHelper foldHelper = ResultFoldHelper();

  Future<void> executeTask(BuildContext context,
      Future<Either<Failure, T>> action, VoidCallback onComplete) async {
    final result = await action;
    if (result.isLeft()) {
      onError(context, foldHelper.extract(result));
    } else {
      onComplete();
    }
  }

  @override
  void onError(BuildContext context, Failure failure,
      {List<VoidCallback> actions = const []}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(failure.errorMessage),
      ),
    );
    for (var action in actions) {
      action.call();
    }
  }
}
