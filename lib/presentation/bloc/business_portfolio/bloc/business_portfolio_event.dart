part of 'business_portfolio_bloc.dart';

abstract class BusinessPortfolioEvent extends Equatable {
  const BusinessPortfolioEvent();

  @override
  List<Object> get props => [];
}

class FetchBusinessPortfolioEvent extends BusinessPortfolioEvent {
  final String businessId;

  FetchBusinessPortfolioEvent(this.businessId);
}

class UploadBusinessPortfolioEvent extends BusinessPortfolioEvent {
  final String businessId;
  final PlatformFile file;

  UploadBusinessPortfolioEvent(this.businessId, this.file);
}

class DeleteBusinessPortfolioEvent extends BusinessPortfolioEvent {
  final String businessId;
  final String fileId;

  DeleteBusinessPortfolioEvent(this.businessId, this.fileId);
}

class CrossUpdateBusinessPortfolioBlocEvent extends BusinessPortfolioEvent {
  final String businessId;
  final List<ApplicationImage> images;

  CrossUpdateBusinessPortfolioBlocEvent(this.businessId, this.images);
}

class ResetBusinessPortfolioEvent extends BusinessPortfolioEvent {
  
}
