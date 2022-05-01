part of 'services_bloc.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object> get props => [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoadedState extends ServicesState {
  final List<ServiceModel> services;

  ServicesLoadedState({@required this.services});
}

class ServicesErrorState extends ServicesState {
  final Failure failure;

  ServicesErrorState({@required this.failure});
}

class ServicesAwaitingState extends ServicesState {}
