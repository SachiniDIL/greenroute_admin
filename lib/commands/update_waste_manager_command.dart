import '../models/waste_manager.dart';
import '../services/waste_manager_service.dart';
import 'command.dart';

class UpdateWasteManagerCommand implements Command {
  final WasteManagerService service;
  final WasteManager wasteManager;

  UpdateWasteManagerCommand(this.service, this.wasteManager);

  @override
  Future<void> execute() async {
    print(
        'Executing UpdateWasteManagerCommand for ID: ${wasteManager.userId}');
    await service.updateWasteManager(wasteManager);
  }
}
