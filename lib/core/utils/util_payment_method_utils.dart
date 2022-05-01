class PaymentMethodUtils {
  final List<String> _availablePaymentMethods = ["A", "B", "C"];
  
  List<String> getAvailablePaymentMethods(List<String> selected) {
    List<String> result = [];
    result.addAll(_availablePaymentMethods);
    for (var method in selected) {
      result.remove(method);
    }
    return result;
  }

  String getSelectedPaymentMethod(List<String> selected) {
    if (selected.length >= 3) {
      return null;
    }
    List<String> result = [];
    result.addAll(_availablePaymentMethods);
    for (var method in selected) {
      result.remove(method);
    }
    return result.first;
  }
}
