import 'package:allbert_cms/core/utils/util_person_name_resolver.dart';
import 'package:allbert_cms/core/utils/util_translate_date.dart';
import 'package:allbert_cms/core/utils/util_translate_time.dart';
import 'package:allbert_cms/domain/entities/entity_customer_review.dart';
import 'package:allbert_cms/presentation/popups/popup_customer_details.dart';
import 'package:allbert_cms/presentation/shared/application_rating_indicator.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_widget_container.dart';
import 'package:allbert_cms/presentation/themes/theme_text.dart';
import 'package:flutter/material.dart';

class ApplicationCustomerReviewWidget extends StatelessWidget {
  ApplicationCustomerReviewWidget({Key key, @required this.review})
      : super(key: key);

  final CustomerReview review;
  final PersonNameResolver nameResolver = PersonNameResolver();
  final TranslateDate translateDate = TranslateDate();
  final TranslateTime translateTime = TranslateTime();

  @override
  Widget build(BuildContext context) {
    return ApplicationWidgetContainer(
      verticalPadding: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ApplicationTextButton(
                    label: nameResolver.cultureBasedResolve(
                      firstName: review.customer.info.firstName,
                      lastName: review.customer.info.lastName,
                    ),
                    onPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CustomerDetailsPopup(
                            customerId: review.customer.id,
                          );
                        },
                      );
                    },
                  ),
                  Text(
                    translateDate(date: review.createdOn) +
                        " " +
                        translateTime(time: review.createdOn),
                    style: bodyStyle_2_grey,
                  )
                ],
              ),
              Spacer(),
              ApplicationRatingIndicator(
                size: 24,
                avgRating: review.rating.toDouble(),
              ),
            ],
          ),
          review.comment == null
              ? SizedBox()
              : Column(
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Text(review.comment),
                  ],
                ),
        ],
      ),
    );
  }
}
