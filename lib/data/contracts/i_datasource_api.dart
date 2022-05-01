import 'package:allbert_cms/data/models/dtos/dto_employee_schedule_update.dart';
import 'package:allbert_cms/data/models/model_application_image.dart';
import 'package:allbert_cms/data/models/model_appointment.dart';
import 'package:allbert_cms/data/models/model_business.dart';
import 'package:allbert_cms/data/models/model_business_address.dart';
import 'package:allbert_cms/data/models/model_business_contact.dart';
import 'package:allbert_cms/data/models/model_business_details.dart';
import 'package:allbert_cms/data/models/model_business_settings.dart';
import 'package:allbert_cms/data/models/model_customer.dart';
import 'package:allbert_cms/data/models/model_employee.dart';
import 'package:allbert_cms/data/models/model_employee_info.dart';
import 'package:allbert_cms/data/models/model_employee_schedule_settings.dart';
import 'package:allbert_cms/data/models/model_employee_work_block.dart';
import 'package:allbert_cms/data/models/model_notification.dart';
import 'package:allbert_cms/data/models/model_service.dart';
import 'package:allbert_cms/data/models/model_workday.dart';
import 'package:allbert_cms/domain/dtos/dto_customer_details.dart';
import 'package:allbert_cms/domain/dtos/dto_customer_list_view.dart';
import 'package:allbert_cms/domain/dtos/dto_employee_name.dart';
import 'package:allbert_cms/domain/dtos/dto_statistics_appointment_count.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:allbert_cms/domain/entities/entity_customer_review.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/domain/enums/enum_appointment_status.dart';
import 'package:allbert_cms/domain/enums/enum_entity_status.dart';
import 'package:allbert_cms/domain/enums/enum_entity_type.dart';
import 'package:allbert_cms/domain/helpers/appointment_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/customer_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/customer_review_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/notification_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/paginated_list.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

abstract class IApiDataSource {
  Future<BusinessModel> getByFirebaseUidAsync({@required String firebaseUid});

  Future<ApplicationImageModel> uploadBusinessAvatarImageAsync(
      {@required String businessId, @required PlatformFile file});
  Future<void> deleteBusinessAvatarImageAsync({@required String businessId});

  Future<List<ApplicationImageModel>> getBusinessPortfolioAsync(
      {@required String businessId});
  Future<ApplicationImageModel> uploadBusinessPortfolioImageAsync(
      {@required String businessId, @required PlatformFile file});
  Future<void> deleteBusinessPortfolioImageAsync(
      {@required String businessId, @required String fileId});

  Future<List<ApplicationImageModel>> getEmployeePortfolioListAsync(
      {@required String employeeId});
  Future<ApplicationImageModel> uploadEmployeePortfolioAsync(
      {@required String employeeId, @required PlatformFile file});
  Future<void> deleteEmployeePortfolioAsync(
      {@required String employeeId, @required String fileId});

  Future<List<EmployeeModel>> getEmployeeListAsync(
      {@required String businessId});
  Future<EmployeeModel> createEmployeeAsync(
      {@required String businessId, @required EmployeeInfoModel employeeInfo});
  Future<EmployeeInfoModel> updateEmployeeAsync(
      {@required String employeeId, @required EmployeeInfoModel employeeInfo});
  Future<void> deleteEmployeeAsync({@required String employeeId});

  Future<ApplicationImageModel> uploadEmployeeAvatarImageAsync(
      {@required String employeeId, @required PlatformFile file});
  Future<void> deleteEmployeeAvatarImageAsync({@required String employeeId});

  Future<void> deleteAvailableTimeslotAsync(
      {@required String employeeId, @required String timeslotId});
  Future<List<EmployeeModel>> loadCalendarAsync(
      {@required String businessId,
      List<String> employeeIds = const [],
      @required DateTime from,
      @required DateTime until});

  Future<List<ServiceModel>> getServiceListAsync({@required String businessId});
  Future<ServiceModel> createServiceAsync({@required ServiceModel service});
  Future<ServiceModel> updateServiceAsync({@required ServiceModel service});
  Future<void> deleteServiceAsync({@required String serviceId});

  Future<List<CustomerModel>> searchCustomerListAsync({String customerFlair});

  Future<PagedList<Appointment>> getBusinessAppointmentListAsyncV2(
      {@required String businessId,
      AppointmentQueryParameters parameters,
      String url});
  Future<PagedList<CustomerListView>> getBusinessCustomerListAsync(
      {@required String businessId,
      CustomerQueryParameters parameters,
      String url});

  Future<void> updateAppointmentStatusAsync(
      {@required String appointmentId, @required AppointmentStatus status});
  Future<List<EmployeeModel>> getScheduleAsync({@required String businessId});
  Future<EmployeeScheduleUpdateDto> updateScheduleAsync({
    @required String employeeId,
    @required List<WorkDayModel> workDayList,
  });
  Future<CustomerDetailsDto> getCustomerDetailsAsync(
      {@required String customerId});
  Future<PagedList<NotificationModel>> getBusinessNotificationList(
      {@required String businessId,
      NotificationQueryParameters parameters,
      String url});
  Future<void> updateBusinessSettingsAsync(
      {@required String businessId, @required BusinessSettingsModel settings});
  Future<void> banCustomerAsync(
      {@required String businessId, @required String customerId});
  Future<void> unBanCustomerAsync(
      {@required String businessId, @required String customerId});
  Future<List<Service>> getEmployeeServiceListAsync(
      {@required String employeeId});
  Future<void> updateBusinessDetailsAsync(
      {@required String businessId, @required BusinessDetailsModel details});
  Future<void> updateBusinessAddressAsync(
      {@required String businessId, @required BusinessAddressModel address});
  Future<void> updateBusinessContactAsync(
      {@required String businessId, @required BusinessContactModel contact});
  Future<BusinessModel> createBusinessAsyncV2(
      {@required String firebaseUid, @required String langIso639Code});
  Future<void> createAppointmentAsync({@required AppointmentModel appointment});
  Future<EmployeeSettingsModel> getEmployeeSettingsAsync(
      {@required String employeeId});
  Future<void> updateEmployeeSettingsAsync(
      {@required String employeeId, @required EmployeeSettingsModel settings});

  Future<void> updateEntityStatusAsync(
      {@required String entityId,
      @required EntityType entityType,
      @required EntityStatus status});

  Future<void> createWorkBlockAsync(
      {@required String employeeId,
      @required EmployeeWorkBlockModel workBlock});
  Future<void> updateWorkBlockAsync(
      {@required String employeeId,
      @required EmployeeWorkBlockModel workBlock});
  Future<void> deleteWorkBlockAsync(
      {@required String employeeId, @required String workBlockId});

  Future<void> updateAppointmentAsync(
      {@required String appointmentId, @required AppointmentModel appointment});

  Future<PagedList<CustomerReview>> GetCustomerReviewListAsync(
      {@required CustomerReviewQueryParameters parameters, String pageUrl});

  Future<List<AppointmentCountStatisticsDto>> GetStatisticsAppointmentCount(
      {@required String businessId,
      List<String> employeeIds = const [],
      @required DateTime from,
      @required DateTime until});
  Future<List<EmployeeNameDto>> GetEmployeeNameListAsync(
      {@required String businessId});
}
