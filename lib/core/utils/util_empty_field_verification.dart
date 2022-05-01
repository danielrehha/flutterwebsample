
class EmptyFieldVerification {
  bool call(String value) => value != null && value.isNotEmpty ? true : false;
}
