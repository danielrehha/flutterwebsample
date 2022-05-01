import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

abstract class IServiceRepository {
  Future<Either<Failure, List<Service>>> getServiceListAsync(
      {@required String businessId});
  Future<Either<Failure, Service>> createServiceAsync(
      {@required Service service});
  Future<Either<Failure, Service>> updateServiceAsync(
      {@required Service service});
  Future<Either<Failure, void>> deleteServiceAsync(
      {@required String serviceId});
}

class ServiceRepository implements IServiceRepository {
  final IApiDataSource dataSource;

  ServiceRepository({@required this.dataSource});

  @override
  Future<Either<Failure, List<Service>>> getServiceListAsync(
      {@required String businessId}) async {
    try {
      final result =
          await dataSource.getServiceListAsync(businessId: businessId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Service>> createServiceAsync(
      {@required Service service}) async {
    try {
      final result = await dataSource.createServiceAsync(service: service);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Service>> updateServiceAsync(
      {@required Service service}) async {
    try {
      final result = await dataSource.updateServiceAsync(service: service);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteServiceAsync(
      {@required String serviceId}) async {
    try {
      await dataSource.deleteServiceAsync(serviceId: serviceId);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
