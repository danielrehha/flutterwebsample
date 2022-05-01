import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/domain/enums/enum_date_range_type.dart';
import 'package:allbert_cms/domain/enums/helpers/enum_helper_date_range.dart';
import 'package:flutter/material.dart';

typedef OnDateSelectCallback = Function(DateTime);
typedef OnDateRangeTypeSelectCallback = Function(DateRangeType);

class ApplicationDateRangeSelector extends StatelessWidget {
  ApplicationDateRangeSelector({
    Key key,
    @required this.from,
    @required this.until,
    @required this.onStartSelected,
    @required this.onEndSelected,
    @required this.selectedDateRangeType,
    @required this.onDateRangeTypeSelected,
    this.firstDayOffset = 730,
    this.lastDayOffset = 730,
  }) : super(key: key);

  final DateTime from;
  final DateTime until;
  final int firstDayOffset;
  final int lastDayOffset;

  final OnDateSelectCallback onStartSelected;
  final OnDateSelectCallback onEndSelected;
  final OnDateRangeTypeSelectCallback onDateRangeTypeSelected;

  final DateRangeType selectedDateRangeType;
  final TranslateDate translateDate = TranslateDate();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text("Időszak:"),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          height: 25,
          child: dateRangeTypeDropdown(),
        ),
        SizedBox(
          width: 10,
        ),
        Row(
          children: [
            selectedDateRangeType == DateRangeType.Custom
                ? InkWell(
                    child: Icon(
                      Icons.edit,
                      size: 18,
                    ),
                    onTap: () async {
                      final result = await showDatePicker(
                        context: context,
                        initialDate: from,
                        firstDate:
                            from.subtract(Duration(days: firstDayOffset)),
                        lastDate: from.add(Duration(days: lastDayOffset)),
                      );
                      onStartSelected(result);
                    },
                  )
                : SizedBox(),
            Text(translateDate.numeric(from)),
            Text(" - "),
            selectedDateRangeType == DateRangeType.Custom
                ? InkWell(
                    child: Icon(
                      Icons.edit,
                      size: 18,
                    ),
                    onTap: () async {
                      final result = await showDatePicker(
                        context: context,
                        initialDate: until,
                        firstDate: until.subtract(Duration(days: 830)),
                        lastDate: until.add(Duration(days: 830)),
                      );
                      onEndSelected(result);
                    },
                  )
                : SizedBox(),
            Text(translateDate.numeric(until))
          ],
        ),
      ],
    );
  }

  Widget dateRangeTypeDropdown() {
    return DropdownButton(
      underline: SizedBox(),
      value: selectedDateRangeType,
      items: List.generate(
        defaultDateRangeTypeList.length,
        (index) => DropdownMenuItem(
          value: defaultDateRangeTypeList[index],
          child: Text(
            mapDateRangeToText(defaultDateRangeTypeList[index]),
          ),
        ),
      ),
      onChanged: (value) {
        if (selectedDateRangeType != value) {
          onDateRangeTypeSelected(value);
          if (value != DateRangeType.Custom) {
            onStartSelected(mapDateRangeToDateTimeList(value)[0]);
            onEndSelected(mapDateRangeToDateTimeList(value)[1]);
          }
        }
      },
    );
  }
}
