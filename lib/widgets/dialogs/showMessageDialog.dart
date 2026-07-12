import 'package:eatery/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

Future<bool?> showMessageDialog(
    BuildContext context, String message, MessageType type,
    [Function? onPop]) {
  return showDialog<bool?>(
      context: context,
      builder: (context) => AlertDialog(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  type.icon,
                  color: type.color,
                  size: 28,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(type.value),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onPop != null) {
                      onPop();
                    }
                  },
                  child: const Text('OK')),
            ],
          ));
}

enum MessageType { success, error, warning, info }

extension MessageTypeExtension on MessageType {
  String get value {
    switch (this) {
      case MessageType.success:
        return 'Success';
      case MessageType.error:
        return 'Error';
      case MessageType.warning:
        return 'Warning';
      case MessageType.info:
        return 'Info';
      default:
        return '';
    }
  }

  IconData get icon {
    switch (this) {
      case MessageType.success:
        return Icons.check_circle;
      case MessageType.error:
        return Icons.error;
      case MessageType.warning:
        return Icons.warning;
      case MessageType.info:
        return Icons.info;
      default:
        return Icons.info;
    }
  }

  Color get color {
    switch (this) {
      case MessageType.success:
        return Colors.green;
      case MessageType.error:
        return AppColors.error;
      case MessageType.warning:
        return Colors.orange;
      case MessageType.info:
        return Colors.blue;
      default:
        return Colors.blue;
    }
  }
}
