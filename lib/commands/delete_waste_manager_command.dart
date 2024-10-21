import '../services/waste_manager_service.dart';
import 'command.dart';

class DeleteWasteManagerCommand implements Command {
  final WasteManagerService service;
  final String userId;

  DeleteWasteManagerCommand(this.service, this.userId);

  @override
  Future<void> execute() async {
    print('Executing DeleteWasteManagerCommand for ID: $userId');
    await service.deleteWasteManager(userId);
  }
}
