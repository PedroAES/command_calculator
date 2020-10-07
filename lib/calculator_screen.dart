import 'package:command_calculator/add_command.dart';
import 'package:command_calculator/calculator.dart';
import 'package:command_calculator/command.dart';
import 'package:command_calculator/multiply_command.dart';
import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  Calculator calculator = Calculator();
  List<Command> commands = List<Command>();
  String newValue = '';
  String signal = '';
  int actualPosition = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF101F2D),
        title: Text('Calculadora Command'),
      ),
      body: Column(
        children: <Widget>[
          _buildDisplay(),
          Divider(height: 0.1),
          _buildKeyboard(),
        ],
      ),
    );
  }

  Widget _buildDisplay() {
    return Expanded(
      flex: 1,
      child: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: commands.length,
                itemBuilder: (BuildContext context, int index){
                  return Row(
                    children: [
                      Text(
                        commands[index].getSignal() + ' '+commands[index].toString() + ' ',
                        style: TextStyle(
                          color: actualPosition-1 < index ? Colors.grey : Colors.white
                        ),
                      ),
                    ],
                  );
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.antiAlias,
                  child: Row(
                    children: [
                      Text(calculator.getValue().toString(),
                        style: TextStyle(
                          fontSize: 60,
                          color: Colors.white
                        ),
                      ),
                      Text(signal,
                        style: TextStyle(
                          fontSize: 60,
                          color: Colors.white
                        ),
                      ),
                      Text(newValue,
                        style: TextStyle(
                          fontSize: 60,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboardButton(String label, GestureTapCallback onTap,
      {int flex = 1, Color textColor = Colors.white, Color backgroundColor = Colors.black, bool enabled = true}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: RaisedButton(
          
          disabledTextColor: textColor.withOpacity(0.6),
          color:  Color(0xFF101F2D),
          textColor: textColor,
          child: Text(
            label,
            style: TextStyle(fontSize: 24),
          ),
          onPressed: enabled ? onTap : null,
        ),
      ),
    );
  }

  _buildNumberButton(String number, {int flex = 1}){
    return  _buildKeyboardButton(number,
      (){
        setState(() {
          newValue = newValue + number;
        });
      },
      enabled: signal.isNotEmpty,
      flex: flex
    );
  }

  _buildSignalButton(String s){
    return _buildKeyboardButton(s,
      (){
        setState(() {
          signal = s;
        });
      },
      textColor: Colors.yellow,
    );
  }

  Widget _buildKeyboard() {
    return Container(
      color: Colors.black,
      height: 550.0,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildKeyboardButton(
                  '←',
                  (){
                    setState(() {
                      commands[-- actualPosition].undo();
                    });
                  },
                  textColor: Colors.yellow,
                  enabled: actualPosition > 0
                ),
                _buildKeyboardButton(
                  '→',
                  (){
                    setState(() {
                      commands[actualPosition++].redo();
                    });
                  },
                  textColor: Colors.yellow,
                  enabled: actualPosition<commands.length
                ),
                _buildKeyboardButton(
                  'DEL',
                  (){
                    setState(() {
                      newValue = newValue.replaceRange(newValue.length-1, newValue.length, '');
                    });
                  },
                  textColor: Colors.yellow,
                  enabled: newValue.isNotEmpty
                ),
                _buildSignalButton('÷')
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildNumberButton('7'),
                _buildNumberButton('8'),
                _buildNumberButton('9'),
                _buildSignalButton('x')
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildNumberButton('4'),
                _buildNumberButton('5'),
                _buildNumberButton('6'),
                _buildSignalButton('+')
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildNumberButton('1'),
                _buildNumberButton('2'),
                _buildNumberButton('3'),
                _buildSignalButton('-')
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildNumberButton('0', flex: 2),
                _buildKeyboardButton(
                  '.',
                  (){
                    if(!newValue.contains('.'))
                      setState(() {
                        newValue = newValue + '.';
                      });
                  },
                  enabled: newValue.isNotEmpty && !newValue.contains('.')
                ),
                _buildKeyboardButton(
                  '=',
                  (){
                    Command command;
                    switch(signal){
                      case '+':
                        command = AddCommand(calculator, double.parse(newValue));
                        command.redo();
                        break;
                      case '-':
                        command = AddCommand(calculator, -double.parse(newValue));
                        command.redo();
                        break;
                      case 'x':
                        command = MultiplyCommand(calculator, double.parse(newValue));
                        command.redo();
                        break;
                      case '÷':
                        command = MultiplyCommand(calculator, 1/double.parse(newValue));
                        command.redo();
                        break;
                    }

                    if(actualPosition < commands.length)
                      commands.removeRange(actualPosition, commands.length);
                    commands.add(command);
                    setState(() {
                      signal = '';
                      newValue = '';
                      actualPosition+=1;
                    });
                  },
                  textColor: Colors.yellow,
                  enabled: newValue.isNotEmpty
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}