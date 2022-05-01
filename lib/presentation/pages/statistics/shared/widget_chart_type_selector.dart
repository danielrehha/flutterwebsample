import 'package:allbert_cms/domain/enums/enum_chart_type.dart';
import 'package:allbert_cms/presentation/pages/statistics/shared/chart_type_name_mapper.dart';
import 'package:flutter/material.dart';

typedef OnChartTypeSelect = Function(ChartType);

class ChartTypeSelector extends StatelessWidget {
  const ChartTypeSelector(
      {Key key, this.selectedChartType, this.availableChartTypes, this.onChartTypeSelected})
      : super(key: key);

  final ChartType selectedChartType;
  final List<ChartType> availableChartTypes;
  final OnChartTypeSelect onChartTypeSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: DropdownButton(
        underline: SizedBox(),
        value: selectedChartType,
        items: List.generate(
          availableChartTypes.length,
          (index) => DropdownMenuItem(
            value: availableChartTypes[index],
            child: Text(
              toChartName(availableChartTypes[index]),
            ),
          ),
        ),
        onChanged: (value) {
          onChartTypeSelected(value);
        },
      ),
    );
  }
}
