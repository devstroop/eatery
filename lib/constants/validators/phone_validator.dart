extension PhoneValidator on String {
  bool isValidPhone() {
    return RegExp(
        r'^(?:[+0][1-9])?[0-9]{10,12}$')
        .hasMatch(this);
  }
}