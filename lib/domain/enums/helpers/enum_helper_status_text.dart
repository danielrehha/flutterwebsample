import '../enum_appointment_status.dart';

String getStatusText(AppointmentStatus status) {
  if (status == AppointmentStatus.NULL) {
    return "--összes--";
  }
  if (status == AppointmentStatus.Active) {
    return "Aktív";
  }
  if (status == AppointmentStatus.Review) {
    return "Kiértékelés";
  }
  if (status == AppointmentStatus.ReviewPositive) {
    return "Teljesített";
  }
  if (status == AppointmentStatus.ReviewNegative) {
    return "Nem teljesített";
  }
  if (status == AppointmentStatus.DeletedByCustomer) {
    return "Törölt (vendég)";
  }
  return "Törölt (üzlet)";
}