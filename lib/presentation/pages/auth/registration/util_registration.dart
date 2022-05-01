import 'package:allbert_cms/domain/entities/entity_business.dart';
import 'package:allbert_cms/presentation/pages/auth/registration/enum_registration_step.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class RegistrationUtil {
  RegistrationState _getRegistrationState({@required Business business}) {
    if (business == null) {
      return RegistrationState.InitialCreate;
    }
    if (business.details == null ||
        business.details.name == null ||
        business.details.type == null) {
      return RegistrationState.MissingDetails;
    }
    if (business.address == null) {
      return RegistrationState.MissingAddress;
    }
    if (business.contact == null) {
      return RegistrationState.MissingContact;
    }
    return RegistrationState.Completed;
  }

  String getRegistrationStateTabRoute({@required Business business}) {
    final state = _getRegistrationState(business: business);
    if (state == RegistrationState.InitialCreate) {
      return "/auth/registration/welcome";
    }
    if (state == RegistrationState.MissingDetails) {
      return "/auth/registration/details";
    }
    if (state == RegistrationState.MissingAddress) {
      return "/auth/registration/address";
    }
    if (state == RegistrationState.MissingContact) {
      return "/auth/registration/contact";
    }
    return "/";
  }

  void pushRegistrationPage(BuildContext context, String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacementNamed(route);
    });
  }

  void pushRegistrationPageByBusiness(BuildContext context, Business business) {
    final route = getRegistrationStateTabRoute(business: business);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed(route);
    });
  }
}
