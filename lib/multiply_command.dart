import 'package:command_calculator/calculator.dart';
import 'package:command_calculator/command.dart';

class MultiplyCommand implements Command{
  MultiplyCommand(this._receiver, this.parameter);

  final Calculator _receiver;
  final double parameter;

  @override
  void redo() {
    _receiver.multiply(parameter);
  }

  @override
  void undo() {
    _receiver.multiply(1/parameter);
  }

  @override
  String toString() {
    return parameter.toString();
  }

  @override
  String getSignal() {
    return 'x';
  }
}