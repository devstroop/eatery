import 'package:eatery/references.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _input = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Container(
        color: Colors.white,
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
                        textColor: Colors.red, onPressed: clearInput),
                    buildButton('=', textColor: Colors.orange),
                    buildButton('+', textColor: Colors.orange),
                    buildButton('DEL',
                        textColor: Colors.grey, onPressed: deleteLastChar),
                    buildButton('/', textColor: Colors.orange),
                    buildButton('7', onPressed: () => addInput('7')),
                    buildButton('8', onPressed: () => addInput('8')),
                    buildButton('9', onPressed: () => addInput('9')),
                    buildButton('x', textColor: Colors.orange),
                    buildButton('4', onPressed: () => addInput('4')),
                    buildButton('5', onPressed: () => addInput('5')),
                    buildButton('6', onPressed: () => addInput('6')),
                    buildButton('-', textColor: Colors.orange),
                    buildButton('1', onPressed: () => addInput('1')),
                    buildButton('2', onPressed: () => addInput('2')),
                    buildButton('3', onPressed: () => addInput('3')),
                    buildButton('', fontSize: 20),
                    buildButton('0', onPressed: () => addInput('0')),
                    buildButton('.', onPressed: () => addInput('.')),
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
          color: Colors.black.withOpacity(0.2),
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
            color: textColor ?? Colors.black,
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
