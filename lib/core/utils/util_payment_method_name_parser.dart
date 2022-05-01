import 'package:allbert_cms/core/lang/lang.dart';
import 'package:allbert_cms/presentation/providers/provider_language.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentMethodNameParser {
  String call(BuildContext context, {@required String paymentMethodCode}) {
    final langIso639Code =
        Provider.of<LanguageProvider>(context, listen: false).langIso639Code;
    if (paymentMethodCode == "A") {
      return SystemLang.LANG_MAP[SystemText.CASH][langIso639Code];
    }
    if(paymentMethodCode == "B") {
      return SystemLang.LANG_MAP[SystemText.DEBIT_CARD][langIso639Code];
    }
    if(paymentMethodCode == "C") {
      return SystemLang.LANG_MAP[SystemText.CREDIT_CARD][langIso639Code];
    }
    if(paymentMethodCode == "D") {
      return SystemLang.LANG_MAP[SystemText.SZEPCARD][langIso639Code];
    }
  }
}
