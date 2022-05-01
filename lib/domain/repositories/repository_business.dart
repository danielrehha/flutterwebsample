import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/core/failures/failure.dart';
import 'package:allbert_cms/data/models/dtos/dto_employee_schedule_update.dart';
import 'package:allbert_cms/domain/dtos/dto_customer_list_view.dart';
import 'package:allbert_cms/domain/entities/entity_application_image.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:allbert_cms/domain/entities/entity_business.dart';
import 'package:allbert_cms/domain/entities/entity_employee.dart';
import 'package:allbert_cms/domain/entities/entity_employee_settings.dart';
import 'package:allbert_cms/domain/entities/entity_notification.dart';
import 'package:allbert_cms/domain/entities/entity_workday.dart';
import 'package:allbert_cms/domain/enums/enum_appointment_status.dart';
import 'package:allbert_cms/domain/helpers/appointment_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/customer_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/notification_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/paginated_list.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

abstract class IBusinessRepository {
  Future<Either<Failure, Business>> getByFirebaseUidAsync(
      {@required String firebaseUid});

  Future<Either<Failure, ApplicationImage>> uploadBusinessAvatarImageAsync(
      {@required String businessId, @required PlatformFile file});
  Future<Either<Failure, void>> deleteBusinessAvatarImageAsync(
      {@required String businessId});

  Future<Either<Failure, List<ApplicationImage>>> getBusinessPortfolioAsync(
      {@required String businessId});
  Future<Either<Failure, ApplicationImage>> uploadBusinessPortfolioImageAsync(
      {@required String businessId, @required PlatformFile file});
  Future<Either<Failure, void>> deleteBusinessPortfolioImageAsync(
      {@required String businessId, @required String fileId});

  Future<Either<Failure, List<Employee>>> getEmployeeScheduleListAsync(
      {@required String businessId, @required DateTime from, @required DateTime until});
  Future<Either<Failure, PagedList<Appointment>>>
      getBusinessAppointmentListAsyncV2(
          {@required String businessId,
          AppointmentQueryParameters parameters,
          String url});
  Future<Either<Failure, void>> updateAppointmentStatusAsync(
      {@required String appointmentId, @required AppointmentStatus status});

  Future<Either<Failure, List<Employee>>> getScheduleAsync(
      {@required String businessId});
  Future<Either<Failure, EmployeeScheduleUpdateDto>> updateScheduleAsync(
      {@required String employeeId,
      @required List<WorkDay> workDayList,
    });
  Future<Either<Failure, PagedList<CustomerListView>>>
      getBusinessCustomerListAsync(
          {@required String businessId,
          CustomerQueryParameters parameters,
          String url});
  Future<Either<Failure, PagedList<Notification>>> getBusinessNotificationList(
      {@required String businessId,
      NotificationQueryParameters parameters,
      String url});
}

class BusinessRepository implements IBusinessRepository {
  final IApiDataSource dataSource;

  BusinessRepository({@required this.dataSource});

  @override
  Future<Either<Failure, Business>> getByFirebaseUidAsync(
      {@required String firebaseUid}) async {
    try {
      final result =
          await dataSource.getByFirebaseUidAsync(firebaseUid: firebaseUid);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBusinessAvatarImageAsync(
      {String businessId}) async {
    try {
      await dataSource.deleteBusinessAvatarImageAsync(businessId: businessId);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApplicationImage>> uploadBusinessAvatarImageAsync(
      {String businessId, PlatformFile file}) async {
    try {
      final result = await dataSource.uploadBusinessAvatarImageAsync(
          businessId: businessId, file: file);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBusinessPortfolioImageAsync(
      {String businessId, String fileId}) async {
    try {
      await dataSource.deleteBusinessPortfolioImageAsync(
          businessId: businessId, fileId: fileId);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ApplicationImage>>> getBusinessPortfolioAsync(
      {String businessId}) async {
    try {
      final result =
          await dataSource.getBusinessPortfolioAsync(businessId: businessId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApplicationImage>> uploadBusinessPortfolioImageAsync(
      {String businessId, PlatformFile file}) async {
    try {
      final result = await dataSource.uploadBusinessPortfolioImageAsync(
          businessId: businessId, file: file);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Employee>>> getEmployeeScheduleListAsync(
      {@required String businessId, @required DateTime from, @required DateTime until}) async {
    try {
      final result =
          await dataSource.loadCalendarAsync(businessId: businessId);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PagedList<Appointment>>>
      getBusinessAppointmentListAsyncV2(
          {@required String businessId,
          AppointmentQueryParameters parameters,
          String url}) async {
    try {
      final result = await dataSource.getBusinessAppointmentListAsyncV2(
          businessId: businessId, parameters: parameters, url: url);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAppointmentStatusAsync(
      {@required String appointmentId, @required AppointmentStatus status}) async {
    try {
      await dataSource.updateAppointmentStatusAsync(
          appointmentId: appointmentId, status: status);
      return Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Employee>>> getScheduleAsync(
      {@required String businessId}) async {
    try {
      final result = await dataSource.getScheduleAsync(
        businessId: businessId,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EmployeeScheduleUpdateDto>> updateScheduleAsync(
      {@required String employeeId,
      @required List<WorkDay> workDayList,
      @required EmployeeSettings scheduleSettings}) async {
    try {
      final result = await dataSource.updateScheduleAsync(
          employeeId: employeeId,
          workDayList: workDayList,
       );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PagedList<CustomerListView>>>
      getBusinessCustomerListAsync(
          {String businessId,
          CustomerQueryParameters parameters,
          String url}) async {
    try {
      final result = await dataSource.getBusinessCustomerListAsync(
          businessId: businessId, parameters: parameters, url: url);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PagedList<Notification>>> getBusinessNotificationList({
    String businessId,
    NotificationQueryParameters parameters,
    String url,
  }) async {
    try {
      final result = await dataSource.getBusinessNotificationList(businessId: businessId, parameters: parameters, url: url);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
