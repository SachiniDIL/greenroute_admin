// lib/services/schedule_service.dart

import 'package:greenroute_admin/models/schedule.dart';
import 'package:greenroute_admin/api/api_client.dart';

class ScheduleService {


  ScheduleService();
  final apiClient = ApiClient();

  // Method to find the next scheduleId and set it to the user object
  Future<String> assignNextScheduleId() async {
    // Fetch all schedules from the Firebase database
    final usersData = await apiClient.get('schedules.json');

    if (usersData != null) {
      // Extract the list of schedule IDs and find the highest one
      List<String> userIds = [];
      usersData.forEach((key, value) {
        userIds.add(value['scheduleId']);
      });

      // Sort the schedule IDs in ascending order
      userIds.sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      // Find the next available scheduleId by incrementing the highest one
      String nextUserId = (int.parse(userIds.last) + 1).toString();

      // Assign the new scheduleId to the user object
      return nextUserId;
    } else {
      // If no schedule exist, start with scheduleId "1"
      return '1';
    }
  }

  // Fetch all schedules
  Future<List<Schedule>> fetchSchedules() async {
    final response = await apiClient.get('schedules.json'); // Adjust the endpoint as needed
    return (response as Map<String, dynamic>).entries.map((entry) {
      return Schedule.fromJson(entry.value);
    }).toList();
  }

  // Create a new schedule
  Future<Schedule> createSchedule(Schedule schedule) async {
    final response = await apiClient.post('schedules.json', schedule.toJson());
    return Schedule.fromJson(response);
  }

  // Update an existing schedule
  Future<Schedule> updateSchedule(Schedule schedule) async {
    final response = await apiClient.put('schedules/${schedule.scheduleId}.json', schedule.toJson());
    return Schedule.fromJson(response);
  }

  // Delete a schedule
  Future<void> deleteSchedule(int scheduleId) async {
    await apiClient.delete('schedules/$scheduleId.json'); // Adjust the endpoint as needed
  }
}
