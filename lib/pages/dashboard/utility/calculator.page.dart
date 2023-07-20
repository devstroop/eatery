import 'package:flutter/material.dart';

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
  final Map<String, Function> _operators = {
    '+': (a, b) => a + b,
    '-': (a, b) => a - b,
    '*': (a, b) => a * b,
    '/': (a, b) => a / b,
  };

  @override
  Widget build(BuildContext context) {
    List<Widget> nos = [
      buildButton('7', onPressed: () => addInput('7')),
      buildButton('8', onPressed: () => addInput('8')),
      buildButton('9', onPressed: () => addInput('9')),
      buildButton('4', onPressed: () => addInput('4')),
      buildButton('5', onPressed: () => addInput('5')),
      buildButton('6', onPressed: () => addInput('6')),
      buildButton('1', onPressed: () => addInput('1')),
      buildButton('2', onPressed: () => addInput('2')),
      buildButton('3', onPressed: () => addInput('3')),
      buildButton('00', onPressed: () => addInput('00')),
      buildButton('0', onPressed: () => addInput('0')),
      buildButton('.', onPressed: () => addInput('.')),
    ];
    List<Widget> rightDocked = [
      buildButton('*', textColor: Colors.orange, onPressed: () => addInput('*')),
      buildButton('-', textColor: Colors.orange, onPressed: () => addInput('-')),
      buildButton('+', textColor: Colors.orange, onPressed: () => addInput('+')),
      buildButton('=', textColor: Colors.orange, onPressed: evaluateExpression),
    ];
    List<Widget> topDocked = [
      buildButton('AC', textColor: Colors.red, onPressed: clearInput),
      buildButton('DEL', textColor: Colors.grey, onPressed: deleteLastChar),
      buildButton('/', textColor: Colors.orange, onPressed: () => addInput('/')),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.bottomRight,
                child: Text(
                  _input,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  // Wrap the left column containing GridView with Expanded
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: topDocked.length,
                        itemBuilder: (BuildContext context, int index) {
                          return topDocked[index];
                        },
                      ),
                      const SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1.2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: nos.length,
                        itemBuilder: (BuildContext context, int index) {
                          return nos[index];
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),
                Column(
                  children: [
                    for(var each in rightDocked)
                      Padding(padding: EdgeInsets.only(bottom: 8), child: each),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(
      String text, {
        Color? textColor,
        double fontSize = 20,
        VoidCallback? onPressed,
      }) {
    double size = ((MediaQuery.of(context).size.width - 16*2 - 8*3) / 4).abs();
    debugPrint(size.toString());
    return Container(
      width: size, // Set a fixed width here, or adjust the value as needed
      height: size, // Set a fixed height here, or adjust the value as needed
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          primary: Colors.grey[300],
        ),
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

  void evaluateExpression() {
    try {
      double result = calculateExpression(_input);
      setState(() {
        _input = result.toString();
      });
    } catch (e) {
      // If there's an error in the expression, handle it here.
      // For simplicity, let's just clear the input in case of an error.
      clearInput();
    }
  }

  List<String> splitTokens(String expression) {
    // Split the expression into tokens (operators and numbers)
    final tokens = <String>[];
    final buffer = StringBuffer();

    for (int i = 0; i < expression.length; i++) {
      final char = expression[i];
      if (_operators.keys.contains(char)) {
        // If the character is an operator, add the buffered number (if any) and the operator
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }
        tokens.add(char);
      } else if (char != ' ') {
        // If the character is not a space, add it to the buffer
        buffer.write(char);
      }
    }

    // Add any remaining buffered number
    if (buffer.isNotEmpty) {
      tokens.add(buffer.toString());
    }

    return tokens;
  }
  double calculateExpression(String expression) {
    expression = expression.replaceAll('x', '*'); // Replace 'x' with '*'
    List<String> tokens = splitTokens(expression);

    // Rest of the method remains unchanged
    // ...

    bool isNumber(String token) {
      // Check if the token is a number
      final numberPattern = RegExp(r'^\d+\.?\d*$');
      return numberPattern.hasMatch(token);
    }

    return 0;
  }
}
