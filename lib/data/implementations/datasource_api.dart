import 'dart:convert';

import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/endpoints/endpoint_naming_context.dart';
import 'package:allbert_cms/data/helpers/crud_request_handler.dart' as parser;
import 'package:allbert_cms/data/models/model_business_details.dart';
import 'package:allbert_cms/data/models/model_business_contact.dart';
import 'package:allbert_cms/data/models/model_business_address.dart';
import 'package:allbert_cms/data/models/model_business_settings.dart';
import 'package:allbert_cms/data/models/model_customer.dart';
import 'package:allbert_cms/data/models/model_customer_review.dart';
import 'package:allbert_cms/data/models/model_employee_work_block.dart';
import 'package:allbert_cms/data/models/model_notification.dart';
import 'package:allbert_cms/domain/dtos/dto_customer_details.dart';
import 'package:allbert_cms/domain/dtos/dto_customer_list_view.dart';
import 'package:allbert_cms/domain/dtos/dto_employee_name.dart';
import 'package:allbert_cms/domain/dtos/dto_statistics_appointment_count.dart';
import 'package:allbert_cms/domain/entities/entity_customer_review.dart';
import 'package:allbert_cms/domain/entities/entity_service.dart';
import 'package:allbert_cms/domain/enums/enum_appointment_status.dart';
import 'package:allbert_cms/domain/enums/enum_entity_type.dart';
import 'package:allbert_cms/domain/enums/enum_entity_status.dart';
import 'package:allbert_cms/domain/helpers/customer_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/customer_review_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/helper_enum_convert.dart';
import 'package:allbert_cms/domain/helpers/notification_query_parameters.dart';
import 'package:allbert_cms/data/models/dtos/dto_employee_schedule_update.dart';
import 'package:allbert_cms/data/models/model_application_image.dart';
import 'package:allbert_cms/data/models/model_appointment.dart';
import 'package:allbert_cms/data/models/model_employee_schedule_settings.dart';
import 'package:allbert_cms/data/models/model_service.dart';
import 'package:allbert_cms/data/models/model_employee_info.dart';
import 'package:allbert_cms/data/models/model_employee.dart';
import 'package:allbert_cms/data/models/model_business.dart';
import 'package:allbert_cms/data/models/model_workday.dart';
import 'package:allbert_cms/domain/entities/entity_appointment.dart';
import 'package:allbert_cms/domain/helpers/appointment_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/paginated_list.dart';
import 'package:allbert_cms/domain/helpers/pagination_data.dart';
import 'package:allbert_cms/domain/utils/utils_appointment.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

const String genericErrorResponse = "Error occured while performing request";

class ApiDataSource implements IApiDataSource {
  final EndpointNamingContext endpoints = EndpointNamingContext();

  final parser.CrudRequestHandler _handler = parser.CrudRequestHandler();
  final Dio dio = Dio();
  final AppointmentUtils appointmentUtils = AppointmentUtils();
  final EnumConvert _enumConvert = EnumConvert();

  ApiDataSource();

  @override
  Future<EmployeeModel> createEmployeeAsync(
      {String businessId, EmployeeInfoModel employeeInfo}) async {
    final result = await _handler.post(
      url: endpoints.createEmployeeAsync(businessId),
      data: employeeInfo.toJson(),
    );
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
    return EmployeeModel.fromJson(result["employee"]);
  }

