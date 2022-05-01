import 'package:allbert_cms/domain/enums/enum_chart_type.dart';

String toChartName(ChartType type) {
  if (type == ChartType.Pie) {
    return "Kördiagram";
  }
  if (type == ChartType.FastLines) {
    return "Grafikon";
  }
  return "Chart";
}
