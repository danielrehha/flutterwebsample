part of 'business_portfolio_bloc.dart';

abstract class BusinessPortfolioState extends Equatable {
  const BusinessPortfolioState();
  
  @override
  List<Object> get props => [];
}

class BusinessPortfolioInitial extends BusinessPortfolioState {}

class BusinessPortfolioLoadedState extends BusinessPortfolioState {
  final String businessId;
  final List<ApplicationImage> images;

  BusinessPortfolioLoadedState(this.businessId, this.images);
}

class BusinessPortfolioErrorState extends BusinessPortfolioState {
  final Failure failure;

  BusinessPortfolioErrorState(this.failure);
}

class BusinessPortfolioLoadingState extends BusinessPortfolioState {
  
}
