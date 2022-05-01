import 'package:allbert_cms/domain/enums/enum_appointment_status.dart';
import 'package:allbert_cms/domain/helpers/appointment_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/customer_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/customer_review_query_parameters.dart';
import 'package:allbert_cms/domain/helpers/notification_query_parameters.dart';
import 'package:allbert_cms/domain/utils/utils_appointment.dart';
import 'package:meta/meta.dart';

const String HOST_URI = (String.fromEnvironment("SERVER_ADDRESS") == null ||
        String.fromEnvironment("SERVER_ADDRESS") == "")
    ? "https://localhost:5001"
    : String.fromEnvironment("SERVER_ADDRESS");
const String API_URI = HOST_URI + "/api/";
const String API_URI_BASE = HOST_URI + "/api";

class EndpointNamingContext {
  String getBusinessListAsync = "${API_URI}business/all";

  AppointmentUtils utils = AppointmentUtils();

  String getByFirebaseUidAsync(String firebaseUid) {
    return "${API_URI}business/$firebaseUid";
  }

  String createBusinessAsync(String firebaseUid) {
    return "${API_URI}business/$firebaseUid";
  }

  String updateBusinessAsync(String businessId) {
    return "${API_URI}business/$businessId/info";
  }

  String uploadBusinessAvatarImageAsync(String businessId) {
    return "${API_URI}business/$businessId/avatar";
  }

  String deleteBusinessAvatarImageAsync(String businessId) {
    return "${API_URI}business/$businessId/avatar";
  }

  String uploadBusinessPortfolioImageAsync(String businessId) {
    return "${API_URI}business/$businessId/portfolio";
  }

  String getBusinessPortfolioAsync(String businessId) {
    return "${API_URI}business/$businessId/portfolio";
  }

  String deleteBusinessPortfolioImageAsync(String businessId, String fileId) {
    return "${API_URI}business/$businessId/portfolio/$fileId";
  }

  String getEmployeeListAsync(String businessId) {
    return "${API_URI}business/$businessId/employees/";
  }

  String createEmployeeAsync(String businessId) {
    return "${API_URI}business/$businessId/employees/";
  }

  String updateEmployeeAsync(String employeeId) {
    return "${API_URI}employee/$employeeId";
  }

  String deleteEmployeeAsync(String employeeId) {
    return "${API_URI}employee/$employeeId";
  }

  String getServiceListAsync(String businessId) {
    return "${API_URI}business/$businessId/services/";
  }

  String createServiceAsync() {
    return "${API_URI}service";
  }

  String updateServiceAsync(String serviceId) {
    return "${API_URI}service/$serviceId";
  }

  String deleteServiceAsync(String serviceId) {
    return "${API_URI}service/$serviceId";
  }

  String uploadEmployeeAvatarImageAsync(String employeeId) {
    return "${API_URI}employee/$employeeId/avatar";
  }

  String deleteEmployeeAvatarImageAsync(String employeeId) {
    return "${API_URI}employee/$employeeId/avatar";
  }

  String getEmployeePortfolioListAsync(String employeeId) {
    return "${API_URI}employee/$employeeId/portfolio";
  }

  String uploadEmployeePortfolioAsync(String employeeId) {
    return "${API_URI}employee/$employeeId/portfolio";
  }

  String deleteEmployeePortfolioAsync(String employeeId, String fileId) {
    return "${API_URI}employee/$employeeId/portfolio/$fileId";
  }

  String createAvailableTimeslotAsync(String employeeId) {
    return "${API_URI}employee/$employeeId/available_timeslots";
  }

  String updateAvailableTimeslotAsync(String employeeId, String timeslotId) {
    return "${API_URI}employee/$employeeId/available_timeslots/$timeslotId";
  }

  String deleteAvailableTimeslotAsync(String employeeId, String timeslotId) {
    return "${API_URI}employee/$employeeId/available_timeslots/$timeslotId";
  }

  String getEmployeeScheduleListAsync(
      String businessId, DateTime from, DateTime until) {
    return "${API_URI}business/$businessId/calendar?from=${from.toIso8601String()}&until=${until.toIso8601String()}";
  }

  String getBusinessAppointmentListAsyncV2(
      {@required String businessId,
      @required AppointmentQueryParameters parameters}) {
    if (parameters == null) {
      return "${API_URI}business/$businessId/appointments_v2?pageNumber=1&pageSize=10";
    }
    String baseAddress =
        "${API_URI}business/$businessId/appointments_v2?pageNumber=${parameters.pageNumber}&pageSize=${parameters.pageSize}";
    if (parameters.employeeId != null) {
      baseAddress += "&employeeId=${parameters.employeeId}";
    }
    if (parameters.status != null &&
        parameters.status != AppointmentStatus.NULL) {
      final statusValue = utils.getAppointmentStatusValue(parameters.status);
      baseAddress += "&status=$statusValue";
    }
    if (parameters.customerFlair != null) {
      baseAddress += "&customerFlair=${parameters.customerFlair}";
    }
    if (parameters.serviceId != null) {
      baseAddress += "&serviceId=${parameters.serviceId}";
    }
    if (parameters.date != null) {
      final String dateString = parameters.date.toIso8601String();
      baseAddress += "&date=$dateString";
    }
    if (parameters.orderByDescending != null) {
      baseAddress += "&orderByDescending=${parameters.orderByDescending}";
    }
    return baseAddress;
  }

