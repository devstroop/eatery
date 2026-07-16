import 'package:flutter/material.dart';

class AppErrorBoundary extends StatefulWidget {
  const AppErrorBoundary({super.key, required this.child, this.onError});

  final Widget child;
  final void Function(FlutterErrorDetails details)? onError;

  @override
  State<AppErrorBoundary> createState() => _AppErrorBoundaryState();
}

class _AppErrorBoundaryState extends State<AppErrorBoundary> {
  FlutterErrorDetails? _lastIgnored;
  void Function(FlutterErrorDetails)? _previousHandler;
  bool _active = false;

  static bool _hasActiveInstance = false;

  @override
  void initState() {
    super.initState();
    if (_hasActiveInstance) return;
    _hasActiveInstance = true;
    _active = true;

    _previousHandler = FlutterError.onError;
    var reentrant = false;
    FlutterError.onError = (details) {
      if (identical(_lastIgnored, details) || reentrant) return;
      _lastIgnored = details;
      reentrant = true;
      _previousHandler?.call(details);
      widget.onError?.call(details);
      reentrant = false;
    };
  }

  @override
  void dispose() {
    if (_active) {
      _hasActiveInstance = false;
      FlutterError.onError = _previousHandler;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
