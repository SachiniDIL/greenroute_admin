// lib/providers/schedule_provider.dart

import 'package:flutter/material.dart';
import 'package:greenroute_admin/models/schedule.dart';
import 'package:greenroute_admin/services/schedule_service.dart';

class ScheduleProvider with ChangeNotifier {
  final ScheduleService scheduleService;

  List<Schedule> _schedules = [];
  List<Schedule> get schedules => _schedules;

  ScheduleProvider(this.scheduleService);

  // Fetch schedules from the service
  Future<void> fetchSchedules() async {
    _schedules = await scheduleService.fetchSchedules();
    notifyListeners(); // Notify listeners to rebuild UI
  }

  // Add a new schedule
  Future<void> addSchedule(Schedule schedule) async {
    final newSchedule = await scheduleService.createSchedule(schedule);
    _schedules.add(newSchedule);
    notifyListeners();
  }

  // Update an existing schedule
  Future<void> updateSchedule(Schedule schedule) async {
    final updatedSchedule = await scheduleService.updateSchedule(schedule);
    final index = _schedules.indexWhere((s) => s.scheduleId == updatedSchedule.scheduleId);
    if (index != -1) {
      _schedules[index] = updatedSchedule;
      notifyListeners();
    }
  }

  // Delete a schedule
  Future<void> deleteSchedule(int scheduleId) async {
    await scheduleService.deleteSchedule(scheduleId);
    _schedules.removeWhere((s) => s.scheduleId == scheduleId);
    notifyListeners();
  }
}
