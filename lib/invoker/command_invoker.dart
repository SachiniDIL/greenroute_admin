import '../commands/command.dart';

class CommandInvoker {
  Command? command;

  void setCommand(Command command) {
    this.command = command;
  }

  Future<void> executeCommand() async {
    if (command != null) {
      await command!.execute();
    } else {
      print('No command set');
    }
  }
}
