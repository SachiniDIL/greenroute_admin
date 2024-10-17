// lib/providers/trash_bin_provider.dart
import 'package:flutter/material.dart';
import 'package:greenroute_admin/utils/snack_bar_util.dart';
import '../models/trash_bin.dart';
import '../services/trash_bin_service.dart';

class TrashBinProvider extends ChangeNotifier {
  final List<TrashBin> _bins = [];
  final TrashBinService _trashBinService = TrashBinService();

  List<TrashBin> get bins => _bins;

  Future<void> addPublicBin({
    required BuildContext context,
    required double latitude,
    required double longitude,
    required String name,
  }) async {
    try {
      _trashBinService.createPublicBin(
        latitude: latitude,
        longitude: longitude,
        name: name,
      );
      SnackbarUtils.showSnackbar(context, 'Public Location added successfully');
    } catch (e) {
      SnackbarUtils.showSnackbar(context, 'Failed to add the public location');
      print(e);
    }
  }
}
