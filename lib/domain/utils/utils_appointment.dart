import 'package:allbert_cms/domain/enums/enum_appointment_status.dart';

class AppointmentUtils {
  int getAppointmentStatusValue(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.NULL:
        return -1;
      case AppointmentStatus.Active:
        return 0;
      case AppointmentStatus.Review:
        return 1;
      case AppointmentStatus.ReviewPositive:
        return 2;
      case AppointmentStatus.ReviewNegative:
        return 3;
      case AppointmentStatus.DeletedByCustomer:
        return 4;
      case AppointmentStatus.DeletedByBusiness:
        return 5;
      default:
        return 0;
    }
  }
}
