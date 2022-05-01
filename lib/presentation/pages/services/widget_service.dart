import 'package:allbert_cms/data/models/model_service.dart';
import 'package:allbert_cms/presentation/bloc/employee_bloc/employee_bloc.dart';
import 'package:allbert_cms/presentation/bloc/services_bloc/services_bloc.dart';
import 'package:allbert_cms/presentation/pages/services/page_service_details.dart';
import 'package:allbert_cms/presentation/popups/action_confirmation_popup.dart';
import 'package:allbert_cms/presentation/popups/edit_service_popup.dart';
import 'package:allbert_cms/presentation/shared/application_status_indicator.dart';
import 'package:allbert_cms/presentation/shared/application_widget_container.dart';
import 'package:allbert_cms/presentation/themes/theme_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:page_transition/page_transition.dart';

class ServiceWidget extends StatefulWidget {
  final ServiceModel service;

  ServiceWidget({Key key, @required this.service}) : super(key: key);

  @override
  _ServiceWidgetState createState() => _ServiceWidgetState();
}

class _ServiceWidgetState extends State<ServiceWidget> {
  @override
  Widget build(BuildContext context) {
    return ApplicationWidgetContainer(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.bottomToTop,
                child: ServiceDetailsPage(
                  service: widget.service,
                ),
                duration: globalPageTransitionDuration,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('ID: ${widget.service.publicId}'),
              Expanded(
                flex: 1,
                child: Text(
                  widget.service.name,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  widget.service.duration.toString() + ' perc',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  widget.service.cost.toString() +
                      ' ' +
                      widget.service.currency,
                  textAlign: TextAlign.center,
                ),
              ),
              ApplicationEntityStatusIndicator(
                enabled: widget.service.enabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
