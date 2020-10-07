import 'package:command_calculator/calculator.dart';
import 'package:command_calculator/command.dart';

class AddCommand implements Command{
  AddCommand(this._receiver, this.parameter);
  final Calculator _receiver;
  final double parameter;
  
  @override
  void redo() {
    _receiver.add(parameter);
  }

  @override
  void undo() {
    _receiver.add(-parameter);
  }

  @override
  String toString() {
    return parameter.toString();
  }

  @override
  String getSignal() {
    return '+';
  }
}