  String getBusinessCustomerListAsync(
      {@required String businessId,
      @required CustomerQueryParameters parameters}) {
    if (parameters == null) {
      return "${API_URI}business/$businessId/customers?pageNumber=1&pageSize=10";
    }
    String baseAddress =
        "${API_URI}business/$businessId/customers?pageNumber=${parameters.pageNumber}&pageSize=${parameters.pageSize}";
    if (parameters.banned != null) {
      baseAddress += "&banned=${parameters.banned}";
    }
    if (parameters.customerFlair != null) {
      baseAddress += "&customerFlair=${parameters.customerFlair}";
    }
    if (parameters.orderBy != null) {
      baseAddress += "&orderBy=${parameters.orderBy}";
    }
    return baseAddress;
  }

  String updateAppointmentStatusAsync(
      {@required String appointmentId, @required int status}) {
    return "${API_URI}appointment/$appointmentId/update?status=$status";
  }

  String updateScheduleAsync({@required String employeeId}) {
    return "${API_URI}employee/$employeeId/schedule";
  }

  String getScheduleAsync({@required String businessId}) {
    return "${API_URI}business/$businessId/schedule";
  }

  String getCustomerDetailsAsync({@required String customerId}) {
    return "${API_URI}customer/$customerId/details";
  }

  String getBusinessNotificationListAsync(
      {@required String businessId,
      NotificationQueryParameters parameters,
      String url}) {
    String baseAddress =
        "${API_URI}business/$businessId/notifications?pageNumber=${parameters.pageNumber}&pageSize=${parameters.pageSize}";
    return baseAddress;
  }

  String updateBusinessSettingsAsync({@required String businessId}) {
    return "${API_URI}business/$businessId/settings";
  }

  String banCustomerAsync(
      {@required String businessId, @required String customerId}) {
    return "${API_URI}business/$businessId/ban/$customerId";
  }

  String unBanCustomerAsync(
      {@required String businessId, @required String customerId}) {
    return "${API_URI}business/$businessId/unban/$customerId";
  }

  String getEmployeeServiceListAsync({@required String employeeId}) {
    return "${API_URI}employee/$employeeId/services";
  }

  String updateBusinessDetailsAsync({@required String businessId}) {
    return "${API_URI}business/$businessId/details";
  }

  String updateBusinessAddressAsync({@required String businessId}) {
    return "${API_URI}business/$businessId/address";
  }

  String updateBusinessContactAsync({@required String businessId}) {
    return "${API_URI}business/$businessId/contact";
  }

  String createBusinessAsyncV2(
      {@required String firebaseUid, @required String langIso639Code}) {
    return "${API_URI}business/$firebaseUid/$langIso639Code";
  }

  String loadCountryListAsync() {
    return "${API_URI}location/countries";
  }

  String loadCityListAsync(
      {@required String countryCode, String queryString = ""}) {
    if (queryString.length > 0) {
      return "${API_URI}location/cities?countryCode=${countryCode}&queryString=$queryString";
    }
    return "${API_URI}location/cities?countryCode=${countryCode}";
  }

  String searchCustomerListAsync({String customerFlair}) {
    if (customerFlair == null || customerFlair.isEmpty) {
      return "${API_URI}customer";
    }
    return "${API_URI}customer?customerFlair=$customerFlair";
  }

  String createAppointmentAsync() {
    return "${API_URI}appointment?createdBy=business";
  }

  String getEmployeeSettingsAsync({@required String employeeId}) {
    return "${API_URI}employee/$employeeId/settings";
  }

  String updateEmployeeSettingsAsync({@required String employeeId}) {
    return "${API_URI}employee/$employeeId/settings";
  }

  String updateEntityStatusAsync(
      {@required String entityId,
      @required String entityType,
      @required String status}) {
    return "${API_URI}${entityType}/$entityId/status?value=${status}";
  }

  String createWorkBlockAsync({@required String employeeId}) {
    return "${API_URI}employee/$employeeId/workblock";
  }

  String updateWorkBlockAsync(
      {@required String employeeId, @required String workBlockId}) {
    return "${API_URI}employee/$employeeId/workblock/$workBlockId";
  }

  String deleteWorkBlockAsync(
      {@required String employeeId, @required String workBlockId}) {
    return "${API_URI}employee/$employeeId/workblock/$workBlockId";
  }

  String updateAppointmentAsync({@required String appointmentId}) {
    return "${API_URI}appointment/$appointmentId";
  }

  String getCustomerReviewListAsync(
      {@required CustomerReviewQueryParameters parameters}) {
    String baseAddress =
        "${API_URI}employee/${parameters.employeeId}/reviews?pageNumber=${parameters.pageNumber}&pageSize=${parameters.pageSize}";
    if (parameters.employeeId != null) {
      baseAddress += "&employeeId=${parameters.employeeId}";
    }
    if (parameters.rating != null) {
      baseAddress += "&rating=${parameters.rating}";
    }
    if (parameters.from != null) {
      baseAddress += "&from=${parameters.from.toIso8601String()}";
    }
    if (parameters.until != null) {
      baseAddress += "&until=${parameters.until.toIso8601String()}";
    }
    if (parameters.orderBy != null) {
      baseAddress += "&orderBy=${parameters.orderBy}";
    }
    return baseAddress;
  }

  String getStatisticsAppointmentCount(
      {@required String businessId,
      @required DateTime from,
      @required DateTime until}) {
    return "${API_URI}business/$businessId/statistics/count/appointment?from=${from.toIso8601String()}&until=${until.toIso8601String()}";
  }
}
