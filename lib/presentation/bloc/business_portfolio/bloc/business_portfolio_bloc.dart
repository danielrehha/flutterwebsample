import 'dart:async';

import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:allbert_cms/domain/repositories/repository_business.dart';
import 'package:allbert_cms/presentation/bloc/helpers/result_fold_helper.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'business_portfolio_event.dart';
part 'business_portfolio_state.dart';

class BusinessPortfolioBloc extends Bloc<BusinessPortfolioEvent, BusinessPortfolioState> {
  BusinessPortfolioBloc({@required this.repository}) : super(BusinessPortfolioInitial());

  final IBusinessRepository repository;
  final ResultFoldHelper foldHelper = ResultFoldHelper();

  BusinessPortfolioLoadedState previousLoadedState = BusinessPortfolioLoadedState(null, []);

  @override
  Stream<BusinessPortfolioState> mapEventToState(
    BusinessPortfolioEvent event,
  ) async* {
    yield BusinessPortfolioLoadingState();
    if(event is FetchBusinessPortfolioEvent) {
      final result = await repository.getBusinessPortfolioAsync(businessId: event.businessId);
      if(result.isRight()) {
        previousLoadedState = BusinessPortfolioLoadedState(event.businessId, result.getOrElse(() => null));
        yield previousLoadedState;
      } else {
        yield BusinessPortfolioErrorState(foldHelper.extract(result));
      }
    }
    if(event is UploadBusinessPortfolioEvent) {
      final result = await repository.uploadBusinessPortfolioImageAsync(businessId: event.businessId, file: event.file);
      if(result.isRight()) {
        previousLoadedState.images.add(result.getOrElse(() => null));
        yield previousLoadedState;
      } else {
        yield BusinessPortfolioErrorState(foldHelper.extract(result));
      }
    }
    if(event is DeleteBusinessPortfolioEvent) {
      final result = await repository.deleteBusinessPortfolioImageAsync(businessId: event.businessId, fileId: event.fileId);
      if(result.isRight()) {
        var removedImage = previousLoadedState.images.firstWhere((element) => element.id == event.fileId);
        int indexOf = previousLoadedState.images.indexOf(removedImage);
        previousLoadedState.images.removeAt(indexOf);
        yield previousLoadedState;
      }
    }
    if(event is CrossUpdateBusinessPortfolioBlocEvent) {
      previousLoadedState = BusinessPortfolioLoadedState(event.businessId, event.images);
      yield previousLoadedState;
    }
    if(event is ResetBusinessPortfolioEvent) {
      yield BusinessPortfolioInitial();
    }
  }
}