  @override
  Future<ServiceModel> createServiceAsync(
      {@required ServiceModel service}) async {
    final result = await _handler.postRaw(
      url: endpoints.createServiceAsync(),
      data: service.toJson(),
    );
    final data = result.data;
    if (result.statusCode != 200) {
      throw new ServerException(data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(
          data["errorMessage"] ?? data["validationErrors"][0]);
    }
    return ServiceModel.fromJson(data["service"]);
  }

  @override
  Future<void> deleteBusinessAvatarImageAsync(
      {@required String businessId}) async {
    final result = await _handler.delete(
      url: endpoints.deleteBusinessAvatarImageAsync(businessId),
    );
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
  }

  @override
  Future<void> deleteBusinessPortfolioImageAsync(
      {@required String businessId, @required String fileId}) async {
    final result = await _handler.delete(
        url: endpoints.deleteBusinessPortfolioImageAsync(businessId, fileId));
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
  }

  @override
  Future<void> deleteEmployeeAsync({@required String employeeId}) async {
    final result =
        await _handler.delete(url: endpoints.deleteEmployeeAsync(employeeId));
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
  }

  @override
  Future<void> deleteServiceAsync({@required String serviceId}) async {
    final result =
        await _handler.delete(url: endpoints.deleteServiceAsync(serviceId));
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
  }

  @override
  Future<BusinessModel> getByFirebaseUidAsync({String firebaseUid}) async {
    final result = await _handler.get(
      url: endpoints.getByFirebaseUidAsync(firebaseUid),
    );
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
    if (result["business"] == null) {
      return null;
    }
    return BusinessModel.fromJson(result["business"]);
  }

  @override
  Future<List<EmployeeModel>> getEmployeeListAsync({String businessId}) async {
    final result = await _handler.get(
      url: endpoints.getEmployeeListAsync(businessId),
    );
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
    List<EmployeeModel> employees = [];
    for (var emp in result["employees"]) {
      employees.add(EmployeeModel.fromJson(emp));
    }
    return employees;
  }

  @override
  Future<List<ServiceModel>> getServiceListAsync({String businessId}) async {
    final result = await _handler.get(
      url: endpoints.getServiceListAsync(businessId),
    );
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
    List<ServiceModel> services = [];
    for (var service in result["services"]) {
      services.add(ServiceModel.fromJson(service));
    }
    return services;
  }

  @override
  Future<EmployeeInfoModel> updateEmployeeAsync(
      {@required String employeeId,
      @required EmployeeInfoModel employeeInfo}) async {
    final result = await _handler.post(
      url: endpoints.updateEmployeeAsync(employeeId),
      data: employeeInfo.toJson(),
    );
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
    return EmployeeInfoModel.fromJson(result["employeeInfo"]);
  }

  @override
  Future<ServiceModel> updateServiceAsync(
      {@required ServiceModel service}) async {
    final result = await _handler.postRaw(
      url: endpoints.updateServiceAsync(service.id),
      data: service.toJson(),
    );
    final data = result.data;
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(
          data["errorMessage"] ?? data["validationErrors"][0]);
    }
    return ServiceModel.fromJson(data["service"]);
  }

