import 'package:flutter/material.dart';

import '../themes/theme_size.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';

class SubscriptionLimitPopup extends StatelessWidget {
  const SubscriptionLimitPopup({
    Key key,
    @required this.limitReachedText,
    @required this.icon,
    @required this.limitAmount,
  }) : super(key: key);

  final String limitAmount;
  final String limitReachedText;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: defaultPadding,
        child: UnconstrainedBox(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Text(
                  'Váltson nagyobb csomagra!',
                  style: headerStyle_3_bold,
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    icon,
                    SizedBox(
                      width: 6,
                    ),
                    Text(limitReachedText),
                    Text(
                      limitAmount,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    InkWell(
                      child: Text(
                        'Mégse',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Megnézem a csomagajánlatok',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
