import 'package:allbert_cms/core/utils/util_payment_method_utils.dart';
import 'package:flutter/material.dart';

class PaymentMethodSelectorProvider extends ChangeNotifier {
  final PaymentMethodUtils paymentMethodUtils = PaymentMethodUtils();

  List<String> _selectionList = [];
  List<String> get selectionList => _selectionList;

  List<String> _selectedPaymentMethods = [];
  List<String> get selectedPaymentMethods => _selectedPaymentMethods;

  String _selectedPaymentMethod;
  String get selectedPaymentMethod => _selectedPaymentMethod;

  void updateSelectedList(List<String> selected) {
    _selectedPaymentMethods = selected;
    _selectedPaymentMethod =
        paymentMethodUtils.getSelectedPaymentMethod(selected);
    notifyListeners();
  }

  void updateSelected(String selected) {
    _selectedPaymentMethod = selected;
    notifyListeners();
  }

  void reset() {
    _selectionList = [];
    _selectedPaymentMethods = [];
    _selectedPaymentMethod = null;
  }
}
