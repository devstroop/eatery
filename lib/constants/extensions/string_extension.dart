extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
  double? toDouble() {
    if(this != ''){
      try{
        return double.parse(this);
      }catch(_){}
    }
    return null;
  }
}