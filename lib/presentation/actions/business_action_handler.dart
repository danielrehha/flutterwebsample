import 'package:allbert_cms/domain/repositories/repository_business.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'i_action_handler.dart';

class BusinessActionHandler {
  final IActionHandler handler;
  final IBusinessRepository repository;

  BusinessActionHandler({this.handler, this.repository});

  Future<void> deleteAppointmentAsync(BuildContext context,
      {@required String appointmentId, VoidCallback onComplete}) async {
    await handler.executeTask(
      context,
      repository.updateAppointmentStatusAsync(appointmentId: appointmentId),
      onComplete,
    );
  }
}
