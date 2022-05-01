import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/core/utils/util_payment_method_name_parser.dart';
import 'package:allbert_cms/core/utils/util_payment_method_utils.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:allbert_cms/presentation/providers/provider_payment_method_selector.dart';
import 'package:allbert_cms/presentation/shared/application_text_button.dart';
import 'package:allbert_cms/presentation/shared/application_widget_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentMethodSelector extends StatelessWidget {
  final PaymentMethodNameParser paymentMethodNameParser =
      PaymentMethodNameParser();

  PaymentMethodSelector({
    Key key,
  }) : super(key: key);

  final PaymentMethodUtils paymentMethodUtils = PaymentMethodUtils();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentMethodSelectorProvider>(context);
    return Column(
      children: [
        provider.selectedPaymentMethod == null
            ? SizedBox()
            : paymentMethodSelector(context),
        provider.selectedPaymentMethods.isEmpty
            ? SizedBox()
            : buildSelectedPaymentMethods(context),
      ],
    );
  }

  Widget paymentMethodSelector(BuildContext context) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context).langIso639Code;
    final provider = Provider.of<PaymentMethodSelectorProvider>(context);
    return Row(
      children: [
        ApplicationWidgetContainer(
          verticalPadding: 10,
          verticalInnerPadding: 0,
          child: SizedBox(
            width: 200,
            child: DropdownButton(
              underline: SizedBox(),
              value: provider.selectedPaymentMethod,
              items: paymentMethodUtils
                  .getAvailablePaymentMethods(provider.selectedPaymentMethods)
                  .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(
                        paymentMethodNameParser(
                          context,
                          paymentMethodCode: e,
                        ),
                      )))
                  .toList(),
              onChanged: (value) {
                provider.updateSelected(value);
              },
            ),
          ),
        ),
        Spacer(),
        ApplicationTextButton(
          label: SystemLang.LANG_MAP[SystemText.ADD][langIso639Code],
          onPress: () {
            List<String> updatedPaymentMethods = [];
            updatedPaymentMethods.addAll(provider.selectedPaymentMethods);
            updatedPaymentMethods.add(provider.selectedPaymentMethod);
            provider.updateSelectedList(updatedPaymentMethods);
          },
        ),
      ],
    );
  }

  Widget buildSelectedPaymentMethods(BuildContext context) {
    final provider = Provider.of<PaymentMethodSelectorProvider>(context);
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: provider.selectedPaymentMethods.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              Text(
                paymentMethodNameParser(
                  context,
                  paymentMethodCode: provider.selectedPaymentMethods[index],
                ),
              ),
              Spacer(),
              InkWell(
                child: Icon(
                  Icons.remove,
                  color: provider.selectedPaymentMethods.length > 1
                      ? Colors.black
                      : Colors.grey,
                ),
                onTap: () {
                  if (provider.selectedPaymentMethods.length > 1) {
                    List<String> updatedPaymentMethods = [];
                    updatedPaymentMethods
                        .addAll(provider.selectedPaymentMethods);
                    updatedPaymentMethods
                        .remove(provider.selectedPaymentMethods[index]);
                    provider.updateSelectedList(updatedPaymentMethods);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
