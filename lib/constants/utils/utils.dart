import 'package:flutter/material.dart';
import 'package:platform_device_id/platform_device_id.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}