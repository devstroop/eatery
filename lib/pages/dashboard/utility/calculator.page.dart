import 'package:eatery_core/widgets/app_page_shell.dart';
import 'package:eatery_core/theme/app_typography.dart';
import 'package:eatery/references.dart';
import 'package:eatery_core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorPage extends ConsumerStatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends ConsumerState<CalculatorPage> {
  String _input = '';


  void _calculate() {
    try {
      final result = _evaluateSimple(_input.replaceAll('x', '*'));
      setState(() => _input = result.toStringAsFixed(2));
    } catch (_) {
      setState(() => _input = 'Error');
    }
  }

  double _evaluateSimple(String expr) {
    // Handle + and - operators left to right
    final parts = expr.split(RegExp(r'(?=[+-])'));
    double total = 0;
    for (final p in parts) {
      final trimmed = p.trim();
      if (trimmed.isEmpty) continue;
      double val;
      if (trimmed.startsWith('+')) val = double.parse(trimmed.substring(1));
      else if (trimmed.startsWith('-')) val = -double.parse(trimmed.substring(1));
      else val = double.parse(trimmed);
      total += val;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Calculator',
      color: const Color.fromARGB(0, 47, 24, 130),
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomRight,
                child: Text(
                  _input,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 4,
                  childAspectRatio: 1.5,
                  children: [
                    buildButton('AC',
                        textColor: AppColors.error,
                        fontSize: 18,
                        onPressed: clearInput),
                    buildButton('=', textColor: Colors.orange, fontSize: 24),
                    buildButton('+', textColor: Colors.orange, fontSize: 24),
                    buildButton('DEL',
                        textColor: Colors.grey,
                        fontSize: 16,
                        onPressed: deleteLastChar),
                    buildButton('/', textColor: Colors.orange, fontSize: 24),
                    buildButton('7',
                        fontSize: 24, onPressed: () => addInput('7')),
                    buildButton('8',
                        fontSize: 24, onPressed: () => addInput('8')),
                    buildButton('9',
                        fontSize: 24, onPressed: () => addInput('9')),
                    buildButton('x', textColor: Colors.orange, fontSize: 24),
                    buildButton('4',
                        fontSize: 24, onPressed: () => addInput('4')),
                    buildButton('5',
                        fontSize: 24, onPressed: () => addInput('5')),
                    buildButton('6',
                        fontSize: 24, onPressed: () => addInput('6')),
                    buildButton('-', textColor: Colors.orange, fontSize: 24),
                    buildButton('1',
                        fontSize: 24, onPressed: () => addInput('1')),
                    buildButton('2',
                        fontSize: 24, onPressed: () => addInput('2')),
                    buildButton('3',
                        fontSize: 24, onPressed: () => addInput('3')),
                    buildButton('', fontSize: 20),
                    buildButton('0',
                        fontSize: 24, onPressed: () => addInput('0')),
                    buildButton('.',
                        fontSize: 24, onPressed: () => addInput('.')),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String text,
      {Color? textColor, double fontSize = 20, VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.black.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextButton(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(8),
          ),
          backgroundColor: MaterialStateProperty.all<Color?>(null),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor ?? AppColors.black,
          ),
        ),
      ),
    );
  }

  void addInput(String value) {
    setState(() {
      _input += value;
    });
  }

  void clearInput() {
    setState(() {
      _input = '';
    });
  }

  void deleteLastChar() {
    setState(() {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
      }
    });
  }
}