  @override
  Future<ApplicationImageModel> uploadBusinessAvatarImageAsync(
      {@required String businessId, @required PlatformFile file}) async {
    final data = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        file.bytes,
        filename: "fileName",
      ),
    });
    final result = await dio.post(
      endpoints.uploadBusinessAvatarImageAsync(businessId),
      data: data,
      options: Options(
          headers: {"Accept": "*/*", "Content-Type": "multipart/form-data"},
          validateStatus: (status) {
            return status <= 500;
          }),
    );
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    return ApplicationImageModel.fromJson(result.data["image"]);
  }

  @override
  Future<ApplicationImageModel> uploadBusinessPortfolioImageAsync(
      {@required String businessId, @required PlatformFile file}) async {
    final data = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        file.bytes,
        filename: "fileName",
      ),
    });
    final result = await dio.post(
      endpoints.uploadBusinessPortfolioImageAsync(businessId),
      data: data,
      options: Options(
          headers: {"Accept": "*/*", "Content-Type": "multipart/form-data"},
          validateStatus: (status) {
            return status <= 500;
          }),
    );
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    return ApplicationImageModel.fromJson(result.data["image"]);
  }

  @override
  Future<void> deleteEmployeeAvatarImageAsync(
      {@required String employeeId}) async {
    final result = await _handler.delete(
      url: endpoints.deleteEmployeeAvatarImageAsync(employeeId),
    );
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
  }

  @override
  Future<ApplicationImageModel> uploadEmployeeAvatarImageAsync(
      {@required String employeeId, @required PlatformFile file}) async {
    final data = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        file.bytes,
        filename: "fileName",
      ),
    });
    final result = await dio.post(
      endpoints.uploadEmployeeAvatarImageAsync(employeeId),
      data: data,
      options: Options(
          headers: {"Accept": "*/*", "Content-Type": "multipart/form-data"},
          validateStatus: (status) {
            return status <= 500;
          }),
    );
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    return ApplicationImageModel.fromJson(result.data["image"]);
  }

  @override
  Future<List<ApplicationImageModel>> getBusinessPortfolioAsync(
      {String businessId}) async {
    final result = await _handler.get(
        url: endpoints.getBusinessPortfolioAsync(businessId));
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
    List<ApplicationImageModel> images = [];
    for (var image in result["images"]) {
      images.add(ApplicationImageModel.fromJson(image));
    }
    return images;
  }

  @override
  Future<void> deleteEmployeePortfolioAsync(
      {String employeeId, String fileId}) async {
    final result = await _handler.delete(
        url: endpoints.deleteEmployeePortfolioAsync(employeeId, fileId));
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
  }

  @override
  Future<List<ApplicationImageModel>> getEmployeePortfolioListAsync(
      {String employeeId}) async {
    final result = await _handler.get(
        url: endpoints.getEmployeePortfolioListAsync(employeeId));
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
    List<ApplicationImageModel> images = [];
    for (var image in result["images"]) {
      images.add(ApplicationImageModel.fromJson(image));
    }
    return images;
  }

  @override
  Future<ApplicationImageModel> uploadEmployeePortfolioAsync(
      {String employeeId, PlatformFile file}) async {
    final data = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        file.bytes,
        filename: "fileName",
      ),
    });
    final result = await dio.post(
      endpoints.uploadEmployeePortfolioAsync(employeeId),
      data: data,
      options: Options(
          headers: {"Accept": "*/*", "Content-Type": "multipart/form-data"},
          validateStatus: (status) {
            return status <= 500;
          }),
    );
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    return ApplicationImageModel.fromJson(result.data["image"]);
  }

  @override
  Future<void> deleteAvailableTimeslotAsync(
      {@required String employeeId, @required String timeslotId}) async {
    final result = await _handler.delete(
        url: endpoints.deleteAvailableTimeslotAsync(employeeId, timeslotId));
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
  }

  @override
  Future<List<EmployeeModel>> loadCalendarAsync({
    @required String businessId,
    List<String> employeeIds = const [],
    @required DateTime from,
    @required DateTime until,
  }) async {
    final result = await _handler.postRaw(
        url: endpoints.getEmployeeScheduleListAsync(businessId, from, until), data: jsonEncode(employeeIds));
    final data = result.data;
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(
          data["errorMessage"] ?? data["validationErrors"][0]);
    }
    List<EmployeeModel> employees = [];
    for (var employee in data["employees"]) {
      employees.add(EmployeeModel.fromJson(employee));
    }
    return employees;
  }

  @override
  Future<void> updateAppointmentStatusAsync(
      {@required String appointmentId,
      @required AppointmentStatus status}) async {
    final statusValue = appointmentUtils.getAppointmentStatusValue(status);
    final result = await _handler.get(
        url: endpoints.updateAppointmentStatusAsync(
            appointmentId: appointmentId, status: statusValue));
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
  }

  @override
  Future<List<EmployeeModel>> getScheduleAsync(
      {@required String businessId}) async {
    final result = await _handler.get(
        url: endpoints.getScheduleAsync(businessId: businessId));
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
    List<EmployeeModel> employees = [];
    for (var employee in result["employees"]) {
      employees.add(EmployeeModel.fromJson(employee));
    }
    return employees;
  }

  @override
  Future<EmployeeScheduleUpdateDto> updateScheduleAsync({
    @required String employeeId,
    @required List<WorkDayModel> workDayList,
  }) async {
    EmployeeScheduleUpdateDto dto =
        EmployeeScheduleUpdateDto(workDayList: workDayList);
    final jsonData = dto.toJson();
    final result = await _handler.post(
        url: endpoints.updateScheduleAsync(employeeId: employeeId),
        data: jsonData);
    if (!result["success"]) {
      throw new ServerException(
          result["errorMessage"] ?? result["validationErrors"][0]);
    }
    List<WorkDayModel> returnWdList = [];
    for (var wd in result["workDayList"]) {
      returnWdList.add(WorkDayModel.fromJson(wd));
    }
    final returnDto = EmployeeScheduleUpdateDto(workDayList: returnWdList);
    return returnDto;
  }

  @override
  Future<CustomerDetailsDto> getCustomerDetailsAsync(
      {@required String customerId}) async {
    final result = await _handler.getWithRawResponseDio(
        url: endpoints.getCustomerDetailsAsync(customerId: customerId));
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"]) {
      throw new ServerException(
          body["errorMessage"] ?? body["validationErrors"][0]);
    }
    final dto = CustomerDetailsDto.fromJson(body["customerDetails"]);
    return dto;
  }

  @override
  Future<PagedList<CustomerListView>> getBusinessCustomerListAsync(
      {String businessId,
      CustomerQueryParameters parameters,
      String url}) async {
    //final newUrl = "https://$HOST_URI/api" + url ?? "";
    final result = await _handler.getWithRawResponseDio(
        url: url == null
            ? endpoints.getBusinessCustomerListAsync(
                businessId: businessId, parameters: parameters)
            : API_URI_BASE + url);
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"]) {
      throw new ServerException(
          body["errorMessage"] ?? body["validationErrors"][0]);
    }
    PagedList<CustomerListView> customers = PagedList.empty();
    for (var customer in body["customers"]) {
      customers.items.add(CustomerListView.fromJson(customer));
    }
    customers.paginationData = PaginationData.fromJson(body["paginationData"]);
    return customers;
  }

  @override
  Future<PagedList<Appointment>> getBusinessAppointmentListAsyncV2(
      {@required String businessId,
      AppointmentQueryParameters parameters,
      String url}) async {
    final localUrl = endpoints.getBusinessAppointmentListAsyncV2(
        businessId: businessId, parameters: parameters);
    final newUrl = API_URI_BASE + (url ?? "");
    final result = await _handler.getWithRawResponseDio(
        url: url == null ? localUrl : newUrl);
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"]) {
      throw new ServerException(
          body["errorMessage"] ?? body["validationErrors"][0]);
    }
    PagedList<Appointment> appointments = PagedList.empty();
    for (var appointment in body["appointments"]) {
      appointments.items.add(AppointmentModel.fromJson(appointment));
    }
    appointments.paginationData =
        PaginationData.fromJson(body["paginationData"]);
    return appointments;
  }

  @override
  Future<PagedList<NotificationModel>> getBusinessNotificationList(
      {String businessId,
      NotificationQueryParameters parameters,
      String url}) async {
    final newUrl = API_URI_BASE + (url ?? "");
    final result = await _handler.getWithRawResponseDio(
        url: url == null
            ? endpoints.getBusinessNotificationListAsync(
                businessId: businessId, parameters: parameters)
            : newUrl);
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"]) {
      throw new ServerException(
          body["errorMessage"] ?? body["validationErrors"][0]);
    }
    PagedList<NotificationModel> notifications = PagedList.empty();
    for (var notification in body["notifications"]) {
      notifications.items.add(NotificationModel.fromJson(notification));
    }
    notifications.paginationData =
        PaginationData.fromJson(body["paginationData"]);
    return notifications;
  }

  @override
  Future<void> updateBusinessSettingsAsync(
      {@required String businessId,
      @required BusinessSettingsModel settings}) async {
    final result = await _handler.postRaw(
      url: endpoints.updateBusinessSettingsAsync(businessId: businessId),
      data: settings.toJson(),
    );
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"]) {
      throw new ServerException(
          body["errorMessage"] ?? body["validationErrors"][0]);
    }
  }

  @override
  Future<void> banCustomerAsync({String businessId, String customerId}) async {
    final result = await _handler.getWithRawResponseDio(
        url: endpoints.banCustomerAsync(
            businessId: businessId, customerId: customerId));
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"]) {
      throw new ServerException(
          body["errorMessage"] ?? body["validationErrors"][0]);
    }
  }

  @override
  Future<void> unBanCustomerAsync(
      {String businessId, String customerId}) async {
    final result = await _handler.getWithRawResponseDio(
        url: endpoints.unBanCustomerAsync(
            businessId: businessId, customerId: customerId));
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"]) {
      throw new ServerException(
          body["errorMessage"] ?? body["validationErrors"][0]);
    }
  }

  @override
  Future<List<Service>> getEmployeeServiceListAsync(
      {@required String employeeId}) async {
    final result = await _handler.getRaw(
        url: endpoints.getEmployeeServiceListAsync(employeeId: employeeId));
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"] || body["hadErrors"]) {
      throw new ServerException(body["errorMessage"]);
    }
    List<Service> services = [];
    for (var service in body["services"]) {
      services.add(ServiceModel.fromJson(service));
    }
    return services;
  }

  @override
  Future<void> updateBusinessAddressAsync(
      {String businessId, BusinessAddressModel address}) async {
    final result = await _handler.postRaw(
      url: endpoints.updateBusinessAddressAsync(businessId: businessId),
      data: address.toJson(),
    );
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"]) {
      throw new ServerException(
          body["errorMessage"] ?? body["validationErrors"][0]);
    }
  }

  @override
  Future<void> updateBusinessDetailsAsync(
      {String businessId, BusinessDetailsModel details}) async {
    final result = await _handler.postRaw(
      url: endpoints.updateBusinessDetailsAsync(businessId: businessId),
      data: details.toJson(),
    );
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"]) {
      throw new ServerException(
          body["errorMessage"] ?? body["validationErrors"][0]);
    }
  }

  @override
  Future<void> updateBusinessContactAsync(
      {String businessId, BusinessContactModel contact}) async {
    final result = await _handler.postRaw(
      url: endpoints.updateBusinessContactAsync(businessId: businessId),
      data: contact.toJson(),
    );
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"]) {
      throw new ServerException(
          body["errorMessage"] ?? body["validationErrors"][0]);
    }
  }

  @override
  Future<BusinessModel> createBusinessAsyncV2(
      {String firebaseUid, String langIso639Code}) async {
    final result = await _handler.getRaw(
        url: endpoints.createBusinessAsyncV2(
            firebaseUid: firebaseUid, langIso639Code: langIso639Code));
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"] || body["hadErrors"]) {
      throw new ServerException(body["errorMessage"]);
    }
    final business = BusinessModel.fromJson(body["business"]);
    return business;
  }

  @override
  Future<List<CustomerModel>> searchCustomerListAsync(
      {String customerFlair}) async {
    final result = await _handler.getRaw(
        url: endpoints.searchCustomerListAsync(customerFlair: customerFlair));
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"] || body["hadErrors"]) {
      throw new ServerException(body["errorMessage"]);
    }
    List<CustomerModel> customers = [];
    for (var customer in body["customers"]) {
      customers.add(CustomerModel.fromJson(customer));
    }
    return customers;
  }

  @override
  Future<void> createAppointmentAsync({AppointmentModel appointment}) async {
    final result = await _handler.postRaw(
        url: endpoints.createAppointmentAsync(), data: appointment.toJson());
    if (result.statusCode != 200) {
      throw new ServerException(result.data.toString());
    }
    final body = result.data;
    if (!body["success"] || body["hadErrors"]) {
      throw new ServerException(body["errorMessage"]);
    }
  }

  @override
  Future<EmployeeSettingsModel> getEmployeeSettingsAsync(
      {@required String employeeId}) async {
    final result = await _handler.getRaw(
        url: endpoints.getEmployeeSettingsAsync(employeeId: employeeId));
    final data = result.data;
    if (result.statusCode != 200) {
      throw new ServerException(data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(data["errorMessage"] ?? data.toString());
    }
    return EmployeeSettingsModel.fromJson(data["settings"]);
  }

  @override
  Future<void> updateEmployeeSettingsAsync(
      {@required String employeeId,
      @required EmployeeSettingsModel settings}) async {
    final result = await _handler.postRaw(
      url: endpoints.updateEmployeeSettingsAsync(employeeId: employeeId),
      data: settings.toJson(),
    );
    final data = result.data;
    if (result.statusCode != 200) {
      throw new ServerException(data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(data["errorMessage"] ?? data.toString());
    }
  }

  @override
  Future<void> updateEntityStatusAsync(
      {String entityId, EntityType entityType, EntityStatus status}) async {
    final typeValue = _enumConvert.entityTypeToString(type: entityType);
    final statusValue = _enumConvert.entityStatusToString(status: status);
    final result = await _handler.postRaw(
      url: endpoints.updateEntityStatusAsync(
          entityId: entityId, entityType: typeValue, status: statusValue),
      data: null,
    );
    final data = result.data;
    if (result.statusCode != 200) {
      throw new ServerException(data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(data["errorMessage"] ?? data.toString());
    }
  }

  @override
  Future<void> createWorkBlockAsync(
      {@required String employeeId,
      @required EmployeeWorkBlockModel workBlock}) async {
    final result = await _handler.postRaw(
        url: endpoints.createWorkBlockAsync(employeeId: employeeId),
        data: workBlock.toJson());
    final data = result.data;
    if (result.statusCode != 200) {
      throw new ServerException(data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(data["errorMessage"] ?? data.toString());
    }
  }

  @override
  Future<void> deleteWorkBlockAsync(
      {@required String employeeId, @required String workBlockId}) async {
    final result = await _handler.deleteRaw(
      url: endpoints.deleteWorkBlockAsync(
          employeeId: employeeId, workBlockId: workBlockId),
    );
    final data = result.data;
    if (result.statusCode != 200) {
      throw new ServerException(data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(data["errorMessage"] ?? data.toString());
    }
  }

  @override
  Future<void> updateWorkBlockAsync(
      {@required String employeeId,
      @required EmployeeWorkBlockModel workBlock}) async {
    final result = await _handler.postRaw(
        url: endpoints.updateWorkBlockAsync(
            employeeId: employeeId, workBlockId: workBlock.id),
        data: workBlock.toJson());
    final data = result.data;
    if (result.statusCode != 200) {
      throw new ServerException(data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(data["errorMessage"] ?? data.toString());
    }
  }

  @override
  Future<void> updateAppointmentAsync(
      {String appointmentId, AppointmentModel appointment}) async {
    final result = await _handler.postRaw(
      url: endpoints.updateAppointmentAsync(appointmentId: appointmentId),
      data: appointment.toJson(),
    );
    final data = result.data;
    if (result.statusCode != 200 && data["errorMessage"] == null) {
      throw new ServerException(data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(data["errorMessage"] ?? data.toString());
    }
  }

  @override
  Future<PagedList<CustomerReview>> GetCustomerReviewListAsync(
      {CustomerReviewQueryParameters parameters, String pageUrl}) async {
    final localUrl =
        endpoints.getCustomerReviewListAsync(parameters: parameters);
    final newUrl = API_URI_BASE + (pageUrl ?? "");
    final result =
        await _handler.getRaw(url: pageUrl == null ? localUrl : newUrl);
    final data = result.data;
    if (result.statusCode != 200) {
      throw new ServerException(data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(data["errorMessage"] ?? data.toString());
    }
    PagedList<CustomerReview> customerReviews = PagedList.empty();
    for (var review in data["customerReviews"]) {
      customerReviews.items.add(CustomerReviewModel.fromJson(review));
    }
    customerReviews.paginationData =
        PaginationData.fromJson(data["paginationData"]);
    return customerReviews;
  }

  @override
  Future<List<AppointmentCountStatisticsDto>> GetStatisticsAppointmentCount(
      {String businessId,
      List<String> employeeIds = const [],
      DateTime from,
      DateTime until}) async {
    final url = endpoints.getStatisticsAppointmentCount(
        businessId: businessId, from: from, until: until);
    final result =
        await _handler.postRaw(url: url, data: jsonEncode(employeeIds));
    final data = result.data;
    if (result.statusCode != 200) {
      throw new ServerException(data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(data["errorMessage"] ?? data.toString());
    }
    List<AppointmentCountStatisticsDto> statisticsList = [];
    for (var statistics in data["data"]) {
      statisticsList.add(AppointmentCountStatisticsDto.fromJson(statistics));
    }
    return statisticsList;
  }

  @override
  Future<List<EmployeeNameDto>> GetEmployeeNameListAsync(
      {String businessId}) async {
    final url = endpoints.getEmployeeListAsync(businessId) + "names";
    final result = await _handler.getRaw(url: url);
    final data = result.data;
    if (result.statusCode != 200) {
      throw new ServerException(data.toString());
    }
    if (!data["success"]) {
      throw new ServerException(data["errorMessage"] ?? data.toString());
    }
    List<EmployeeNameDto> employees = [];
    for (var employee in data["employees"]) {
      employees.add(EmployeeNameDto.fromJson(employee));
    }
    return employees;
  }
}
