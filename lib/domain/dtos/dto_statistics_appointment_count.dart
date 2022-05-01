import 'dart:convert';

class AppointmentCountStatisticsDto {
  final String firstName;
  final String lastName;
  final List<AppointmentCountStatistics> statistics;

  AppointmentCountStatisticsDto(this.firstName, this.lastName, this.statistics);

  factory AppointmentCountStatisticsDto.fromJson(dynamic json) {
    List<AppointmentCountStatistics> statisticsList = [];

    for (var stat in json["statistics"] ?? []) {
      statisticsList.add(AppointmentCountStatistics.fromJson(stat));
    }

    return AppointmentCountStatisticsDto(
      json["firstName"],
      json["lastName"],
      statisticsList,
    );
  }
}

class AppointmentCountStatistics {
  final DateTime date;
  final int appointmentCount;

  AppointmentCountStatistics(this.date, this.appointmentCount);

  factory AppointmentCountStatistics.fromJson(Map<String, dynamic> json) {
    return AppointmentCountStatistics(
      DateTime.parse(json["date"]),
      json["appointmentCount"],
    );
  }
}
