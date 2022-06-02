import 'package:flutter/material.dart';

class ImportExportPage extends StatefulWidget {
  const ImportExportPage({Key? key, required this.account}) : super(key: key);
  final Map<String, dynamic> account;
  @override
  State<ImportExportPage> createState() => _ImportExportPageState();
}

class _ImportExportPageState extends State<ImportExportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
