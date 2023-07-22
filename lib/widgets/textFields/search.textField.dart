import 'package:eatery/references.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField(
      {super.key,
      required this.onChanged,
      required this.controller,
      required this.themeColor,
      this.hintText,
      this.onSubmitted});
  final Function(String) onChanged;
  final Function(String)? onSubmitted;
  final TextEditingController controller;
  final Color? themeColor;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon:
            Icon(Icons.search, color: ColorStyle.text400),
        hintText: hintText,
        hintStyle: TextStyle(
          color: ColorStyle.text400,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorStyle.text400,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: (themeColor ?? ColorStyle.primary).withOpacity(0.5),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
      ),
      style: TextStyle(
        color: ColorStyle.text200,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
