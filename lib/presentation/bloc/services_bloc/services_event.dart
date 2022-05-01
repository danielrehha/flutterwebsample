part of 'services_bloc.dart';

abstract class ServicesEvent extends Equatable {
  const ServicesEvent();

  @override
  List<Object> get props => [];
}

class FetchServicesEvent extends ServicesEvent {
  final String businessId;

  FetchServicesEvent({@required this.businessId});
}

class AddServiceEvent extends ServicesEvent {
  final ServiceModel service;

  AddServiceEvent({@required this.service});
}

class EditServiceEvent extends ServicesEvent {
  final ServiceModel service;

  EditServiceEvent({@required this.service});
}

class DeleteServiceEvent extends ServicesEvent {
  final String serviceId;

  DeleteServiceEvent({@required this.serviceId});
}

class ResetServicesEvent extends ServicesEvent {}
