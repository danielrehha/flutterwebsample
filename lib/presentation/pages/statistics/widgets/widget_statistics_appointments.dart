import 'package:allbert_cms/core/exceptions/exceptions.dart';
import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/data/contracts/i_datasource_api.dart';
import 'package:allbert_cms/data/implementations/datasource_api.dart';
import 'package:allbert_cms/domain/dtos/dto_statistics_appointment_count.dart';
import 'package:allbert_cms/domain/enums/enum_chart_type.dart';
import 'package:allbert_cms/domain/enums/enum_date_range_type.dart';
import 'package:allbert_cms/domain/enums/helpers/enum_helper_date_range.dart';
import 'package:allbert_cms/presentation/pages/statistics/shared/widget_chart_type_selector.dart';
import 'package:allbert_cms/presentation/providers/provider_business.dart';
import 'package:allbert_cms/presentation/shared/application_date_range_selector.dart';
import 'package:allbert_cms/presentation/shared/application_employee_selector.dart';
import 'package:allbert_cms/presentation/shared/application_shimmer_container.dart';
import 'package:allbert_cms/presentation/shared/application_widget_container.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AppointmentStatisticsWidget extends StatefulWidget {
  AppointmentStatisticsWidget({Key key}) : super(key: key);

  final IApiDataSource dataSource = ApiDataSource();
  final PersonNameResolver nameResolver = PersonNameResolver();
  final TranslateDate translateDate = TranslateDate();

  final DateTime now = DateTime.now();

  final List<ChartType> availableChartTypes = [
    ChartType.FastLines,
    ChartType.Pie
  ];

  @override
  State<AppointmentStatisticsWidget> createState() =>
      _AppointmentStatisticsWidgetState();
}

class _AppointmentStatisticsWidgetState
    extends State<AppointmentStatisticsWidget> {
  bool _isLoading;

  String _errorMessage;

  List<FastLineSeries> _fastLineSeries;
  List<CircularSeries> _circularSeries;

  TooltipBehavior _tooltipBehavior;

  DateTime _from;
  DateTime _until;

  ChartType _selectedChartType;

  DateRangeType _selectedDateRangeType;

  List<String> _selectedEmployees;

  @override
  void initState() {
    super.initState();

    _isLoading = false;

    _fastLineSeries = [];
    _circularSeries = [];

    _tooltipBehavior = TooltipBehavior(enable: true);

    _selectedDateRangeType = DateRangeType.Past7Days;

    _selectedEmployees = [];

    _from = mapDateRangeToDateTimeList(_selectedDateRangeType)[0];
    _until = mapDateRangeToDateTimeList(_selectedDateRangeType)[1];

    _selectedChartType = ChartType.Pie;

    _loadStatisticsAsync();
  }

  @override
  Widget build(BuildContext context) {
    return ApplicationWidgetContainer(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Foglalások száma",
                style: headerStyle_3_bold,
              ),
              SizedBox(
                width: 10,
              ),
              ApplicationDateRangeSelector(
                selectedDateRangeType: _selectedDateRangeType,
                onDateRangeTypeSelected: (value) {
                  if (_selectedDateRangeType != value) {
                    setState(() {
                      _selectedDateRangeType = value;
                    });
                  }
                },
                from: _from,
                until: _until,
                onStartSelected: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _from = value ?? _from;
                  });
                  _loadStatisticsAsync();
                },
                onEndSelected: (value) {
                  if (value == null) {
                    return;
                  }
                  setState(() {
                    _until = value ?? _until;
                  });
                  _loadStatisticsAsync();
                },
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Alkalmazottak:",
              ),
              SizedBox(
                width: 10,
              ),
              ApplicationEmployeeSelector(
                onEmployeeSelected: (value) {
                  setState(() {
                    _selectedEmployees = value;
                  });
                  _loadStatisticsAsync();
                },
              ),
              Spacer(),
              ChartTypeSelector(
                selectedChartType: _selectedChartType,
                availableChartTypes: widget.availableChartTypes,
                onChartTypeSelected: (value) {
                  if (_selectedChartType != value) {
                    setState(() {
                      _selectedChartType = value;
                    });
                  }
                },
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: getStateObject(),
          ),
        ],
      ),
    );
  }

  Widget getStateObject() {
    if (_isLoading) {
      return Expanded(child: ApplicationShimmerContainer());
    }
    if (_errorMessage != null) {
      return Text(_errorMessage);
    }
    if (_selectedChartType == ChartType.Pie) {
      return Expanded(
        child: SfCircularChart(
          series: _circularSeries,
          legend: Legend(isVisible: true),
          tooltipBehavior: _tooltipBehavior,
        ),
      );
    }
    return Expanded(
      child: SfCartesianChart(
        tooltipBehavior: _tooltipBehavior,
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(),
        legend: Legend(isVisible: true),
        series: _fastLineSeries,
      ),
    );
  }

  Future<void> _loadStatisticsAsync() async {
    setState(() {
      _isLoading = true;
    });

    final businessId =
        Provider.of<BusinessProvider>(context, listen: false).businessId;

    try {
      final result = await widget.dataSource.GetStatisticsAppointmentCount(
          businessId: businessId, employeeIds: _selectedEmployees, from: _from, until: _until);

      _fastLineSeries = result.map((e) {
        return FastLineSeries(
          enableTooltip: true,
          name: widget.nameResolver.cultureBasedResolve(
            firstName: e.firstName,
            lastName: e.lastName,
          ),
          yAxisName: "Appointment count",
          xAxisName: "Date",
          dataSource: e.statistics,
          xValueMapper: (data, _) {
            final date = (data as AppointmentCountStatistics).date;
            return DateTime(date.year, date.month, date.day)
                .add(Duration(minutes: 30));
          },
          yValueMapper: (data, _) =>
              (data as AppointmentCountStatistics).appointmentCount,
        );
      }).toList();
      _circularSeries = List.generate(result.length, (index) {
        return PieSeries<AppointmentCountStatisticsDto, String>(
          enableTooltip: true,
          dataLabelSettings: DataLabelSettings(isVisible: true),
          name: "Foglalások száma",
          explode: true,
          explodeIndex: 1,
          dataSource: result,
          xValueMapper: (data, _) {
            return widget.nameResolver.cultureBasedResolve(
              firstName: data.firstName,
              lastName: data.lastName,
            );
          },
          yValueMapper: (data, _) {
            int totalCount = 0;
            for (var stat in data.statistics) {
              totalCount += stat.appointmentCount;
            }
            return totalCount;
          },
        );
      }, growable: false)
          .toList();
    } on ServerException catch (e) {
      _errorMessage = e.message;
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }

    setState(() {
      _isLoading = false;
    });
  }
}
