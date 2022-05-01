import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/entities/entity_employee_info.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';

abstract class IEmployeeRepository {
  Future<Either<Failure, List<Employee>>> getEmployeeListAsync(
      {@required String businessId});
  Future<Either<Failure, Employee>> createEmployeeAsync(
      {@required String businessId, @required EmployeeInfo employeeInfo});
  Future<Either<Failure, EmployeeInfo>> updateEmployeeAsync(
      {@required EmployeeInfo employeeInfo});
  Future<Either<Failure, void>> deleteEmployeeAsync(
      {@required String employeeId});

  Future<Either<Failure, List<ApplicationImage>>> getEmployeePortfolioListAsync(
      {@required String employeeId});
  Future<Either<Failure, ApplicationImage>> uploadEmployeePortfolioAsync(
      {@required String employeeId, @required PlatformFile file});
  Future<Either<Failure, void>> deleteEmployeePortfolioAsync(
      {@required String employeeId, @required String fileId});

  Future<Either<Failure, void>> deleteAvailableTimeslotAsync(
      {@required String employeeId, @required String timeslotId});

  Future<Either<Failure, ApplicationImage>> uploadEmployeeAvatarImageAsync(
      {@required String employeeId, @required PlatformFile file});
  Future<Either<Failure, void>> deleteEmployeeAvatarImageAsync(
      {@required String employeeId});

  Future<Either<Failure, List<Appointment>>> deleteBooking(
      {@required String employeeId, @required String bookingId});
  Future<Either<Failure, List<Service>>> getEmployeeServiceListAsync(
      {@required String employeeId});
}

class EmployeeRepository implements IEmployeeRepository {
  final IApiDataSource dataSource;

  EmployeeRepository({@required this.dataSource});

  @override
  Future<Either<Failure, Employee>> createEmployeeAsync(
      {@required String businessId,
      @required EmployeeInfo employeeInfo}) async {
    try {
      final result = await dataSource.createEmployeeAsync(
          businessId: businessId, employeeInfo: employeeInfo);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Employee>>> getEmployeeListAsync(
      {@required String businessId}) async {
    try {
      final result =
          await dataSource.getEmployeeListAsync(businessId: businessId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmployeeInfo>> updateEmployeeAsync(
      {@required EmployeeInfo employeeInfo}) async {
    try {
      final result = await dataSource.updateEmployeeAsync(
          employeeId: employeeInfo.employeeId, employeeInfo: employeeInfo);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployeeAsync(
      {@required String employeeId}) async {
    try {
      await dataSource.deleteEmployeeAsync(employeeId: employeeId);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Appointment>>> deleteBooking(
      {String employeeId, String bookingId}) async {
    try {
      final result = null;
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployeeAvatarImageAsync(
      {String employeeId}) async {
    try {
      await dataSource.deleteEmployeeAvatarImageAsync(employeeId: employeeId);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApplicationImage>> uploadEmployeeAvatarImageAsync(
      {String employeeId, PlatformFile file}) async {
    try {
      final result = await dataSource.uploadEmployeeAvatarImageAsync(
          employeeId: employeeId, file: file);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ApplicationImage>>> getEmployeePortfolioListAsync(
      {String employeeId}) async {
    try {
      final result = await dataSource.getEmployeePortfolioListAsync(
          employeeId: employeeId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployeePortfolioAsync(
      {String employeeId, String fileId}) async {
    try {
      await dataSource.deleteEmployeePortfolioAsync(
          employeeId: employeeId, fileId: fileId);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApplicationImage>> uploadEmployeePortfolioAsync(
      {String employeeId, PlatformFile file}) async {
    try {
      final result = await dataSource.uploadEmployeePortfolioAsync(
          employeeId: employeeId, file: file);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAvailableTimeslotAsync(
      {String employeeId, String timeslotId}) async {
    try {
      await dataSource.deleteAvailableTimeslotAsync(
          employeeId: employeeId, timeslotId: timeslotId);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Service>>> getEmployeeServiceListAsync(
      {String employeeId}) async {
    try {
      final result =
          await dataSource.getEmployeeServiceListAsync(employeeId: employeeId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
