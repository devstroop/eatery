import 'package:flutter/material.dart';

class BackupRestorePage extends StatefulWidget {
  const BackupRestorePage({Key? key, required this.account}) : super(key: key);
  final Map<String, dynamic> account;
  @override
  State<BackupRestorePage> createState() => _BackupRestorePageState();
}

class _BackupRestorePageState extends State<BackupRestorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
